<?php
// GENERATED CODE -- DO NOT EDIT!

namespace GRPC\Greeter;

/**
 */
class GreeterClient extends \Grpc\BaseStub {

    /**
     * @param string $hostname hostname
     * @param array $opts channel options
     * @param \Grpc\Channel $channel (optional) re-use channel object
     */
    public function __construct($hostname, $opts, $channel = null) {
        parent::__construct($hostname, $opts, $channel);
    }

    /**
     * @param \GRPC\Greeter\HelloRequest $argument input argument
     * @param array $metadata metadata
     * @param array $options call options
     * @return \Grpc\UnaryCall
     */
    public function SayHello(\GRPC\Greeter\HelloRequest $argument,
      $metadata = [], $options = []) {
        return $this->_simpleRequest('/Greeter.Greeter/SayHello',
        $argument,
        ['\GRPC\Greeter\HelloReply', 'decode'],
        $metadata, $options);
    }

}
