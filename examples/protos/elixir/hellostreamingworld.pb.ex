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

defmodule Hellostreamingworld.SumRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :num1, 1, type: :int32
  field :num2, 2, type: :int32
end

defmodule Hellostreamingworld.SumResponse do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field :result, 1, type: :int32
end

defmodule Hellostreamingworld.MultiGreeter.Service do
  @moduledoc false

  use GRPC.Service, name: "hellostreamingworld.MultiGreeter", protoc_gen_elixir_version: "0.12.0"

  rpc :sayHello, Hellostreamingworld.HelloRequest, stream(Hellostreamingworld.HelloReply)

  rpc :sum, Hellostreamingworld.SumRequest, Hellostreamingworld.SumResponse
end

defmodule Hellostreamingworld.MultiGreeter.Stub do
  @moduledoc false

  use GRPC.Stub, service: Hellostreamingworld.MultiGreeter.Service
end