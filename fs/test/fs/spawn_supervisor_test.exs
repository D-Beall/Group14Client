defmodule FS.CreateSpawnerTest do
	use ExUnit.Case, async: true
	
	setup do
		spawner = start_supervised!(KV.Spawner)
		%{spawner: spawner}
	end
end
