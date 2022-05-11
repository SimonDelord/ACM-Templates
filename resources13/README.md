This is the repo for:
- deploying the Kafka Operator (AMQ Streams)
- deploying a simple Kafka broker (my broker)
- deploying a topic (my-topic)


After that a simple way of deploying a consumer and a producer is to do the following
(as per https://access.redhat.com/documentation/en-us/red_hat_amq_streams/2.1/html/getting_started_with_amq_streams_on_openshift/proc-using-amq-streams-str)


To run a producer
oc run kafka-producer -ti --image=registry.redhat.io/amq7/amq-streams-kafka-31-rhel8:2.1.0 --rm=true --restart=Never -- bin/kafka-console-producer.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 \
--topic my-topic

To run a consumer
oc run kafka-consumer -ti --image=registry.redhat.io/amq7/amq-streams-kafka-31-rhel8:2.1.0 --rm=true --restart=Never -- bin/kafka-console-consumer.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 \
--topic my-topic --from-beginning
