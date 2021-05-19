defmodule Lootboxes do
  @moduledoc """
  Documentation for `Lootboxes`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Lootboxes.hello()
      :world

  """
  def hello do
    :world
  end

  def create_rarities(probabilities, history, count) do
    probabilities = normalize(probabilities)

    1..count
    |> Enum.reduce({[], history}, fn _, {pack, new_history} ->
      {r, new_history} = pick_rarity(new_history, probabilities)
      {[r | pack], new_history}
    end)
  end

  defp pick_rarity(history, probabilities) do
    x = :rand.uniform()

    # adjust probability depending on history
    adjusted_probabilities =
      probabilities
      |> Enum.zip(0..9)
      |> Enum.map(fn {p, n} ->
        expected_phase = 1 / min(1, p)
        # historic picks without any of that rarity
        historic_phase = history |> Enum.take_while(&(&1 != n)) |> Enum.count()

        p + max(0, 1.0 - p) * historic_phase / expected_phase
      end)

    adjusted_probabilities |> inspect() |> IO.puts()

    r =
      Enum.reduce_while(probabilities, {0, 0}, fn p, {n, p_total} ->
        if x < p_total + p, do: {:halt, n}, else: {:cont, {n + 1, p_total + p}}
      end)

    {r, [r | history]}
  end

  defp normalize(p) do
    total = Enum.sum(p)
    Enum.map(p, fn x -> x / total end)
  end
end
