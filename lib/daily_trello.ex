
defmodule DailyTrello do
  import DailyTrello.Decode, [only: [decode: 1]]
  import DailyTrello.Fetch, [only: [fetch: 1]]
  def process_boards board_ids do
    board_ids
    |> Enum.map(fn(id) -> process_board(id) end)
    |> inspect
    |> IO.puts
  end


  def process_board(board_id) do
    board_name = fetch({:board_name, {board_id}}) |> decode
    board_lists = fetch({:board_lists, {board_id}})

    {board_name, board_lists}
  end
end
