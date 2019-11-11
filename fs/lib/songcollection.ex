
defmodule SongCollection do
  # use CSV
  def init() do
    {:ok, %{}}
    # File.mkdir!("files")
    # File.cd!("files")
    # File.touch!("song.csv")
    {:ok, file} = File.open("files/song.txt", [:write])
    # IO.puts("hello from init")
    IO.write(file, "hello,world")
  end
  def write() do
    {:ok, file} = File.open("files/song.txt", [:write])
    # IO.puts("hello from init")
    IO.write(file, "hello,world")
  end
  def read() do
    songs = "../files/song.csv"
    |> Path.expand(__DIR__)
    |> File.stream!
    |> CSV.decode(separator: ?,, headers: [:Arist, :Song])
    |> Enum.to_list()
    IO.inspect(songs)
		#TODO get artist and song from function parameter.
		wanted_song = "NA"
		wanted_artist = "NA"
    list = for {:ok, n } <- songs do
				if Map.fetch(n, :Artist) == wanted_artist && Map.fetch(n, :Song) == wanted_song do
					IO.puts("FOUND")
					#TODO send file to requester.
				else 
					IO.puts("NO MATCH")
					#TODO tell requester no such song on this user.
				end
		end

    # IO.inspect(list)
  end

  # use GenServer
  # # use CSV
  # def start_link(opts) do
  #   # Node.list()
  #   # IO.puts "called #{}"
  #   GenServer.start_link(__MODULE__, :ok, opts)
  # end

  # @impl true
  # def init(:ok) do
  #   {:ok, %{}}
  #   file = File.open!("/files/song.csv")
  #   IO.puts("hello from init")
  #   IO.write(file, "hello world")
  # end

  # @impl true
  # def handle_call(:request, _from, :state) do
  #   {:reply, "Got call."}
  # end

  # @impl true
  # def handle_cast({:create, _name}, _names) do
  #   {:noreply, "Got cast."}
  # end
end
