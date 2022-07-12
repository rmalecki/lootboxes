defmodule LootboxesTest do
  use ExUnit.Case
  doctest Lootboxes

  @char [65, 66, 67]

  test "pick random rarities" do
    {pack, history} =
      Lootboxes.create_rarities(
        [9, 1],
        [],
        1000
      )

    pack |> Enum.map(&Enum.at(@char, &1)) |> inspect() |> IO.puts()

    0..1
    |> Enum.map(fn r ->
      Enum.count(history, &(&1 == r))
    end)
    |> inspect()
    |> IO.puts()

    assert Enum.all?(pack, fn x -> x >= 0 and x < 4 end)
  end

  test "history" do
    assert [0, 0, 0, 2, 3, 1]
           |> Lootboxes.picks_without_rarity(2) == 3
  end

  test "prioritize" do
    assert [0.90, 0.8, 0.15]
           |> Lootboxes.prioritize()
           |> Enum.sum() == 1.0
  end
end
