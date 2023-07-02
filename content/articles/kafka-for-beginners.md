---
date: 2021-06-30T00:00:00-03:00
description: "Kafka For Beginners"
tags: ["kafka"]
title: "Kafka For Beginners"
---

The complexity of applications has been grown and with it the data's process that can lead us to a difficulty to deal with all of it.
Kafka is a tool to deal with a stream of data and can keep data from different systems with a high power of process.
When we talk about Kafka we used to talk about some buzzwords like Broker, Topic, Partition, Offset, Producer, and Consumer in which we'll talk about here.

# Goal

I'll show you the basics of Kafka where you'll be able to understand its use and how to deal with a couple of commons commands. If you're an expert, please help me improve this article! :)

# Partition - Saving the data

Let's start understanding Kafka from the inner layer to the more external one.

Like a database, in Kafka, you save your data and it's saved in a place called Partition.
The partitions are identified by a number started from zero that grows in a sequential way, like the ID of your database:

```
|---------------------|
| 0 | 1 | 3 | ... | n |
|---------------------|
```

# Multiple Partitions - Better Throughput

Imagine a restaurant where the chef puts the meal inside a window then the waiter can get it and deliver it to the table on the north of the restaurant. After a while, the waiter comes back and gets another meal and delivery it to the table in the south.
It can take some time! We can increase the speed by adding another waiter, so the first waiter gets the north's meal and the second waiter gets the south's meal. It'll increase the speed but the second waiter still needs to wait for the first one to get the meal to then arrive his time, like in a bank line:

```
Window 1: Meal South | Meal North
```

We can deliver the meals in parallel, for that we create more than one window (partition), so the waiter one and the waiter two can get the meal in the same time:

```
Window 1: Meal North
Window 2: Meal South
```

Now we have a better power to process the messages. With more data coming in we can add more partitions to deliver the meals quicker.

# Partition Key

Some customer complains that the meal was delivery wrong. The North meal was sent to the South table. Asking about the mistake to the chef, he answered that no one had specified the window for each meal, so the chef had an idea and put a post-it on each meal.
Now the meal with the post-it called **north** goes to the North window and the meal with post-it called **south** goes to the South window. The waiters should no more worry about filter it, they know the relation between the window and the restaurant's side.

The post-it here is the same as the key of the partition, Kafka will always send to the same partition when it receives the same key name.
The name of the key is calculated in the same way, so if you have the same quantity of partitions and use the same key, it'll always be sent to the same partition.

You may think that the meals could have an identification besides the key, so the waiters would know about the table by themself over by the window. Yes, it could, but here we have, sometimes, a hard understanding of the partition key, since we don't really want to know the exact partition since it goes to the same one always. Imagine the following situation:

```
Partition Window 1: Meal South, Meal North
Partition Window 2: Dessert North
```

As you can see the North table would receive the Meal and so the Dessert, or even worse the Dessert and so the Meal in the same time, because both packages are the first in the partition and with two waiters they can do it in the same time, since now the Chef doesn't respect anymore the windows. The waiters just know that should send it to North. If we want to guarantee the order, we need to use partition key to have the following situation:


```
Partition Window 1: Dessert North, Meal North
Partition Window 2: Meal South
```

Now the Dessert will arrive only after the meal since the North's waiter should pick up the first package to then be able to pick up the second one. So remember, the partition key is not about identifying the kind of the message, it's about making a better throughput and make sure the order inside the partition. We don't keep order across partitions, so bank transactions are a good example of Partition Key use.

