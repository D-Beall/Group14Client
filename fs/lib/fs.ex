defmodule FS do
  def remote_search(requested_audio, from) do
    IO.puts("search for audio")
    # case SongCollection.read(requested_audio) do

    send_search_response(
      from,
      {:ok, "Radiohead Paranoid Android.mp3"},
      Node.self()
    )

  end

  def remote_read_file(file_name, from) do
    file = File.read!('files/#{file_name}')
    send_write_file(from, file_name, file)
  end

  @doc """
    TODO
    code for writing audio on local node
  """
  def write_file(file_name, file) do
    # example working code to write the file in tmp folder
    File.write!('tmp/#{file_name}', file)
  end

  def parse_search_response(response, node_with_the_file) do
    case response do
      {:ok, file_name} -> send_read_file(node_with_the_file, file_name)
      {:NA} -> IO.puts("Ends here")
    end
  end

  @doc """
  the method that is called when sending a search request to a remote node
  """
  def send_search_request(recipient, requested_audio) do
    spawn_task(__MODULE__, :remote_search, recipient, [requested_audio, Node.self()])
  end

  def send_read_file(recipient, file_name) do
    spawn_task(__MODULE__, :remote_read_file, recipient, [file_name, Node.self()])
  end

  def send_write_file(recipient, file_name, file) do
    spawn_task(__MODULE__, :write_file, recipient, [file_name, file])
  end

  def send_search_response(recipient, response, node_with_the_file) do
    spawn_task(__MODULE__, :parse_search_response, recipient, [response, node_with_the_file])
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
