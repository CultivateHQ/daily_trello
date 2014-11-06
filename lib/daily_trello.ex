
defmodule DailyTrello do
  import DailyTrello.Decode, [only: [decode: 1]]
  import DailyTrello.Fetch, [only: [fetch: 2]]
  require EEx

  defmodule DailyBoard do
    defstruct name: "",
              id: "",
              date: {0,0,0},
              todo: [],
              blocked: [],
              doing: [],
              pr_submitted: [],
              ready_for_signoff: [],
              done: [],
              for_triage: [],
              done_today: []



  end

  EEx.function_from_file :def, :board_output, "#{__DIR__}/eex/board.eex", [:board]



  def process_boards board_ids, credentials do
    board_ids
    |> Parallel.pmap(fn(id) -> process_board(id, credentials) end)
    |> Enum.map(fn(board) -> board_output(board) end)
    |> IO.puts
  end


  def process_board(board_id, credentials) do
    board_name = fetch({:board_name, {board_id}}, credentials)   |> decode
    IO.puts :stderr, "Fetching: #{board_name}"
    board_lists = fetch({:board_lists, {board_id}}, credentials) |> decode
    done_today = filter_done_today(board_lists, credentials)
    %DailyBoard{
      name: board_name,
      id: board_id,
      date: :erlang.localtime,
      todo: board_lists["To Do"] || [],
      blocked: board_lists["Blocked"] || [],
      doing: board_lists["Doing"] || [],
      pr_submitted: board_lists["Pull Request Submitted"] || [],
      ready_for_signoff: board_lists["Ready for Sign-off"] || [],
      done: board_lists["Done"] || [],
      for_triage: board_lists["For Triage"],
      done_today: done_today || [],
    }
  end

  def filter_done_today(%{"Done" => done}, credentials) do
    IO.puts :stderr, "Checking Done card status"
    done
      |> Parallel.pmap(fn(card) ->
        {card |> card_moved_to_list_name_on_day?(:erlang.date, "Done", credentials), card}
      end)
      |> Enum.filter_map(
        fn({should_include, _}) -> should_include end,
          fn({_, card}) -> card end
      )
  end

  def card_moved_to_list_name_on_day?(card, day,  list_name, credentials) do
    fetch({:card_list_changes, {card.id}}, credentials) 
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
