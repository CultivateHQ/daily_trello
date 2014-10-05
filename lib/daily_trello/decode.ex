
defmodule DailyTrello.Decode do
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
                card["name"]
              end)
              acc |> Map.put(card_list["name"], cards)
        end)
  end

  def decode({_, unknown}) do
    {:error, unknown}
  end

end
