import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tickets_handler/View/Tickets/addTicket.dart';
import 'package:tickets_handler/View/Tickets/bloc/events.dart';
import 'package:tickets_handler/View/Tickets/bloc/states.dart';
import 'package:tickets_handler/View/Tickets/bloc/tickets_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class TicketList extends StatefulWidget {
  const TicketList({Key? key}) : super(key: key);

  @override
  State<TicketList> createState() => _TicketListState();
}

class _TicketListState extends State<TicketList> {
  TicketsBloc ticketsBloc = TicketsBloc();

  @override
  void initState() {
    super.initState();
    ticketsBloc.add(FetchTicketsEvent());
  }

  void _launchURL(url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          title: Text("Tickets List"),
          actions: [
            IconButton(
                onPressed: () async {
                  try{
                  bool val = await
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddTicket(),
                      ));
                  print(val);
                  if(val){
                    ticketsBloc.add(FetchTicketsEvent());
                  }
                  }catch(e){
                    print("err");
                  }
                },
                icon: Icon(
                  Icons.add_circle,
                  color: Colors.white,
                ))
          ],
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            // child: BlocListener<TicketsBloc, TicketState>(
            //     listener: (context, state) {
            //       if(state is TicketCreateState){
            //             ticketsBloc.add(FetchTicketsEvent());
            //       }
            //       // listen to SubmitFieldBloc
            //     },
            child: BlocBuilder<TicketsBloc, TicketState>(
                bloc: ticketsBloc,
                builder: (context, state) {
                  if (state is TicketsLoadedState) {
                    return ListView.builder(
                        itemCount: state.tickets?.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              margin: EdgeInsets.only(
                                  top: index == 0 ? 30 : 5,
                                  bottom: 15,
                                  left: 20,
                                  right: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    new BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 5.0,
                                    ),
                                  ]),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            state.tickets?[index]
                                                    .reportedDate ??
                                                '',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ),
                                        ]),
                                    Text(
                                      state.tickets?[index].title ?? '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.deepOrangeAccent),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      state.tickets?[index].description ?? "",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                    SizedBox(height: 15),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            state.tickets?[index].location ??
                                                "",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey),
                                          ),
                                          // IconButton(
                                          //     onPressed: () => {
                                          //           _launchURL(Uri.parse(state
                                          //                   .tickets?[index]
                                          //                   .attachment ??
                                          //               ""))
                                          //         },
                                          //     icon:
                                          Icon(Icons.attach_file,
                                              color: Colors.white)
                                          // )
                                        ])
                                  ]));
                        });
                  }
                  return Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.white.withOpacity(0.3),
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Colors.deepOrangeAccent,
                      )));
                })
            // )
            ));
  }
}
