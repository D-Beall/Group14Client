defmodule UI do

	def handle_response(r) do
		case r do

		"help" -> IO.puts("List of options.")	
		get_response(:continue)

		"exit" -> get_response(:exit)

		_-> IO.puts("Unknown command please try again.")
		get_response(:continue)
		end
	end

	def start do
		FS.Client.server_download()
		IO.puts("Welcome to audio file share.")
		IO.puts("Type help for options.")
		get_response(:continue)
	end
	
	def get_response(status) do
		case status do

		:continue->
		response = IO.gets("Please enter a command: ")
		response = String.trim(response)
		handle_response(response)

		:exit->
		IO.puts("Thank you, applcation shutting down.")	
		end
	end

end
