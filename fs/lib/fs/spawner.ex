defmodule FS.Spawner do
  use GenServer

  @doc """
  Starts the spawner.
  """

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Spawn the supervisor process.
  """

  def start_supervisor(server, name) do
    GenServer.cast(server, {:create, name})
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
		# {:ok, supervisor} = KV.Supervisor.start_link([])
    {:noreply, "Got cast."}
  end
end
