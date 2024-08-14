# Copyright 2021 gRPC authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""The Python AsyncIO implementation of the GRPC hellostreamingworld.MultiGreeter client."""

import asyncio
import logging

import grpc
import hellostreamingworld_pb2
import hellostreamingworld_pb2_grpc
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--message', default='hello!')
parser.add_argument('--host', default='signaliser.com')
parser.add_argument('--port', default='50051')
args = parser.parse_args()


async def run() -> None:
    with open('./out/zombie.crt', 'rb') as f:
        trusted_certs = f.read()

    # Create client credentials
    credentials = grpc.ssl_channel_credentials(root_certificates=trusted_certs)

    hostport = f"{args.host}:{args.port}"

    async with grpc.aio.secure_channel(hostport, credentials) as channel:
        stub = hellostreamingworld_pb2_grpc.MultiGreeterStub(channel)

        # Read from an async generator
        async for response in stub.sayHello(
            hellostreamingworld_pb2.HelloRequest(name=args.message)
        ):
            print(
                "Greeter client received from async generator: "
                + response.message
            )

        # Direct read from the stub
        hello_stream = stub.sayHello(
            hellostreamingworld_pb2.HelloRequest(name=str(args.message))
        )
        while True:
            response = await hello_stream.read()
            if response == grpc.aio.EOF:
                break
            print(
                "Greeter client received from direct read: " + response.message
            )


if __name__ == "__main__":
    logging.basicConfig()
    asyncio.run(run())
