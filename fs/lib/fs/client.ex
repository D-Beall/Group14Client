defmodule FS.Client do

	def update_songs(song_info) do
		#Updates the song.csv file in the files directory.
		#song_info- Dictionary of :Artist and :Song to update file with.
		song = song_info[:Song]
		artist = song_info[:Artist]
		path = Path.expand("~")
		{:ok, file} = File.open("#{path}/.songs.csv", [:append])
		IO.binwrite(file,"#{artist},#{song}")
		IO.binwrite(file,'\n')
		File.close(file) 
	
	end

	def handle_responses(responses,request,args) do
		#Function to handle the responses from the server.
		#responses- list of responses given from a Mint.HTTP.stream
		#request- which request is calling the function.i.e. download etc.
		#args- additional data required to handle a response. 
		for response <- responses do
			case response do

			#Status code
			{:status, _request_ref, status_code}->
				case request do
				_ ->IO.puts("> Response status code #{status_code}")
				end

			#Headers
				{:headers, _request_ref, headers}->
				case request do
				{:download} -> IO.puts("Headers Received.")	
				_ ->IO.puts("> Response headers: #{inspect(headers)}")
				end

			#Data
				{:data, _request_ref, data}->
				case request do
				#Download post request
				{:download} ->
				split = String.split(data)
				url = Enum.at(split,1)
				file_name = String.split(url,"/")
				file_name = List.last(file_name)
				file_extension = List.last(String.split(file_name, "."))
				path = Path.expand("~")
				#Download song from server
				System.cmd("wget",["-N","-P","#{path}/.songs/",url])
				#Rename file
				artist = args[:Artist]
				song = args[:Song]
				System.cmd("cp",["#{path}/.songs/#{file_name}","#{path}/.songs/#{artist}-#{song}.#{file_extension}"])
				#Delete original file from server
				System.cmd("rm", ["#{path}/.songs/#{file_name}"])
				_ ->IO.puts("> Response body")
						IO.puts(data)
				end

			#Done
			{:done, _request_ref} ->
				case request do
				_ ->IO.puts("> Response received")
				end

			#Other
			_ -> IO.puts("GOT other stuff.")

			end
		end
	end

	def get do
		#connect to server
		{:ok, conn} = Mint.HTTP.connect(:http, "xzy3.cs.seas.gwu.edu", 8085)
		#read audio name from user
		audioName = IO.gets("Enter name of file: ")
		IO.puts(audioName) #TEMP
		#send request
		{:ok, conn, _request_ref} = Mint.HTTP.request(conn, "GET", "/hello", [], "")
		#receive message
		receive do
			message ->
				{:ok, _conn, responses} = Mint.HTTP.stream(conn, message)
				handle_responses(responses,{:get},{})
		end
		Mint.HTTP.close(conn)
	end

	@doc """
	Attempts to call http request to the server.
	Requests the urls to use to request a file from the server.
	
	artist- string of artist/author name.
	song- string of title of song/book etc.
	"""
	def server_download(artist, song) do
		IO.puts("Server download.")
		list = [song_name: "#{song}"]
		{_status, result} = JSON.encode(list)
		#connect to server
		server_conn = Mint.HTTP.connect(:http, "xzy3.cs.seas.gwu.edu", 8085)
		case server_conn do
			{:ok, conn}->
				#send post request with json data
				{:ok, conn, _request_ref} = Mint.HTTP.request(conn, "POST", "/download", [{"content-type", "application/json"}], result)
				#receive message
				receive do
					message ->
					x = Mint.HTTP.stream(conn, message)
						case x do
							{:ok, _conn, responses}->handle_responses(responses,{:download},%{Artist: "#{artist}", Song: "#{song}"})

							{:error, _conn, reason, _responses}->IO.inspect(reason)

							:unkown->IO.puts("Message is not from conn socket.")
						end
				end
			{:error, reason}->IO.puts("Error received. Can not connect to server.")
		end
	end

	@doc """
	Makes get request to the server to receive files.
	"""	
	def get_files(_url) do
		#connect to server
		#{:ok, _conn} = Mint.HTTP.connect(:http, "xzy3.cs.seas.gwu.edu", 8085)

	end

end
