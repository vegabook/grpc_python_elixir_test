package main

import (
    "context"
    "crypto/x509"
    "fmt"
    "google.golang.org/grpc"
    "google.golang.org/grpc/credentials"
    "io/ioutil"
    "log"
    "time"
    pb "path/to/your/proto" // Replace with the correct import path for your generated Go protobuf code
)

func main() {
    // Load the trusted certificate
    cert, err := ioutil.ReadFile("./out/zombie.crt")
    if err != nil {
        log.Fatalf("Failed to load certificate: %v", err)
    }

    // Create a certificate pool from the certificate
    certPool := x509.NewCertPool()
    if !certPool.AppendCertsFromPEM(cert) {
        log.Fatalf("Failed to append certificate")
    }

    // Create client credentials
    creds := credentials.NewClientTLSFromCert(certPool, "")

    // Set up a connection to the server.
    conn, err := grpc.Dial("localhost:50051", grpc.WithTransportCredentials(creds))
    if err != nil {
        log.Fatalf("Did not connect: %v", err)
    }
    defer conn.Close()

    // Create a client stub
    client := pb.NewMultiGreeterClient(conn)

    // Create a context with a timeout
    ctx, cancel := context.WithTimeout(context.Background(), time.Second)
    defer cancel()

    // Make a streaming request
    stream, err := client.SayHello(ctx, &pb.HelloRequest{Name: "you"})
    if err != nil {
        log.Fatalf("Failed to start streaming: %v", err)
    }

    // Read from the stream using a generator-like approach
    for {
        response, err := stream.Recv()
        if err == grpc.EOF {
            break
        }
        if err != nil {
            log.Fatalf("Failed to receive a response: %v", err)
        }
        fmt.Printf("Greeter client received: %s\n", response.GetMessage())
    }

    // Alternatively, you can also use a blocking call like below
    // response, err := client.SayHello(ctx, &pb.HelloRequest{Name: "you"})
    // if err != nil {
    //     log.Fatalf("Could not greet: %v", err)
    // }
    // fmt.Printf("Greeting: %s\n", response.GetMessage())
}

