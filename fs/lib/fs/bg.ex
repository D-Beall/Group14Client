defmodule FS.BackgroundModule do
	def myIP do
		System.cmd("curl",["curl.me"], into: IO.stream(:stdio, :line))
	end
end
