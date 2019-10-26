defmodule FS.Spawner do
	use GenServer

	@impl true
	def init(:ok) do
		{:ok, %{}}
	end
	
	@impl true
	def handle_call(:request,_from,:state) do
		{:reply, "Got call."}
	end

	@impl true
	def handle_cast(:request, :state) do
		{:noreply, "Got cast."}
	end
end
