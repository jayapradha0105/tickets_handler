import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tickets_handler/Model/ticket.dart';
import 'package:tickets_handler/View/Tickets/bloc/events.dart';
import 'package:tickets_handler/View/Tickets/bloc/states.dart';
import 'package:tickets_handler/View/Tickets/bloc/tickets_bloc.dart';
import 'package:intl/intl.dart';

class AddTicket extends StatefulWidget {
  const AddTicket({Key? key}) : super(key: key);

  @override
  State<AddTicket> createState() => _AddTicketState();
}

class _AddTicketState extends State<AddTicket> {
  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  TextEditingController reportedDateController = new TextEditingController();
  TicketsBloc ticketsBloc = TicketsBloc();
  String attachment = "";
  String filename = "", msg = "";

  void _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        attachment = result.files.single.path!;
        String basename = attachment.split('/').last;
        setState(() {
          filename = basename;
        });
      }
    } on PlatformException catch (e) {
      print('Unsupported operation' + e.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    setState(() {
      reportedDateController.text = formattedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          title: Text("Create Ticket"),
        ),
        body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(25),
                child: BlocBuilder<TicketsBloc, TicketState>(
                    bloc: ticketsBloc,
                    builder: (BuildContext context, TicketState state) {
                      if (state is TicketsLoadingState) {
                        return Container(
                            height: MediaQuery.of(context).size.height,
                            color: Colors.white.withOpacity(0.3),
                            child: Center(
                                child: CircularProgressIndicator(
                              color: Colors.deepOrangeAccent,
                            )));
                      } else if (state is TicketCreateState) {
                        print("I am the setstate");
                        titleController.text = "";
                        descriptionController.text = "";
                        locationController.text = "";
                        filename = "";
                        msg = "Ticket Added";
                      }
                      return bodyWidget();
                    }))));
  }

  bodyWidget() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: TextField(
              keyboardType: TextInputType.text,
              controller: titleController,
              style: TextStyle(fontSize: 14, color: Colors.black),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter ticket title",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              )),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: TextField(
              keyboardType: TextInputType.text,
              controller: descriptionController,
              style: TextStyle(fontSize: 14, color: Colors.black),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter ticket description",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              )),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: TextField(
              keyboardType: TextInputType.text,
              controller: locationController,
              style: TextStyle(fontSize: 14, color: Colors.black),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter ticket location",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              )),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: TextField(
              keyboardType: TextInputType.text,
              enabled: false,
              controller: reportedDateController,
              style: TextStyle(fontSize: 14, color: Colors.black),
              decoration: InputDecoration(
                border: InputBorder.none,
              )),
        ),
        Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: [
                TextButton(
                    onPressed: () => {_pickFiles()},
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.deepOrangeAccent,
                            borderRadius: BorderRadius.circular(6)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        child: Center(
                          child: Text(
                            "Choose File",
                            style: TextStyle(color: Colors.white),
                          ),
                        ))),
                // SizedBox(width: 10),
                Text(
                  filename,
                  style: TextStyle(fontSize: 13, color: Colors.black),
                )
              ],
            )),
        GestureDetector(
            child: Container(
              height: 48,
              margin: EdgeInsets.only(top: 60),
              decoration: BoxDecoration(
                  color: Colors.deepOrangeAccent,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text("Submit",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
            onTap: () => {
                  if (titleController.text.trim() != "" &&
                      descriptionController.text.trim() != "" &&
                      locationController.text.trim() != "")
                    {
                      ticketsBloc.add(CreateTicketEvent(
                          ticket: Ticket(
                              title: titleController.text,
                              description: descriptionController.text,
                              location: locationController.text,
                              reportedDate: reportedDateController.text,
                              attachment: attachment),
                          context: context))
                    }
                  else
                    {
                      setState(() {
                        msg = "All fields are mandatory";
                      })
                    }
                }),
        SizedBox(height: 50),
        Text(
          msg,
          style: TextStyle(color: Colors.black, fontSize: 18),
        )
      ],
    );
  }
}
