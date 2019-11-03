defmodule FS.Test do
  use GenServer
  def start_link(opts) do
    # Node.list()
    # IO.puts "called #{}"
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  @impl true
  def handle_call(:request, _from, :state) do
    {:reply, "Got call."}
  end

  @impl true
  def handle_cast({:create, _name}, _names) do
    {:noreply, "Got cast."}
  end

end