The Partition key is hashed with [MurmurHash](https://en.wikipedia.org/wiki/MurmurHash) algorithm. Currently, we're using the [Murmur3](https://github.com/apache/kafka/blob/trunk/streams/src/main/java/org/apache/kafka/streams/state/internals/Murmur3.java#L25).

# Offset - Iterate Over Data

All data in Kafka will be persisted, at least for a while, so you can replay it later. In the last example, after the waiter delivers the Meal, the offset started at zero was increased by one so the meal in position 0 was consumed and hidden, but the data will still be there. If for some reason the waiter left the meal falls we can resend the meal just by controlling the offset decreasing it by 1. It's powerful and can go back or forward. If you need to replay all the data from a specific day or position, you're in a good hand too:

```
Partition Window 1: Dessert North (offset 1), Meal North (offset 0)
Partition Window 2: Meal South (offset 0)
```

# Topic - Grouping Data

All Partitions live in a specific place called Topic. For our last example, we could group those partitions in a topic called Delivery, for example. We could have another topic called Meal Stock where other systems would get this data and decrease the stock-based in what meal was made and delivered:

```
Topic Delivery -> |---------------------------------------------------------|
                  |Partition Window 1: Dessert North (offset 1), Meal North |
                  |Partition Window 2: Meal South (offset 0)                |
                  |---------------------------------------------------------|

Topic Stock ->|---------------------------------------------------------|
              |Partition Window 1: Dessert North, Meal North (offset 0) |
              |Partition Window 2: Meal South (offset 0)                |
              |---------------------------------------------------------|
```

# Producer - Creating the Messages

Producers are the systems that produce the messages, these messages are sent to the topics.
Be default the Producer does not choose which partition the message will be saved. It just sends it to the topic.

Based on our restaurant example, the producer would be the chef that produces the meals and put them on the balcony (topic):

```
Chef make Chicken -> Chicken is put into Window 1
```

# Consumer - Getting the Messages

Consumers are the systems that read the messages created by the producers, it reads through the topic. After a consumer starts to read from a topic, it'll stick on some partition to avoid steal data from other consumers and/or lose the order. Bear in mind that the order is kept only inside the partition so some consumer can read quicker than other and being at different offset value.

Every time we add or remove a consumer, Kafka rebalances the consumers and the sticked partition can be changed.
If you add more consumers than the number of partitions, some consumer will be idle because won't be left any partition to be read, since a partition has only one consumer tied on it.

Based on our restaurant example, the consumers are the waiters where each waiter will always get the meal from the same window:

```
Window 1 with chicken <- Waiter gets the chicken
```

# Broker - Managing Everything

Brokers are responsible to deal with producers, consumers, and topics. The producer and consumer need to address the write and read to a Broker. We have different clients to connect to the broker and Kafka is so amazing that we have what we call Client Bi-Directional Compatibility, it means that an old client version can connect to a newer broker version and vice versa. So, you can keep your client updated to the last version with no worries.

Usually, we have 3 brokers where one will be responsible to receive the write and read and the others will be backup in case of failure. If some broker fails, another broker will assume the leadership making Kafka fault-tolerant.

Based on our restaurant example, the broker represents the restaurant itself. With more restaurants, more guarantee that the client will always ask for delivery even if some restaurant has a disaster, we have another restaurant to receive the request.

```
Broker 0 NY ->|--------------------------------------------------------------------------------------------|
              | Producer Chef ->                                                                           |
              |   Topic Delivery -> |--------------------------------------------------------------------| |
              |                     |Partition Window 1: Dessert North (offset 1), Meal North (offset 0) | |
              |                     |Partition Window 2: Meal South (offset 0)                           | |
              |                     |--------------------------------------------------------------------| |
              |                       <- Consumer Waiter                                                   |
              |                                                                                            |
              | Producer Chef ->                                                                           |
              |   Topic Stock -> |--------------------------------------------------------------------|    |
              |                  |Partition Window 1: Dessert North (offset 1), Meal North (offset 0) |    |
              |                  |Partition Window 2: Meal South (offset 0)                           |    |
              |                  |--------------------------------------------------------------------|    |
              |                    <- Consumer Financial                                                   |
              |--------------------------------------------------------------------------------------------|

Broker 0 TX ->|--------------------------------------------------------------------------------------------|
              | Producer Chef ->                                                                           |
              |   Topic Delivery -> |--------------------------------------------------------------------| |
              |                     |Partition Window 1: Dessert North (offset 1), Meal North (offset 0) | |
              |                     |Partition Window 2: Meal South (offset 0)                           | |
              |                     |--------------------------------------------------------------------| |
              |                       <- Consumer Waiter                                                   |
              |                                                                                            |
              | Producer Chef ->                                                                           |
              |   Topic Stock -> |--------------------------------------------------------------------|    |
              |                  |Partition Window 1: Dessert North (offset 1), Meal North (offset 0) |    |
              |                  |Partition Window 2: Meal South (offset 0)                           |    |
              |                  |--------------------------------------------------------------------|    |
              |                    <- Consumer Financial                                                   |
              |--------------------------------------------------------------------------------------------|
```

# Consumer Group - The Same Target

Consumer Group is an abstraction that connects to the Topic. This abstraction makes all consumers from the same group share the partitions.
The offsets are saved for each different group, so if you want to replay all messages from some topic, you can manipulate the offset or you can create a new consumer group, with the right configuration, to receive all messages from the beginning.

Consumer Group has the power to balance the partition's messages to each consumer, so for 3 partitions and 1 consumer, this consumer will bind in all three partitions, but if you add another consumer in the same group, then you have one consumer bound in two partitions and another consumer bound in just one. Adding another consumer, now you have a good balance, one consumer for each partition. But if you add one more consumer, this consumer won't have any partition to consume and will be idle. A tip here is to keep always the same quantity of consumers and partition since more consumers will be idle and fewer consumers will receive data from different partitions, so let's keep one to one.

Why do I need to use a group? A copy of each message is "sent" to each group, so consumers in the same group receive the message just once.

Based on our restaurant example, if the restaurant always produces the same kind of food in a period frame, we could have a consumer group called morning, afternoon, and night. Each of these groups would serve the same cycle of food, but for different customers, like in an all-you-can-eat barbecue restaurant:

```
Broker 0 NY ->|--------------------------------------------------------------------------------------------|
              | Producer Chef ->                                                                           |
              |   Topic Delivery -> |--------------------------------------------------------------------| |
              |                     |Partition Window 1: Dessert North (offset 1), Meal North (offset 0) | |
              |                     |Partition Window 2: Meal South (offset 0)                           | |
              |                     |--------------------------------------------------------------------| |
              |                       <- Consumer Group Afternoon                                          |
              |                          |-----------------------|                                         |
              |                          |Consumer Waiter 1      |                                         |
              |                          |Consumer Waiter 2      |                                         |
              |                          |-----------------------|                                         |
              |                                                                                            |
              |                       <- Consumer Group Night                                              |
              |                          |-----------------------|                                         |
              |                          |Consumer Waiter 1      |                                         |
              |                          |Consumer Waiter 2      |                                         |
              |                          |-----------------------|                                         |
              |--------------------------------------------------------------------------------------------|
```

# States - How the Message Behaves

Kafka can indicate that the message was received successfully with a response as `ack` (acknowledge) and when this message is replicated to all ISR then we have the message's state called `committed` it indicates that is safe to be consumed since the message is stored in the replicas too. The follower's brokers will always consume the message from the Leader broke until the last offset to receive the `committed` state:

```
Broker Leader 0 NY ->|---------------------------------------------------------------------------------------------|
                     | Producer Chef ->                                                                            |
                     |   Topic Delivery -> |---------------------------------------------------------------------| |
                     |                     |Partition Window 1: Dessert North (ack), Meal North (committed)      | |
                     |                     |Partition Window 2: Meal South (committed)                           | |
                     |                     |---------------------------------------------------------------------| |
                     |---------------------------------------------------------------------------------------------|

Broker Follower 1 TX ->|-------------------------------------------------------------|
                       | Producer Chef ->                                            |
                       |   Topic Delivery -> |-------------------------------------| |
                       |                     |Partition Window 1: Meal North (ack) | |
                       |                     |Partition Window 2: Meal South (ack) | |
                       |                     |-------------------------------------| |
                       |-------------------------------------------------------------|
```

You can see that the **Dessert North** still not in the follower, so this message still not committed, so not ready to be consumed.
All these states are watched and when some broker is down, we have a mechanism to deal with it called Zookeeper.

# Zookeeper

The Zookeeper is responsible to monitor the Brokers and keep the right follower or leader. It keeps the cluster's state.
If we can't have a message `committed`, Zookeeper will kill the problematic broker and then the message will become `committed`. When a leader dies, another ISR becomes the new leader.

In the past Zookeeper used to hold a lot of metadata of Kafka, like the offsets for example, but they're moving it to the Kafka itself keeping the things simpler. In the future (beta now) we want not to depend at all on Zookeeper to run Kafka.

# Let's Code

Until here we talked a lot about the theory, now we'll do the things coding and during the commands presentation, we'll give more details about what we studied until here.

Let's start installing the dependencies. First, we need to make sure we're using the [Java 11](https://www.oracle.com/br/java/technologies/javase-jdk11-downloads.html) as it is [supported](https://github.com/apache/kafka/pull/9080) by Kafka, but if you're using [Confluent](https://docs.confluent.io/platform/current/installation/versions-interoperability.html#java), keeps the Java 8:

```sh
brew install --cask adoptopenjdk11
```

Now download the [Kafka](http://kafka.apache.org/downloads):

```sh
wget https://ftp.unicamp.br/pub/apache/kafka/2.8.0/kafka_2.13-2.8.0.tgz
tar xzf kafka_2.13-2.8.0.tgz
rm kafka_2.13-2.8.0.tgz
cd kafka_2.13-2.8.0
```

Bootup the Zookeeper and Kafka:

```sh
./bin/zookeeper-server-start.sh config/zookeeper.properties
./bin/kafka-server-start.sh config/server.properties
```

The Zookeeper will be in port `2181` and Kafka in `9092`. Both commands receive the config that you can edit and change the port, data storage, and so on.

## Topic Create

We'll create a topic called `topic1` with two partitions using `--create`.

```sh
./bin/kafka-topics.sh --bootstrap-server localhost:9092 --topic topic1 --create --partitions 3 --replication-factor 1

# Created topic topic1.
```

Here we use `--bootstrap-server` to configure the communication to the server directing the command to Kafka. After the create command we pass some parameters indicating we want 3 partitions and the replications will be just one. The replication factor is the number of brokers we want to be our replica.

## Topic List

Listing all topics, with `--list`, we can see one:

```sh
./bin/kafka-topics.sh --bootstrap-server localhost:9092 --list

# topic1
```

## Topic Describe

You can see the topic details with `--describe`:

```sh
./bin/kafka-topics.sh --bootstrap-server localhost:9092 --topic topic1 --describe

# Topic: topic1	TopicId: o1PezCsBTwuFSyfqyWcpZQ	PartitionCount: 3	ReplicationFactor: 1	Configs: segment.bytes=1073741824
#	Topic: topic	Partition: 0	Leader: 0	Replicas: 0	Isr: 0
#	Topic: topic	Partition: 1	Leader: 0	Replicas: 0	Isr: 0
#	Topic: topic	Partition: 2	Leader: 0	Replicas: 0	Isr: 0
```

The partitions will be displayed where partition 0 has the broker 0 as its leader and has zero replicas, and zero ISR (In-sync Replicas) or we can say how many partitions we have as backup in another broker.

## Topic Delete

To delete a topic just execute the `--delete`:

```sh
./bin/kafka-topics.sh --bootstrap-server localhost:9092 --topic topic1 --delete
```

## Producer

```sh
./bin/kafka-console-producer.sh --broker-list localhost:9092 --topic topic1 --producer-property acks=all
>one
>two
>three
```

### Acks

We can configure the producer passing the property `acks=all` that will make sure the message will be replicated in all ISR and only after that the message will be committed. In this way, if the Leader dies, we have the message safe in replica. Of course, it's more expensive since you need all followers to respond ack and then the broker ack either.

You can use other config values like `acks=0`, but it won't worry if the message was delivered, like in UDP, so it's nice to be used with logs, metrics, and things like that where you can lose data and take advantage of the performance of this operation that doesn't require a save confirmation.

A common mistake happens when you use the default config that is `acks=1`, it will make sure the broker received the message, but the replica sync will happen in the background, so if the broker goes down early, you can lose data.

Ok, if you choose the `acks=all` config as your favorite, remember that you must set the `min.insync.replicas` config where you set how many brokers, including the leader, must ack the message. Here the config `replication.factor` starts to show up since you need to decide the number of replicas you'll have. Do the math to keep at enough replicas to sync your backup messages.

### Topic Creation

Before you start to produce, pay attention, because if you produce a message on a topic that doesn't exist, the topic will be created with the default configuration:

```sh
./bin/kafka-topics.sh --bootstrap-server localhost:9092 --topic missing --describe

# Topic: missing	TopicId: D4WHz17WSeelS-a5xUAqyQ	PartitionCount: 1	ReplicationFactor: 1	Configs: segment.bytes=1073741824
# 	Topic: missing	Partition: 0	Leader: 0	Replicas: 0	Isr: 0
```

We got just one partition with zero ISR available. You can change the `num.partitions` property of the file `config/server.properties` and set another default, but it's always preferable you create your topics first to avoid default surprises. Maybe disable this behavior is a good idea with `auto.create.topics.enable` option.

You can configure your producer in [many ways](https://kafka.apache.org/documentation/#producerconfigs).

### Idempotence

The producer can produce a message and the broker doesn't acknowledge it properly, maybe because of a failure in the communication. When it happens, the producer may retry, which can become a duplicated message. To avoid it Kafka implements the Idempotent Producer where the producer always sends a Request ID, so Kafka can detect it, and instead to duplicate the record, it just skips it and returns the ack.

### Compression

We can compress our produced message using config [compression.type](https://docs.confluent.io/platform/current/installation/configuration/producer-configs.html#producerconfigs_compression.type) default `none` as [snappy](https://github.com/google/snappy) or `gzip`. It can optimize the network traffic and save money, storage, and time for you.

### Batch

Another way to optimize the producer is sending the messages in batch. You can configure it using [batch.size](https://docs.confluent.io/platform/current/installation/configuration/producer-configs.html#producerconfigs_batch.size) default `16KB`. Kafka will dispatch the messages as soon as possible, so we need to wait sometime until be able to accumulate messages increasing the [linger](https://docs.confluent.io/platform/current/installation/configuration/producer-configs.html#producerconfigs_linger.ms) default `0`. If the batch reaches the maximum size before this time it'll be dispatched to avoid delay.

With a bigger batch, we have a better compression ratio but pay attention to avoid too much big batch or you can have memory problems.

### Memory

Sometimes your producer can raise an error because it had an overflow buffer or stayed block much time. In this case you can remember to check the [max.block.ms](https://docs.confluent.io/platform/current/installation/configuration/producer-configs.html#producerconfigs_max.block.ms) as default `1 min` and [buffer.memory](https://docs.confluent.io/platform/current/installation/configuration/producer-configs.html#producerconfigs_buffer.memory) as default `33MB`.

## Consumer

You need to start the consumer script by providing the topic name:

```sh
./bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic topic1
```

We've already sent a message to the `topic1`, but it won't return the old data, only the one sent by now. Try to send the message now:

```sh
./bin/kafka-console-producer.sh --broker-list localhost:9092 --topic topic1
>live1
>live2
>live3
```

And then your consumer will receive it:

```sh
live1
live2
live3
```

If you want to read all messages since the beginning you can set it as an option:

```sh
./bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic topic1 --from-beginning

# two
# oneack
# live2
# twoack
# live1
# live3
# one
# three
# threeack
```

Now you received all messages. The messages are out of order because `topic1` has three partitions and the order is only inside the partition not between them.

You can configure your consumer in [many ways](https://kafka.apache.org/documentation/#consumerconfigs).

### Batch

The Consumer will read messages in batches and the quantity will depend on some configs like [fetch.min.bytes](https://kafka.apache.org/documentation/#consumerconfigs_fetch.min.bytes) that will answer the consumer with at least `1 byte` by default.

The [max.poll.records](https://kafka.apache.org/documentation/#consumerconfigs_max.poll.records), as default `500`, will indicate how many messages you can consume per (poll). If you have enough memory, maybe it's a good idea to increase it mainly if your messages are small, which will result in a lot more messages.

### Idempotence

Like in producer we can have failures and by default, the [Message Delivery Semantic](http://kafka.apache.org/documentation.html#semantics) is configured to **At most once** where the consumer will read the message and save the offset position, but it can fail while processing this message, so the next consumer will skip this messages.

The **At least once** where the consumer will read and process and then save the position. On crash, the old position will be read and generate duplication. This is a good config where you just need to set an ID for each message and so use an `upsert` method over just `create` avoiding duplicated reviews on conflict.

We have the **Exactly once** where the support is just with [Kafka Stream](https://kafka.apache.org/documentation/streams) dealing with it directly in Kafka or using [Kafka Connect](https://kafka.apache.org/documentation/#connectapi) that will implement it for you. You can implement it in a hard way saving the offset in the same transaction in another system, but it wouldn't be so easy.

### Commit Strategy

By default, we're opt-in with `at-most-once` delivery strategy where the offset is committed before we process the messages. This commit happens because we're using the config [enable.auto.commit](https://kafka.apache.org/documentation/#consumerconfigs_enable.auto.commit) as `true` that will commit the offset in `5000ms` by default according to the config [auto.commit.interval.ms](https://kafka.apache.org/documentation/#consumerconfigs_auto.commit.interval.ms). The auto-commit can be dangerous, so you can disable it and commit the offset manually making sure the data were processed correctly.

## Consumer Group

We can scale our application spinning up more consumers, each consumer will consume from one partition. For the topic `topic1` we can have 3 consumers that will have the same purpose or better to say, they will belong to the same group.

Let's start 3 consumer in the same consumer group:

```sh
# terminal 1
./bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic topic1 --group group1

# terminal 2
./bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic topic1 --group group1

# terminal 3
./bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic topic1 --group group1
```

Then we'll send 3 messages:

```sh
./bin/kafka-console-producer.sh --broker-list localhost:9092 --topic topic1
>group1 message 1
>group1 message 2
>group1 message 3
```

You'll *probably* see the message being balanced between the partitions and so consumed for each one of the consumers, but as like a round robbin strategy you may receive no message in certain consumers, but most of the time it'll be well balanced. That's why it's important have the same number of consumers and partitions to have better throughput.

A thing to have in mind is that all new consumer groups won't receive old messages. To do that, you need to pass the option `--from-beginning`, but it only works with new group names, after the first command execution this option won't work anymore acting like `--from-last-offset`.

When you don't specify a group, a random group will be selected for you, something like `console-consumer-1759`. Let's describe our consumer group:

```sh
./bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --group group1 --describe

# GROUP           TOPIC           PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG             CONSUMER-ID                                            HOST            CLIENT-ID
# group1          topic          0          9               9               0               consumer-group1-1-25633e50-67fd-4cc4-bb9b-9e2e287019d9 /192.168.15.47  consumer-group1-1
# group1          topic          1          8               8               0               consumer-group1-1-25633e50-67fd-4cc4-bb9b-9e2e287019d9 /192.168.15.47  consumer-group1-1
# group1          topic          2          7               7               0               consumer-group1-1-a6c30266-69fa-4d85-83d6-f5cde0487c04 /192.168.15.47  consumer-group1-1
```

The group `group1` is binded in the three partitions. The partition 0 received more message `current-offset 9`. All consumers read all messages, so `log-end-offset` (read) is equal to the `current-offset` (received) so the lag (pending) is zero.

After a consumer group loses all consumers the config [offsets.retention.minutes](https://kafka.apache.org/documentation/#brokerconfigs_offsets.retention.minutes) as default `7days` will define how many minutes, after the last commit, to discard the offset. By default, you have 7 days to commit at least one message before it is discarded.

### Replay Data

If you want to replay your data, you can create a new group calling the `--from-beginning`, which I think is not a good idea since someone can try to use the same name in the future and screw everything, or you can move the offset with the option `--reset--offsets`. We have a couple of ways to move this offset pointer like `--shift-by`, `--to-earliest`, `--to-latest`, and others that you can read in the console help. Before running this command you need to stop the consumers.

```sh
./bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --group group1 --topic topic1 --reset-offsets --to-earliest --execute

# GROUP                          TOPIC                          PARTITION  NEW-OFFSET
# group1                         topic1                         0          0
# group1                         topic1                         1          0
# group1                         topic1                         2          0
```

Now all offsets were reset to the beginning. Now the Lags (the sum of messages not read) will be the same as the last offset:

```sh
./bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --group group1 --describe

# Consumer group 'group1' has no active members.

# GROUP           TOPIC           PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG             CONSUMER-ID     HOST            CLIENT-ID
# group1          topic1          1          0               8               8               -               -               -
# group1          topic1          0          0               9               9               -               -               -
# group1          topic1          2          0               7               7               -               -               -
```

Since the consumers are stopped, we don't have `consumer-id`, `host`, and `client-id` information.

## Conclusion

I hope I could reach a couple of important things about Kafka and with that you already ready to play with it. I tried to talk about it in the reverse way I used to see on the internet, so hopefully, it worked.
Do you have something to complement or teach me here? I'll appreciate it!
