import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tickets_handler/Model/ticket.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tickets_handler/Services/pushNotifications.dart';

class TicketServices {
  final databaseReference = FirebaseDatabase.instance;
    FirebaseMessaging fcm = FirebaseMessaging.instance;

  final serverKey =
      '';

  Future<void> createTicket(Ticket ticket) async {
    var id = databaseReference.reference().child('tickets/').push();
    id.set(ticket.toJson());
    var token = await fcm.getToken();
    print("token $token");
    final notificationData = {
      "to": token.toString(),
      "notification": {
        "title": 'Hello User!',
        "body": 'You ticket has been raised.',
      }
    };
    try {
      final response = await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: {
          'Content-Type': ' application/json',
          'Authorization': 'Bearer '+serverKey
        },
        encoding: Encoding.getByName('utf-8'),
        body: json.encode(notificationData),
      );
      print(response.body);
      if (response.statusCode == 200) {
        print('test ok push CFM');
      } else {
        print(' CFM error');
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<Ticket>> getAllTickets() async {
    try {
      final dbEvent =
          await databaseReference.reference().child('tickets/').once();
      List<Ticket> ticketList = [];
      if (dbEvent.value != null) {
        dbEvent.value.forEach((key, value) {
          Ticket ticket = Ticket.convertTicket(value);
          ticket.setId(databaseReference.reference().child('tickets/' + key));
          ticketList.add(ticket);
        });
      }
      return ticketList;
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
