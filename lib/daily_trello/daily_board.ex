defmodule DailyTrello.DailyBoardCards do
  defstruct todo: [],
            doing: [],
            inreview: [],
            done: [],
            done_today: []
end
defmodule DailyTrello.DailyBoard do
  defstruct name: "",
            id: "",
            date: {0,0,0},
            cards: nil



end
