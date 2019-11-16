defmodule FS do
  def remote_search(requested_audio) do
    IO.puts("search for audio")
    response = SongCollection.read(requested_audio)
    Tuple.insert_at(response, 2, Node.self())
  end

  def remote_read_file(file_name) do
    file = File.read!('files/#{file_name}')
    {file_name, file}
  end

  @doc """
    TODO
    code for writing audio on local node
  """
  def write_file(response) do
    # example working code to write the file in tmp folder
    {file_name, file} = response
    File.write!('tmp/#{file_name}', file)
  end

  def search_network(requested_audio) do
    response =
      Stream.map(Node.list(), fn node -> search_request(node, requested_audio) end)
      |> Enum.to_list()
      |> List.first()

    case response do
      {:ok, file_name, node_with_the_file} ->
        read_and_write_file(node_with_the_file, file_name)

      _ ->
        :SONG_NOT_FOUND
    end
  end

  @doc """
  the method that is called when sending a search request to a remote node
  """
  def search_request(recipient, requested_audio) do
    spawn_task(__MODULE__, :remote_search, recipient, [requested_audio])
  end

  def read_and_write_file(recipient, file_name) do
    response = spawn_task(__MODULE__, :remote_read_file, recipient, [file_name])
    write_file(response)
    {:ok}
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
