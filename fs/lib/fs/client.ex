defmodule FS.Client do

	def handle_responses(responses,request,_args) do
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
				#Resp contains list of dictionaries
				resp = JSON.decode!(data)
				IO.inspect(resp)
				size = Kernel.length(resp)
				case size do
					0 -> IO.puts("No such audio file on server.")
					_-> get_files(resp,size) 
				end
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
		list = [song_name: "#{song}", artist: "#{artist}"]
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
			{:error, _reason}->IO.puts("Error received. Can not connect to server.")
		end
	end

	@doc """
	Makes get request to the server to receive files.
	files-List of dictionaries with files to call get request on.
	size- Length of files if 1 don't make directory in .songs.
	file- artist: url: title:
	"""	
	def get_files(files,size) do
		title = List.first(files)["title"]
		artist = List.first(files)["artist"]
		if size > 1 do
			path = Path.expand("~")
			System.cmd("mkdir", ["#{path}/.songs/#{title}"])
		end
		for file <- files do
				url = file["url"]
				file_name = String.split(url,"/")
				file_name = List.last(file_name)
				id = Enum.at(String.split(file_name,"-"), 1) #get book id
				file_extension = List.last(String.split(file_name, "."))
				path = Path.expand("~")
				#Download song from server
				case size do
					1-> System.cmd("wget",["-N","-P","#{path}/.songs/",url])
					_-> 
				System.cmd("wget",["-N","-P","#{path}/.songs/#{title}",url])
				end
				##Rename file
				#System.cmd("cp",["#{path}/.songs/#{file_name}","#{path}/.songs/#{artist}-#{song}.#{file_extension}"])
				##Delete original file from server
				#System.cmd("rm", ["#{path}/.songs/#{file_name}"])
				##Update .songs.csv
				IO.puts("Artist: #{artist}, Title: #{title}")
		end
				SongCollection.write(%{Artist: "#{artist}", Song: "#{title}"})
#		Mint.HTTP.close(conn)
	end

end
