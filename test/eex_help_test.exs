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


  test "display multiple queues" do
    assert display_queues([{"To Do", a_card_list}]) == """
    To Do
    -----

    * card 1
    * card 2
    """
    assert display_queues([{"To Do", a_card_list}, {"Doing", a_card_list}]) == """
    To Do
    -----

    * card 1
    * card 2

    Doing
    -----

    * card 1
    * card 2
    """
  end


  test "empty queues totally ignored when displaying multiple queues" do
    assert display_queues([{"For Triage", []}, {"To Do", a_card_list}, {"Not", []}]) == """
    To Do
    -----

    * card 1
    * card 2
    """
  end


  defp a_card_list(list \\ ["card 1", "card 2"]) do
    list |> Enum.map(fn c -> %DailyTrello.Card{name: c} end)
  end


  


end
