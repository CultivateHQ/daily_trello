defmodule DecodeTest do
  use ExUnit.Case
  import DailyTrello.Decode, only: [ decode: 1]


  test "errors return themselves" do
    error = {:error, %{status_code: 500, body: "oh dear"}}
    assert decode(error) == error
  end

  test "decodes repository name" do
     assert decode({:board_name, %{"_value" => "ExampleBoard"}}) == "ExampleBoard"
  end


  test "unexpected json for board name is handled as an error" do
    assert decode({:board_name, [{"_wtf", "is this"}]}) == {:error, [{"_wtf", "is this"}]}
  end


  test "decodes board list as map of cards to board names" do
    lists = {:board_lists, File.read!("#{__DIR__}/board_list_fixture.json") |> :jsxn.decode}
    result = decode(lists)

    # Not a great test, as it relies on transforming (the captured) json from another file,
    # but I'm living with it for now
    assert result == %{
      "To Do" => [%DailyTrello.Card{id: "54300b2d28958ff2f0400aed", name: "Do this"}, %DailyTrello.Card{id: "54300b2fe1cb63546e457498", name: "Do that"}, %DailyTrello.Card{id: "54300b341079b25d6a450e11", name: "Do the other"}],
      "Doing" => [%DailyTrello.Card{id: "54300b41cbe74395ecc59c46", name: "Doing this thing"}, %DailyTrello.Card{id: "54300b465dedf01818cb93c4", name: "Doing this other thing"}],
      "For Review" => [%DailyTrello.Card{id: "54300b550e0eff57ec7409ea", name: "This needs reviewing"}, %DailyTrello.Card{id: "54300b5cece07847ec067a56", name: "This too needs reviewing"}],
      "Done" => [%DailyTrello.Card{id: "54300b6b176dafc4941e3e4b", name: "Done 1"}, %DailyTrello.Card{id: "54300b6dd8242abb6c9d7c0d", name: "Done 2"}, %DailyTrello.Card{id: "54300b6f5c9beade177d7561", name: "Done 3"}],
    }
    
    
    
    

  end






end
