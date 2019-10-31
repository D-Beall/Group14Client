defmodule FS.Client do
	def get do
		#connect to server
		{:ok, conn} = Mint.HTTP.connect(:http, "xzy3.cs.seas.gwu.edu", 8085)
		#send request
		{:ok, conn, request_ref} = Mint.HTTP.request(conn, "GET", "/hello", [], "")
		#receive message
		receive do
			message ->
				IO.inspect(message, label: :message)
				{:ok, conn, responses} = Mint.HTTP.stream(conn, message)
				IO.inspect(responses, label: :responses)
		end
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
	
	def uuid do
		UUID.uuid1()
	end

end
