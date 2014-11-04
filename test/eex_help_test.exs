defmodule EexHelpTest do

  use ExUnit.Case

  import DailyTrello.Eex.Help


  test "card list" do
    assert card_list(a_card_list) == "* card 1\n* card 2"
  end

  test "display cards, when there are cards" do
    assert display_cards("Todo", a_card_list) == """
    Todo
    ----

    * card 1
    * card 2
    """

    assert display_cards("Doing", a_card_list) == """
    Doing
    -----

    * card 1
    * card 2
    """
  end

  test "display cards displays nothing when there are no cards" do
    assert display_cards("Doing", []) == ""
  end


  defp a_card_list do
    ["card 1", "card 2"] |> Enum.map(fn c -> %DailyTrello.Card{name: c} end)
  end


end
