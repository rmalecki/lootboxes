defmodule LootboxesTest do
  use ExUnit.Case
  doctest Lootboxes

  test "pick 100 random rarities" do
    {pack, history} =
      Lootboxes.create_rarities(
        [80, 20, 5, 1],
        [
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          2,
          1,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          2,
          1,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          2,
          1,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          2,
          1,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          2,
          1,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          2,
          1,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          3
        ],
        5
      )

    pack |> inspect() |> IO.puts()
    assert Enum.all?(pack, fn x -> x >= 0 and x < 4 end)
  end
end
