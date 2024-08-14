# Copyright 2021 gRPC authors.
# colorscheme aiseered
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
"""The Python AsyncIO implementation of the GRPC hellostreamingworld.MultiGreeter server."""

import asyncio
import logging

import grpc
from hellostreamingworld_pb2 import HelloReply
from hellostreamingworld_pb2 import HelloRequest
from hellostreamingworld_pb2 import SumRequest
from hellostreamingworld_pb2 import SumResponse 
from hellostreamingworld_pb2_grpc import MultiGreeterServicer
from hellostreamingworld_pb2_grpc import add_MultiGreeterServicer_to_server

import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--host', default='signaliser.com')
parser.add_argument('--port', default='50051')
args = parser.parse_args()

NUMBER_OF_REPLY = 10


class Greeter(MultiGreeterServicer):

    def __init__(self):
        self.my_number = 0
        asyncio.create_task(self.do_stuff_regularly())

    async def do_stuff_regularly(self):
        while True:
            await asyncio.sleep(10)
            self.my_number -= 1
            print(f"my_number: {self.my_number}")

    async def sayHello(
        self, request: HelloRequest, context: grpc.aio.ServicerContext
    ) -> HelloReply:
        logging.info("Serving sayHello request %s", request)
        for i in range(self.my_number, self.my_number + NUMBER_OF_REPLY):
            yield HelloReply(message=f"Hello number {i}, {request.name}!")
        self.my_number += NUMBER_OF_REPLY


    async def sum(self, request: SumRequest, context: grpc.aio.ServicerContext) -> SumResponse:
        logging.info("Serving sum request %s", request)
        return SumResponse(result=request.num1 + request.num2)




async def serve() -> None:

    with open('./out/zombie.key', 'rb') as f:
        private_key = f.read()
    with open('./out/zombie.crt', 'rb') as f:
        certificate_chain = f.read()

    # Create server credentials
    server_credentials = grpc.ssl_server_credentials(((private_key, certificate_chain),))


    server = grpc.aio.server()
    add_MultiGreeterServicer_to_server(Greeter(), server)
    #listen_addr = "[::]:50051"
    listen_addr = f"{args.host}:{args.port}"
    server.add_secure_port(listen_addr, server_credentials) # secure uses the cert
    #server.add_insecure_port(listen_addr) # insecure
    logging.info("Starting server on %s", listen_addr)
    await server.start()
    await server.wait_for_termination()


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    asyncio.run(serve())
