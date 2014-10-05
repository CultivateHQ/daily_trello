
defmodule DailyTrello do
  import DailyTrello.Decode, [only: [decode: 1]]
  import DailyTrello.Fetch, [only: [fetch: 1]]

  defmodule DailyBoard do
    defstruct name: "",
              id: "",
              date: {0,0,0},
              todo: [],
              doing: [],
              for_review: [],
              done: [],
              done_today: []



  end
  def process_boards board_ids do
    board_ids
    |> Enum.map(fn(id) -> process_board(id) end)
    |> inspect
    |> IO.puts
  end


  def process_board(board_id) do
    board_name = fetch({:board_name, {board_id}})   |> decode
    board_lists = fetch({:board_lists, {board_id}}) |> decode
    {board_name, board_lists}
    %DailyBoard{
      name: board_name,
      id: board_id,
      date: :erlang.localtime,
      todo: board_lists["To Do"],
      doing: board_lists["Doing"],
      for_review: board_lists["For Review"],
      done: board_lists["Done"]

    }
  end
end
