import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tickets_handler/Services/ticketService.dart';
import 'package:tickets_handler/View/Tickets/bloc/events.dart';
import 'package:tickets_handler/View/Tickets/bloc/states.dart';
import 'package:tickets_handler/Model/ticket.dart';

class TicketsBloc extends Bloc<TicketEvents, TicketState> {
  TicketsBloc() : super(TicketsInitState()) {
    on<CreateTicketEvent>((event, emit) async {
      TicketServices ticketServices = TicketServices();
      Ticket ticket = event.ticket!;
      BuildContext context = event.context!;

      emit(TicketsLoadingState());

      Future<String> uploadFile() async {
        Reference storageRef = FirebaseStorage.instance.ref().child('images/');
        var storageTaskSnapshot =
            await storageRef.putFile(io.File(ticket.attachment!));
        String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
        return Future.value(downloadUrl);
      }

      try {
        String downloadUrl = await uploadFile();
        ticket.attachment = downloadUrl;
        await ticketServices.createTicket(ticket);
        print("created ticket");
        emit(TicketCreateState());
        Future.delayed(const Duration(milliseconds: 2000), () {
          Navigator.pop(context, true);
        });
      } catch (e) {
        emit(TicketErrorstate(error: e));
      }
    });

    on<FetchTicketsEvent>((event, emit) async {
      TicketServices ticketServices = TicketServices();
      List<Ticket> tickets = [];
      emit(TicketsLoadingState());
      try {
        tickets = await ticketServices.getAllTickets();
        print("got all ticket");
        emit(TicketsLoadedState(tickets: tickets));
      } catch (e) {
        emit(TicketErrorstate(error: e));
      }
    });
  }
}
