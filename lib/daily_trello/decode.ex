defmodule DailyTrello.Card do
  defstruct name: "", id: ""
end

defmodule DailyTrello.Decode do
  alias DailyTrello.Card 
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
                %Card{name: card["name"], id: card["id"]}
              end)
              acc |> Map.put(card_list["name"], cards)
        end)
  end

  def decode({_, unknown}) do
    {:error, unknown}
  end

end
