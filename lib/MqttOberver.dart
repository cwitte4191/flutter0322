import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart' as Mqtt;
import 'package:observable/observable.dart';


class MqttObserver{
  String hostname;
  Mqtt.MqttClient client;
  MqttObserver(this.hostname);

  void init()async {
    Mqtt.MqttClient client = new Mqtt.MqttClient(hostname, "");
    client.logging(true);

    try {
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
    /*
     final String topic = "#";
     final ChangeNotifier<MqttReceivedMessage> cn =
     client.listenTo(topic, MqttQos.exactlyOnce);
     */
  }
}