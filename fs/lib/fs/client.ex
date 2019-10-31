defmodule FS.Client do
	def get do
		{:ok, conn} = Mint.HTTP.connect(:http, "xzy3.cs.seas.gwu.edu", 8085)
		{:ok, conn, request_ref} = Mint.HTTP.request(conn, "GET", "/hello", [], "")
		receive do
			message ->
				IO.inspect(message, label: :message)
				{:ok, conn, responses} = Mint.HTTP.stream(conn, message)
				IO.inspect(responses, label: :responses)
		end
	end

	def post do
		{:ok, conn} = Mint.HTTP.connect(:http, "xzy3.cs.seas.gwu.edu", 8085)
		{:ok, conn, request_ref} = Mint.HTTP.request(conn, "POST", "/post", [{"content-type", "application/json"}], "{'hello': 'world'}")
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
