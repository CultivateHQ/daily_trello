defmodule Parallel do
  def pmap(coll, fun) do
    me = self
    coll
    |> Enum.map(fn (el) ->
      spawn_link fn ->
        send me, { self, fun.(el)}
      end
    end)
    |> Enum.map(fn (pid) ->
      receive do
        {^pid, result} -> result
      end
    end)
  end
end

