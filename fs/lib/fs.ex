defmodule FS do
  @doc """
    TODO
    code for searching audio on remote node
  """
  def search(_requested_audio, from) do
    IO.puts("search for audio")
    receive_search_response(from, "requested audio")
  end

  @doc """
    TODO
    code for writing audio on local node
  """
  def write_file(_response) do
    IO.puts("audio file received")
  end

  @doc """
  the method that is called when sending a search request to a remote node
  """
  def send_search_request(recipient, requested_audio) do
    spawn_task(__MODULE__, :search, recipient, [requested_audio, Node.self()])
  end

  def receive_search_response(recipient, response) do
    spawn_task(__MODULE__, :write_file, recipient, [response])
  end

  @doc """
  Spawns a supervisor on a remote node and adds a task to in the supervision tree
  Waits for the task to complete and Pipes the output to the current(Parent) node
  Look up Task.supervisor and IO for more details.
  """
  def spawn_task(module, fun, recipient, args) do
    recipient
    |> remote_supervisor()
    |> Task.Supervisor.async(module, fun, args)
    |> Task.await()
  end

  defp remote_supervisor(recipient) do
    {FS.TaskSupervisor, recipient}
  end
end
