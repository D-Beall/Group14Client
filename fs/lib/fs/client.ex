defmodule FS.Client do

	def update_songs(song_info) do
		#Updates the song.csv file in the files directory.
		#song_info- Dictionary of :Artist and :Song to update file with.
		song = song_info[:Song]
		artist = song_info[:Artist]
		{:ok, file} = File.open("./files/song.csv", [:append])
		IO.binwrite(file,"#{artist},#{song}")
		IO.binwrite(file,'\n')
		File.close(file) 
	
	end

	def handle_responses(responses,request) do
		#Function to handle the responses from the server.
		#responses- list of responses given from a Mint.HTTP.stream
		#request- which request is calling the function.i.e. download etc.
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
				_ ->IO.puts("> Response headers: #{inspect(headers)}")
				end

			#Data
				{:data, _request_ref, data}->
				case request do
				#Download post request
				{:download} -> IO.puts("DOWNLOAD")
				split = String.split(data)
				url = Enum.at(split,1)
				System.cmd("wget",["-P","./files/",url])
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

	def get_status(responses) do
		#Function to return the return status of an http request.
		#responses- list of responses given from a Mint.HTTP.stream
		for response <- responses do
			case response do
			#Error
			{:error, _request_ref, error_code}->
			IO.puts("> Error code #{error_code}")
			#Status code
			{:status, _request_ref, status_code}->
			IO.puts("> Response status code #{status_code}")
			#Headers
			{:headers, _request_ref, _headers}->nil
			#Data
			{:data, _request_ref, _data}-> nil

			{:done, _request_ref} ->nil
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
				handle_responses(responses,{:get})
		end
		Mint.HTTP.close(conn)
	end

	def post do
		#generate UUID/cookie
		id = UUID.uuid1()
		cook = UUID.uuid1()#may need to use other UUID function
		#convert to JSON
		list = [uuid: id, cookie: cook]
		{_status, result} = JSON.encode(list)
		#connect to server
		{:ok, conn} = Mint.HTTP.connect(:http, "xzy3.cs.seas.gwu.edu", 8085)
		#send post request with json data
		{:ok, conn, _request_ref} = Mint.HTTP.request(conn, "POST", "/post", [{"content-type", "application/json"}], result)
		#receive message
		receive do
			message ->
				IO.inspect(message, label: :message)
				{:ok, _conn, responses} = Mint.HTTP.stream(conn, message)
				IO.inspect(responses, label: :responses)
		end
	end

	def server_download do
		IO.puts("Server download.")
		list = [song_name: "song"]
		{_status, result} = JSON.encode(list)
		#connect to server
		{:ok, conn} = Mint.HTTP.connect(:http, "xzy3.cs.seas.gwu.edu", 8085)
		#send post request with json data
		{:ok, conn, _request_ref} = Mint.HTTP.request(conn, "POST", "/download", [{"content-type", "application/json"}], result)
		#receive message
		receive do
			message ->
				IO.inspect(message, label: :message)
				{:ok, _conn, responses} = Mint.HTTP.stream(conn, message)
				handle_responses(responses,{:download})
		end
	end

end
