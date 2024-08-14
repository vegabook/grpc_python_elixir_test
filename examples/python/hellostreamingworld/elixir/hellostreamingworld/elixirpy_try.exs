cred = GRPC.Credential.new(ssl: [cacertfile: Path.expand("../../out/zombieCA.crt"),
                                 certfile: Path.expand("../../out/zombie.crt"), 
                                 keyfile: Path.expand("../../out/zombie.key"), 
                                 verify_peer: true])

{:ok, channel} = GRPC.Stub.connect("signaliser.com:50051")
IO.puts "connecting"
request = Hellostreamingworld.HelloRequest.new(name: "grpc-elixir", cred: cred)

IO.puts "connected sending"
channel 
|> Hellostreamingworld.MultiGreeter.Stub.say_hello(request) 
|> IO.inspect
|> elem(1) 
|> IO.inspect
|> Enum.map(fn x -> x end)
|> IO.inspect
