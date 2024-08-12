defmodule Hellostreamingworld.HelloRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :name, 1, type: :string
  field :num_greetings, 2, type: :string, json_name: "numGreetings"
end

defmodule Hellostreamingworld.HelloReply do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :message, 1, type: :string
end

defmodule Hellostreamingworld.MultiGreeter.Service do
  @moduledoc false

  use GRPC.Service, name: "hellostreamingworld.MultiGreeter", protoc_gen_elixir_version: "0.12.0"

  rpc :sayHello, Hellostreamingworld.HelloRequest, stream(Hellostreamingworld.HelloReply)
end

defmodule Hellostreamingworld.MultiGreeter.Stub do
  @moduledoc false

  use GRPC.Stub, service: Hellostreamingworld.MultiGreeter.Service
end