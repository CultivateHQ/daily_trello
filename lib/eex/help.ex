defmodule DailyTrello.Eex.Help do

  def card_list(cards) do
    cards 
      |> Enum.map(fn card -> "* #{card.name}" end)
      |> Enum.join("\n")
  end


  def display_cards(_list_name, []) do
    ""
  end
  def display_cards(list_name, cards) do
    """
    #{list_name}
    #{String.duplicate("-", String.length(list_name))}

    #{cards |> card_list}
    """
  end


  def display_queues(queues) do
    queues 
    |> Enum.map(fn {name, cards} ->
      display_cards(name, cards)
    end)
      |> Enum.filter(fn text ->
        text != ""
      end)
    |> Enum.join("\n")
      


  end

end
