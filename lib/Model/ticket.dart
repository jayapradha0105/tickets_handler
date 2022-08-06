import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_database/firebase_database.dart';

class Ticket {
  String? title;
  String? description;
  String? location;
  String? reportedDate;
  String? attachment;
  DatabaseReference? id;

  Ticket(
      {this.title,
      this.description,
      this.location,
      this.reportedDate,
      this.attachment,
      this.id
      });

  void setId(DatabaseReference id) {
    this.id = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'title': this.title,
      'description': this.description,
      'location': this.location,
      'reportedDate': this.reportedDate,
      'attachment': this.attachment,
    };
  }

 factory Ticket.convertTicket(record) {
    Map<String, dynamic> attributes = {
      'title': '',
      'description': '',
      'location': '',
      'reportedDate': '',
      'attachment': null
    };

    record.forEach((key, value) => {attributes[key] = value});

    Ticket ticket = new Ticket(
      title:  attributes['title'],
       description: attributes['description'],
      location:  attributes['location'],
       reportedDate: attributes['reportedDate'],
      attachment:  attributes['attachment'],
        );
    return ticket;
  }
}
