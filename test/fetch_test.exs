

defmodule FetchTest do
  use ExUnit.Case

  import DailyTrello.Fetch

  @credentials {"mykey", "mytoken"}


  test "urls" do
    assert url({:board_name,  {"1234"}}, @credentials) == "https://trello.com/1/boards/1234/name?key=mykey&token=mytoken"
    assert url({:board_lists, {"1234"}}, @credentials) == "https://trello.com/1/boards/1234/lists?cards=open&card_fields=name&key=mykey&token=mytoken"
  end

  test "good response" do
    assert handle_response(%{status_code: 200, body: " {\"_value\":\"A thing\"} "}, :board_name) ==  {:board_name, %{"_value" => "A thing"}}
  end


  test "error resonse" do
    assert handle_response(%{status_code: 500, body: "Something bad happened"}, :board_name) ==  {:error, %{status_code: 500, body: "Something bad happened"}}
  end

end
