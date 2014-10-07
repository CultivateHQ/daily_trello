defmodule CliTest do
  use ExUnit.Case

  import DailyTrello.CLI, only: [ parse_args: 1, process: 1 ]
  import Mock

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h",     "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test ":help returned when no arguments are given" do
    assert parse_args([]) == :help
  end

  test "board ids returned when board ids are  passed in, with env variables" do
    System.put_env(%{"TRELLO_KEY" => "key", "TRELLO_TOKEN" => "token"}) 
    assert parse_args(["12345", "6780"]) == {:daily_trello, ["12345", "6780"], {"key", "token"}}
  end

  test "credentials when passed in are used" do
    assert parse_args(["-k", "Key", "-t", "Token", "12345", "6780"]) == {:daily_trello, ["12345", "6780"], {"Key", "Token"}}
    assert parse_args(["--key", "Key", "--token", "Token", "12345", "6780"]) == {:daily_trello, ["12345", "6780"], {"Key", "Token"}}
  end


  test_with_mock "help outputs help", IO, [puts: fn(:stderr, out) -> "#{out} standard_err" end] do

    output = process(:help)
    assert Regex.match?(~r/^usage/, output), output
    assert Regex.match?(~r/standard_err$/, output), output

  end

  test_with_mock "boards process boards", DailyTrello, [process_boards: fn(boards, credentials) -> "#{boards |> inspect} #{credentials |> inspect} processed" end] do
    assert process({:daily_trello, ["12345", "23456"], {"k", "t"}}) == "[\"12345\", \"23456\"] {\"k\", \"t\"} processed"
  end

end
