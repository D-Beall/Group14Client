defmodule SongCollection do
  def write() do
    {:ok, file} = File.open("files/song.txt", [:write])
    # IO.puts("hello from init")
    IO.write(file, "hello,world")
  end
  def read(song_info) do
		#Search our song.csv for the song and artist requested.
		#Input: song_info- dictionary of Artist and Song of the
		#request information.
		wanted_song = song_info[:Song]
		wanted_artist = song_info[:Artist]
    song = "../files/song.csv"
    |> Path.expand(__DIR__)
    |> File.stream!
    |> CSV.decode(separator: ?,, headers: [:Artist, :Song])
    |> Enum.to_list()
    |> Enum.find(fn(x)->
      {:ok, track_info } = x
      artist = track_info[:Artist]
      song  = track_info[:Song]
      artist == wanted_artist && song == wanted_song
    end
    )
    # |> Enum.reduce( fn ->
    # end)
  end
end
