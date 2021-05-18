defmodule LootboxesTest do
  use ExUnit.Case
  doctest Lootboxes

  test "pick random rarities" do
    {pack, _history} =
      Lootboxes.create_rarities(
        [89, 9, 2],
        [],
        1000
      )

    #0..2 |> Enum.map(fn r ->
    #  Enum.count(history, &(&1 == r)) end)
    #  |> inspect() |> IO.puts()

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
