defmodule FS.Client do

	def handle_responses(responses) do
		#Function to handle the responses from the server.
		#responses- list of responses given from a Mint.HTTP.stream
		for response <- responses do
			case response do
			#Status code
			{:status, _request_ref, status_code}->
			IO.puts("> Response status code #{status_code}")
			#Headers
			{:headers, _request_ref, headers}->
			IO.puts("> Response headers: #{inspect(headers)}")
			#Data
			{:data, _request_ref, data}->
			IO.puts("> Response body")
			IO.puts(data)

			{:done, _request_ref} ->
			IO.puts("> Response received")
			end
		end
	end

	def get_status(responses) do
		#Function to return the return status of an http request.
		#responses- list of responses given from a Mint.HTTP.stream
		for response <- responses do
			case response do
			#Status code
			{:status, _request_ref, status_code}->
			{:status, status_code}
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
		{:ok, conn, request_ref} = Mint.HTTP.request(conn, "GET", "/hello", [], "")
		#receive message
		receive do
			message ->
				{:ok, conn, responses} = Mint.HTTP.stream(conn, message)
				handle_responses(responses)
		end
		Mint.HTTP.close(conn)
	end

	def post do
		#generate UUID/cookie
		id = UUID.uuid1()
		cook = UUID.uuid1()#may need to use other UUID function
		#convert to JSON
		list = [uuid: id, cookie: cook]
		{status, result} = JSON.encode(list)
		#connect to server
		{:ok, conn} = Mint.HTTP.connect(:http, "xzy3.cs.seas.gwu.edu", 8085)
		#send post request with json data
		{:ok, conn, request_ref} = Mint.HTTP.request(conn, "POST", "/post", [{"content-type", "application/json"}], result)
		#receive message
		receive do
			message ->
				IO.inspect(message, label: :message)
				{:ok, conn, responses} = Mint.HTTP.stream(conn, message)
				IO.inspect(responses, label: :responses)
		end
	end

end
