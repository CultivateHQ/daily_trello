defmodule DailyTrello.Card do
  defstruct name: "", id: "", date_last_activity: nil
end

defmodule DailyTrello.Decode do
  alias DailyTrello.Card
  use Timex
  def decode(error = {:error, _}) do
    error
  end

  def decode({:board_name, %{"_value" => name}}) do
    name
  end

  def decode({:board_lists, card_lists}) do
    card_lists
        |> Enum.reduce(%{}, fn (card_list, acc) ->
              cards = card_list["cards"] |> Enum.map(fn (card) ->
                %Card{name: card["name"], id: card["id"], date_last_activity: card["dateLastActivity"] |> parse_date_time}
              end)
              acc |> Map.put(card_list["name"], cards)
        end)
  end


  def decode({:card_list_changes, actions}) do
    for action <- actions, do: {action["date"], action["data"]["listAfter"]["name"]}
  end

  def decode({_, unknown}) do
    {:error, unknown}
  end

  defp parse_date_time datetime do
    DateFormat.parse(datetime, "{YYYY}-{M}-{D}T{h24}:{m}:{s}.{ss}Z")
      |> to_erlang_date
  end

  defp to_erlang_date {:ok, %{year: year, month: month, day: day, hour: hour, minute: minute, second: second}} do
    {{year, month, day}, {hour, minute, second}} 
  end
end
