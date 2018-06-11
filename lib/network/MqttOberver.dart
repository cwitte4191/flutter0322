import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart' as Mqtt;
import 'package:observable/observable.dart';


class MqttObserver{
  String hostname;
  Mqtt.MqttClient client;
  MqttObserver(this.hostname);

  void init()async {
    Mqtt.MqttClient client = new Mqtt.MqttClient(hostname, "cjw");
    client.logging(true);

    try {
      print("MqttObserver about to connect: $hostname");

      await client.connect();
    } on Exception catch (e) {
      print("Mqtt connect error: $e");
      client.disconnect();
    }
    if (client.connectionState == Mqtt.ConnectionState.connected) {
      print("MqttObserver::$hostname client connected");
    } else {
      print(
          "MqttObserver::ERROR $hostname client connection failed - disconnecting, state is ${client
              .connectionState}");
      client.disconnect();
    }

    /// Ok, lets try a subscription

     final String topic = "changeList";
      var cn =
     client.listenTo(topic, Mqtt.MqttQos.atLeastOnce);

    cn.changes.listen((List<Mqtt.MqttReceivedMessage> c) {
      final Mqtt.MqttPublishMessage recMess = c[0].payload as Mqtt.MqttPublishMessage;
      final String pt =
      Mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      /// The above may seem a little convoluted for users only interested in the
      /// payload, some users however may be interested in the received publish message,
      /// lets not constrain ourselves yet until the package has been in the wild
      /// for a while.
      /// The payload is a byte buffer, this will be specific to the topic
      print("mqtt: EXAMPLE::Change notification:: payload is <$pt> for topic <$topic>");
    });
  }
}