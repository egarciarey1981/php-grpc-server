<?php

require 'vendor/autoload.php';

use Grpc\ChannelCredentials;
use GRPC\Greeter\GreeterClient;
use GRPC\Greeter\HelloRequest;

$client = new GreeterClient('localhost:9001', [
    'credentials' => ChannelCredentials::createInsecure()
]);

$request = new HelloRequest();
$request->setName("Eliecer");

// Llamada síncrona
list($response, $status) = $client->SayHello($request)->wait();

if ($status->code === Grpc\STATUS_OK) {
    echo "Respuesta: " . $response->getMessage() . PHP_EOL;
} else {
    echo "Error: " . $status->details . PHP_EOL;
}
