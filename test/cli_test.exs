defmodule CliTest do
  use ExUnit.Case

  import DailyTrello.CLI, only: [ parse_args: 1, process: 1 ]
  import Mock

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h",     "anything"]) == :help
    assert parse_args(["-h",     "anything", "arse"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test ":help returned when no arguments are given" do
    assert parse_args([]) == :help
  end

  test "board ids returned when board ids are  passed in, with env variables" do
    System.put_env(%{"TRELLO_KEY" => "key", "TRELLO_TOKEN" => "token"}) 
    assert parse_args(["12345", "6780"]) == {:daily_trello, ["12345", "6780"], {"key", "token"}, :erlang.date}
  end

  test "credentials when passed in are used" do
    assert parse_args(["-k", "argkey", "-t", "argtoken", "12345", "6780"]) == {:daily_trello, ["12345", "6780"], {"argkey", "argtoken"}, :erlang.date}
    assert parse_args(["--key", "argkey", "--token", "argtoken", "12345", "6780"]) == {:daily_trello, ["12345", "6780"], {"argkey", "argtoken"}, :erlang.date}
  end

  test "date passed in is used as the day, if present" do
    assert parse_args(["-k", "keyargs", "-t", "tokenargs", "--date", "2014-12-1", "12345", "6780"]) 
      == {:daily_trello, ["12345", "6780"], {"keyargs", "tokenargs"}, {2014, 12, 1}}
  end

  test "raises exceptions for invalid dates" do
    ["2014", "2014-11", "aardvark", "2014-13-11"] |> Enum.map(fn (baddate) ->
      assert_raise RuntimeError, "Please use date format yyyy-mm-dd.", fn -> parse_args(["--date", baddate]) end
    end)
  end



  test_with_mock "help outputs help", IO, [puts: fn(:stderr, out) -> "#{out} standard_err" end] do

    output = process(:help)
    assert Regex.match?(~r/^usage/, output), output
    assert Regex.match?(~r/standard_err$/, output), output

  end

  test_with_mock "boards process boards", DailyTrello, [process_boards: fn(boards, credentials, date) -> 
    "#{boards |> inspect} #{credentials |> inspect} #{date |> inspect} processed" end] do

    assert process({:daily_trello, ["12345", "23456"], {"k", "t"}, {2014,11,12}}) == "[\"12345\", \"23456\"] {\"k\", \"t\"} {2014, 11, 12} processed"
  end



end
