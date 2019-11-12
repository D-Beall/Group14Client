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
  def read(song_info) do
		#Search our song.csv for the song and artist requested.
		#Input: song_info- dictionary of Artist and Song of the
		#request information.
		wanted_song = Map.fetch(song_info, :Song)
		wanted_artist = Map.fetch(song_info, :Artist)
    songs = "../files/song.csv"
    |> Path.expand(__DIR__)
    |> File.stream!
    |> CSV.decode(separator: ?,, headers: [:Artist, :Song])
    |> Enum.to_list()
		|> Enum.map(fn(x)->x[:ok][:Artist] end)
		#|> Enum.map(fn(x)->x[:ok][:Artist] == wanted_artist && x[:ok][:Song] == wanted_song end)
    IO.inspect(songs)
  end

end
