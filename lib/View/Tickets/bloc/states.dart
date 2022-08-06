import 'package:equatable/equatable.dart';
import 'package:tickets_handler/Model/ticket.dart';

abstract class TicketState extends Equatable {
  @override
  List<Object> get props => [];
}

class TicketsInitState extends TicketState {}

class TicketsLoadingState extends TicketState {}

class TicketsLoadedState extends TicketState {
  final List<Ticket>? tickets;
  TicketsLoadedState({this.tickets});
}

class TicketErrorstate extends TicketState {
  final error;
  TicketErrorstate({this.error});
}

class TicketCreateState extends TicketState {
}
