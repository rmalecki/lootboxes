defmodule Lootboxes do
  @moduledoc """
  Documentation for `Lootboxes`.
  """

  def create_rarities(probabilities, history, count) do
    probabilities = normalize(probabilities)

    1..count
    |> Enum.reduce({[], history}, fn _, {pack, new_history} ->
      {r, new_history} = pick_rarity(new_history, probabilities)
      {[r | pack], new_history}
    end)
  end

  def picks_without_rarity(history, r) do
    history |> Enum.take_while(&(&1 != r)) |> Enum.count()
  end

  def picks_for_rarity(history, r) do
    Enum.count(history, &(&1 == r))
  end

  defp calc_adjusted_probability([], p, _r), do: p

  defp calc_adjusted_probability(history, p, r) do
    expected_picks_for_rarity = Enum.count(history) * p

    min(
      1,
      p +
        2 * max(0, expected_picks_for_rarity - picks_for_rarity(history, r)) /
          expected_picks_for_rarity
    )
  end

  defp pick_rarity(history, probabilities) do
    x = :rand.uniform()

    # boost probabilities if unlucky historic picks
    adjusted_probabilities =
      probabilities
      |> Enum.zip(0..9)
      |> Enum.map(fn {p, r} ->
        calc_adjusted_probability(history, p, r)
      end)

    adjusted_probabilities =
      adjusted_probabilities |> Enum.reverse() |> prioritize() |> Enum.reverse()

    r =
      Enum.reduce_while(adjusted_probabilities, {0, 0}, fn p, {n, p_total} ->
        if x < p_total + p, do: {:halt, n}, else: {:cont, {n + 1, p_total + p}}
      end)

    {r, [r | history]}
  end

  defp normalize(p) do
    total = Enum.sum(p)
    Enum.map(p, fn x -> x / total end)
  end

  def prioritize(probabilities, weight \\ 1)

  def prioritize([_x], weight) do
    [weight]
  end

  def prioritize([x | rest], weight) do
    [x * weight | prioritize(rest, weight - x * weight)]
  end
end
