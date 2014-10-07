
defmodule DailyTrello.Fetch do
  @user_agent  [ {"User-agent", "Elixir Cultivate's Daily Trello lolalolalo"} ]
  @base_url "https://trello.com/1"


  def fetch(command = {request_type, _}, credentials) do
    url(command, credentials)
      |> HTTPoison.get(@user_agent)
      |> handle_response(request_type)
  end

  def handle_response(%{status_code: 200, body: body}, request_type) do
    {request_type, :jsxn.decode(body) }
  end

  def handle_response(%{status_code: status_code, body: body}, _) do
    {:error, %{status_code: status_code, body: body}}
  end


  def url(command, {key, token}) do
    case command do
      {:board_name, {board_id}} -> "#{@base_url}/boards/#{board_id}/name?key=#{key}&token=#{token}"
      {:board_lists,{board_id}} -> "#{@base_url}/boards/#{board_id}/lists?cards=open&card_fields=name&key=#{key}&token=#{token}"
      {:card_list_changes,{card_id}} -> "#{@base_url}/cards/#{card_id}/actions?filter=updateCard:idList&key=#{key}&token=#{token}"
    end

  end
  
end
