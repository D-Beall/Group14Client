# FS

**TODO: Add description**

1) Background module that scans the network at an interval and adds available clients to memory.
2) This module should also be able to search and download songs on the available clients.
3) Run this background module as a daemon service in linux.
4) A module that accepts inputs from terminal and sends it to the daemon module.
5) The terminal module should accept the name of the song as input///

## Possible Implementation of network scanning

1) bg process on machine 1 starts up and asks the main server for the "machine name" and "cookie name" for domain name server in the local network.
2) If the server returns null. Then bg process starts another process that is dns process and gets the dns registered with the main server.
3) bg process on machine 2 starts up and asks the main server for domain name server in the local network.
4) server returns the machine name and cookie name for dns server
5) bg process on machine 2 connects to the dns of the machine 1 and registers itself. It also fetches all the other machines on the network from the dns server  

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `fs` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:fs, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/fs](https://hexdocs.pm/fs).

