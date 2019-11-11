defmodule FS do
  @doc """
    TODO
    code for searching audio on remote node
  """
  def remote_search(requested_audio, from) do
    IO.puts("search for audio")
		case SongCollection.read(requested_audio) do 
			{:ok, song } -> #TODO send response that we have the file. 
			{:NA} -> #TODO send response that we don't have the file.
    # example code to read a file
    file = File.read!('files/test_file.txt')
    send_file(from, file)
  end

  @doc """
    TODO
    code for writing audio on local node
  """
  def write_file(file) do
    # example working code to write the file in tmp folder
    File.write!("tmp/test_file.txt", file)
  end

  @doc """
  the method that is called when sending a search request to a remote node
  """
  def send_search_request(recipient, requested_audio) do
    spawn_task(__MODULE__, :remote_search, recipient, [requested_audio, Node.self()])
  end

  def send_file(recipient, file) do
    spawn_task(__MODULE__, :write_file, recipient, [file])
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
