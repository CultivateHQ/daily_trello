
defmodule DailyTrello.Decode do
  def decode(error = {:error, _}) do
    error
  end

  def decode({:board_name, [{"_value", name}]}) do
    {:ok, name}
  end


  def decode({:board_lists, card_lists}) do
    card_lists
        |> Enum.map(fn (card_list) ->
            %{
              name: card_list["name"],
              cards: card_list["cards"] |> Enum.map(fn (card) -> 
                card["name"]
              end)
            }
        end)
  end

  def decode({_, unknown}) do
    {:error, unknown}
  end

end
