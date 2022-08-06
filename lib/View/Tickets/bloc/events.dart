import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:tickets_handler/Model/ticket.dart';

abstract class TicketEvents extends Equatable {
  TicketEvents([List props = const []]) : super();
}


class CreateTicketEvent extends TicketEvents {
  final Ticket? ticket;
  final BuildContext? context;
  CreateTicketEvent({@required this.ticket,this.context}) : super([ticket, context]);

  @override
  String toString() => 'LoggedIn { token: $ticket $context }';

  @override
  // TODO: implement props
  List<Object?> get props => [ticket, context];
}

class FetchTicketsEvent extends TicketEvents {
 
  FetchTicketsEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
