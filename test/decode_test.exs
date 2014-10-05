defmodule DecodeTest do
  use ExUnit.Case
  import DailyTrello.Decode, only: [ decode: 1]


  test "errors return themselves" do
    error = {:error, %{status_code: 500, body: "oh dear"}}
    assert decode(error) == error
  end

  test "decodes repository name" do
     assert decode({:board_name, [{"_value", "ExampleBoard"}]}) == {:ok, "ExampleBoard"}
  end


  test "unexpected json for board name is handled as an error" do
    assert decode({:board_name, [{"_wtf", "is this"}]}) == {:error, [{"_wtf", "is this"}]}
  end


  test "decodes board list as map of cards to board names" do
    lists = {:board_lists, File.read!("#{__DIR__}/board_list_fixture.json") |> :jsxn.decode}
    result = decode(lists)
    assert result == %{}
  end






end
