
defmodule DailyTrello.CLI do

  def main(argv) do
    argv
      |> parse_args
      |> process
  end

  

  def parse_args(argv) do
    parse = OptionParser.parse(argv,
    aliases: [h: :help, k: :key, t: :token]) 
    case parse do
      {[ help: true], _, _} -> :help
      {_, [], _}            -> :help
      {[key: key, token: token], boards, _}        -> {:daily_trello, boards, {key, token}}
      {_, boards, _}        -> {:daily_trello, boards, env_credentials}
    end
  end


  def process :help do
    IO.puts :stderr, """
    usage: daily_trello [-k key -t token] board1id [other board ids]
           If key and token are not provided, then will attempt to use the environment variables $TRELLO_KEY AND $TRELLO_TOKEN.
    """
  end


  def process {:daily_trello, board_ids, credentials} do
    DailyTrello.process_boards board_ids, credentials
  end

  def env_credentials do
    {System.get_env("TRELLO_KEY"), System.get_env("TRELLO_TOKEN")}
  end

end
