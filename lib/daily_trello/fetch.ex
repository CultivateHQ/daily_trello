
defmodule DailyTrello.Fetch do
  @user_agent  [ {"User-agent", "Elixir Cultivate's Daily Trello lolalolalo"} ]
  @base_url "https://trello.com/1"


  def fetch(command) do
    fetch command, env_credentials
  end

  def fetch(command, credentials) do
    url(command, credentials)
      |> HTTPoison.get(@user_agent)
      |> handle_response
  end

  def handle_response(%{status_code: 200, body: body}) do
    {:ok, :jsx.decode(body) }
  end

  def handle_response(%{status_code: status_code, body: body}) do
    {:error, %{status_code: status_code, body: body}}
  end


  def env_credentials do
    {System.get_env("TRELLO_KEY"), System.get_env("TRELLO_TOKEN")}
  end

  def url(command, {key, token}) do
    case command do
      {:board_name, board_id} -> "#{@base_url}/boards/#{board_id}/name?key=#{key}&token=#{token}"
      {:board_lists, board_id} -> "#{@base_url}/boards/#{board_id}/lists?cards=open&card_fields=name&key=#{key}&token=#{token}"
    end

  end
  
end
