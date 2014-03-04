defmodule Stacker.Server do
  use GenServer.Behaviour

  def start_link() do
    :gen_server.start_link({:local, :stacker}, __MODULE__, [], [])
  end

  def init([]) do
    { :ok, [] }
  end
  
  def handle_call(:pop, _from, [h|stack]) do
    { :reply, h, stack }
    # {:reply, :hijack, stack}
  end
  
  def handle_cast({ :push, new }, stack) do
    { :noreply, [new|stack] }
  end

end