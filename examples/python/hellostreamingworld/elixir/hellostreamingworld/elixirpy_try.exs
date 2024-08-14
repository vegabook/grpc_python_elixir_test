cred = GRPC.Credential.new(ssl: [cacertfile: Path.expand("../../out/zombieCA.crt"),
                                 certfile: Path.expand("../../out/zombie.crt"), 
                                 keyfile: Path.expand("../../out/zombie.key"), 
                                 verify_peer: true])

{:ok, channel} = GRPC.Stub.connect("signaliser.com:50051", cred: cred)
request = Hellostreamingworld.HelloRequest.new(name: "grpc-elixir")
requestsum = Hellostreamingworld.SumRequest.new(num1: 10, num2: 2)

channel 
|> Hellostreamingworld.MultiGreeter.Stub.say_hello(request) 
|> elem(1) 
|> Enum.map(fn x -> x end)
|> IO.inspect

channel
|> Hellostreamingworld.MultiGreeter.Stub.sum(requestsum)
|> IO.inspect
