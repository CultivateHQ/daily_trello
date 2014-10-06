
defmodule DailyTrello do
  import DailyTrello.Decode, [only: [decode: 1]]
  import DailyTrello.Fetch, [only: [fetch: 1]]
  require EEx

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

  EEx.function_from_file :def, :board_output, "#{__DIR__}/eex/board.eex", [:board]



  def process_boards board_ids do
    board_ids
    |> Enum.map(fn(id) -> process_board(id) end)
    |> Enum.map(fn(board) -> board_output(board) end)
    |> IO.puts
  end


  def process_board(board_id) do
    board_name = fetch({:board_name, {board_id}})   |> decode
    board_lists = fetch({:board_lists, {board_id}}) |> decode
    done_today = filter_done_today(board_lists)
    %DailyBoard{
      name: board_name,
      id: board_id,
      date: :erlang.localtime,
      todo: board_lists["To Do"],
      doing: board_lists["Doing"],
      for_review: board_lists["For Review"],
      done: board_lists["Done"],
      done_today: done_today,
    }
  end

  def filter_done_today(%{"Done" => done}) do
    for card <- done, card |> card_moved_to_list_name_on_day?(:erlang.date, "Done"), do: card

  end

  def card_moved_to_list_name_on_day?(card, day,  list_name) do
    fetch({:card_list_changes, {card.id}}) 
      |> decode
      |> date_and_list_names_contains_match?(day, list_name)
  end


  def date_and_list_names_contains_match?(date_and_list_names, {year, month, day}, list_name) do
    comparison_date = :io_lib.format("~4..0B-~2..0B-~2..0B", [year, month, day]) |> List.flatten |> to_string
    date_and_list_names 
        |>  Enum.find(fn ({action_date_time, action_list_name}) ->
          action_date = action_date_time |> String.slice(0..9)
          action_list_name == list_name && action_date == comparison_date
        end) != nil
  end


end
