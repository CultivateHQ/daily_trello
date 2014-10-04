
defmodule DailyTrello.CLI do

  def main(argv) do
    argv
      |> parse_args
      |> process
  end

  

  def parse_args(argv) do
    parse = OptionParser.parse(argv, 
    switches: [ help: :boolean],
    aliases:  [ h: :help])

    case parse do
      {[ help: true], _, _} -> :help
      {_, [], _}            -> :help
      {_, boards, _}        -> {:daily_trello, boards}
    end
  end


  def process :help do
    IO.puts :stderr, """
    usage: daily_trello board1id [other board ids]
    """
  end


  def process {:daily_trello, board_ids} do
    DailyTrello.process_boards board_ids
  end

end
