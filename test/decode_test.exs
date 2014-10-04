defmodule DecodeTest do
  use ExUnit.Case
  import DailyTrello.Decode, only: [ decode: 1]


  test "errors return themselves" do
    error = {:error, %{status_code: 500, body: "oh dear"}}
    assert decode(error) == error
  end



end
