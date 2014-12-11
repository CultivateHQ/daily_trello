
defmodule DailyTrello.CLI do

  def main(argv) do
    argv
      |> parse_args
      |> process
  end

  

  def parse_args(argv) do
    parse = OptionParser.parse(argv,
    aliases: [h: :help, k: :key, t: :token], switches: [help: :boolean]) 
    {keys, boards, _} = parse
    case {keys |> process_args, boards} do
      {%{help: true}, _} -> :help
      {_, []}            -> :help
      {%{key: key, token: token, date: date}, boards}        -> {:daily_trello, boards, {key, token}, date}
    end
  end


  def process :help do
    IO.puts :stderr, """
    usage: daily_trello [-k key -t token --date done_date_today] board1id [other board ids]
           If key and token are not provided, then will attempt to use the environment variables $TRELLO_KEY AND $TRELLO_TOKEN.
           Optional done_date_today is the date used as 'today' when determining which cards were moved into done 'today'. Defaults to the current date.
    """
  end


  def process {:daily_trello, board_ids, credentials, today} do
    DailyTrello.process_boards board_ids, credentials, today
  end


  defp env_key do
    System.get_env("TRELLO_KEY")
  end

  defp env_token do
    System.get_env("TRELLO_TOKEN")
  end


  defp process_args(parsed_args) do
    key = parsed_args |> Keyword.get(:key, env_key)
    token = parsed_args |> Keyword.get(:token, env_token)
    help = parsed_args |> Keyword.get(:help, false)
    date = parsed_args |> Keyword.get(:date) |> parse_date
    %{key: key, token: token, help: help, date: date}
  end

  defp parse_date nil do
    :erlang.date
  end

  defp parse_date strdate do
    try do
      [year, month, day] = strdate 
                            |> String.split("-") 
                            |> Enum.map(&String.to_integer/1)
      case :calendar.valid_date(year, month, day) do
        true -> {year, month, day}
      end
    rescue
      _e ->  raise "Please use date format yyyy-mm-dd."
    end
  end

end
