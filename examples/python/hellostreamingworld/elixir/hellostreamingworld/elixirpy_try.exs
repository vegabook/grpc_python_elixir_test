cred = GRPC.Credential.new(ssl: [cacertfile: Path.expand("../../out/zombieCA.crt"),
                                 certfile: Path.expand("../../out/zombie.crt"), 
                                 keyfile: Path.expand("../../out/zombie.key"), 
                                 verify_peer: true])

{:ok, channel} = GRPC.Stub.connect("localhost:50051", cred: cred)

request = Hellostreamingworld.HelloRequest.new(name: "grpc-elixir")

channel 
|> Hellostreamingworld.MultiGreeter.Stub.say_hello(request) 
|> elem(1) 
|> Enum.map(fn x -> x end)
|> IO.inspect
