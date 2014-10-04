
defmodule DailyTrello do
  def process_boards board_ids do
    board_ids
        |> Enum.map(fn (id)-> 
          DailyTrello.Fetch.fetch({:board_name, id}) #|> process_board_name
        end)
    |> inspect
    |> IO.puts
  end
end
