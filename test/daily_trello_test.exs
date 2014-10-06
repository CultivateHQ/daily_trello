defmodule DailyTrelloTest do
  use ExUnit.Case
  import DailyTrello, [only: [date_and_list_names_contains_match?: 3]]

  test "date and list_name contains match" do
    date_and_list_names = [{"2014-10-05T14:58:34.122Z", "Doing"}, {"2014-11-05T14:58:34.122Z", "Doing"}, {"2014-12-05T14:58:34.122Z", "Done"}]
    assert date_and_list_names |> date_and_list_names_contains_match?({2014,12,05}, "Doing") == false
    assert date_and_list_names |> date_and_list_names_contains_match?({2014,12,05}, "Done") == true
    assert date_and_list_names |> date_and_list_names_contains_match?({2014,11,05}, "Doing") == true
  end
end
