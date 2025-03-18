from confluent_kafka import Consumer, KafkaException, KafkaError

def consume_messages(broker, group, topics):
    # Consumer configuration
    conf = {
        'bootstrap.servers': broker,
        'group.id': group,
        'auto.offset.reset': 'earliest'
    }

    # Create Consumer instance
    consumer = Consumer(conf)

    # Subscribe to topics
    consumer.subscribe(topics)

    try:
        while True:
            msg = consumer.poll(timeout=1.0)
            if msg is None:
                continue
            if msg.error():
                if msg.error().code() == KafkaError._PARTITION_EOF:
                    # End of partition event
                    print(f'{msg.topic()} [{msg.partition()}] reached end at offset {msg.offset()}')
                elif msg.error():
                    raise KafkaException(msg.error())
            else:
                # Proper message
                print(f'Received message: {msg.value().decode("utf-8")}')

    except KeyboardInterrupt:
        pass
    finally:
        # Close down consumer to commit final offsets.
        consumer.close()

if __name__ == '__main__':
    broker = 'localhost:9092'
    group = 'my-consumer-group'
    topics = ['taxi-trips']

    consume_messages(broker, group, topics)