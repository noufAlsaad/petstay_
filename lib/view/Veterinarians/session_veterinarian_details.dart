import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pethotel/controller/chatController.dart';
import 'package:pethotel/controller/dataController.dart';
import 'package:pethotel/model/messagesSessionModel.dart';
import 'package:provider/provider.dart';

import '../../controller/styleController.dart';
import '../../controller/userController.dart';
import '../../controller/widgetController.dart';
import '../../model/carProviderSlotModel.dart';
import '../../model/messagesModel.dart';
import '../../model/petCareModel.dart';
import '../../model/petOwnerModel.dart';
import '../../model/veterinarianSessionModel.dart';

class SessionVeterinarianDetailsPage extends StatefulWidget {
  const SessionVeterinarianDetailsPage({super.key ,required this.veterinarianSession});
  final VeterinarianSession veterinarianSession ;

  @override
  State<SessionVeterinarianDetailsPage> createState() => _SessionVeterinarianDetailsPageState();
}

class _SessionVeterinarianDetailsPageState extends State<SessionVeterinarianDetailsPage> {
  PetOwnerProfile? petOwnerProfile ;
  Map<String, dynamic>? ratingData ;
  TextEditingController? _controller;
  Stream<List<MessageSessionModel>>? _stream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(microseconds: 3), () async {
      if(widget.veterinarianSession.petOwnerName != null){
        CoolAlert.show(width: 400,context: context, type: CoolAlertType.loading ,autoCloseDuration:  const Duration(seconds: 2));
        String? user_id = await Provider.of<DataController>(context, listen: false).getPetOwnerAccountByEmail(widget.veterinarianSession.petOwnerId??"");
        petOwnerProfile = await Provider.of<DataController>(context, listen: false).getPetOwnerProfile(widget.veterinarianSession.petOwnerId??"");
        _controller = TextEditingController();
        ratingData = await Provider.of<UserController>(context, listen: false).getRatingBySession(widget.veterinarianSession);
        _stream = ChatController().messagesSessionStream(roomId: '${widget.veterinarianSession.petOwnerId}-${widget.veterinarianSession.veterinarianId}-${widget.veterinarianSession.sessionID}');
        print("dffd ${_stream}");
        print("dffd ${widget.veterinarianSession.petOwnerId}-${widget.veterinarianSession.veterinarianId}-${widget.veterinarianSession.sessionID}");
        // y0Pxbi7wWwQ5Fac5qsFaFInr6ZG3-8MZq3MteQHQlb4RgZDT4qKA84RH3-3ZxAKleZFqEZ11RxaBVj
        setState(() {});
      }
    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: MyStyle.white),
        // leading: SizedBox(),
        backgroundColor: MyStyle.mainColor,
        title: Text('Slot Details' , style: textStyle(fontSize: 16 , color: MyStyle.white),),
      ),
      body:  bodyWithPetOwner(),
    );
  }

  Row bodyWithPetOwner() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [

                  customCard(DateFormat('yyyy-MM-dd hh:mm:ss a').format(((widget.veterinarianSession.timestamp) as Timestamp).toDate()) , "Session Date"),
                  customCard(widget.veterinarianSession.status?? " - " , "Status"),
                  if(ratingData != null)customCard("${ratingData!["rating"]?? " - " }", "Pet Owner Rating"),
                  customCard(widget.veterinarianSession.veterinarianName?? " - " , "Veterinarian Name"),
                  // if(petOwnerProfile != null )customCard("${petOwnerProfile!.firstName} ${petOwnerProfile!.lastName}", "Pet Owner"),
                  if(petOwnerProfile != null )Row(
                    children: [
                      Expanded(child: customCard("${petOwnerProfile!.firstName} ${petOwnerProfile!.lastName}", "Pet Owner")),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 4.0 , left: 8 , right: 8),
                        child: InkWell(
                          onTap: (){
                            _showDialog(context);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10), // Add margin between cards
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0), // Match the border radius
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(Icons.message),
                                          )
                                        ],
                                      ),
                                      // Text style
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                  if(petOwnerProfile != null )customCard("${petOwnerProfile!.email}", "Pet Owner Email"),
                  if(petOwnerProfile != null )customCard("${petOwnerProfile!.petAge}", "Pet Age"),
                  if(petOwnerProfile != null )customCard("${petOwnerProfile!.petHeight}", "Pet Height"),
                  if(petOwnerProfile != null )customCard("${petOwnerProfile!.petType}", "Pet Type"),
                  if(petOwnerProfile != null )customCard("${petOwnerProfile!.petWeight}", "Pet Weight"),


                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Card(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Chat with the pet owner" , style: textStyle(fontSize: 16 , fontWeight: FontWeight.w500),),
                  )),
                  ///
                  Expanded(
                    child: StreamBuilder<List<MessageSessionModel>>(
                      stream: _stream,
                      builder: (c, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.amber,
                            ),
                          );
                        }

                        List<MessageSessionModel> messages = snap.data??[];

                        if (messages != null) {
                          return Container(
                            height: (MediaQuery.of(context).size.height -
                                MediaQuery.of(context).padding.top) * .55,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              reverse: true,
                              itemCount: messages.length,
                              itemBuilder: (c, i) {
                                return messages[i].idForLastUser == FirebaseAuth.instance.currentUser!.uid
                                    ? MyMessageWidget(
                                  message: messages[i],
                                  myName: "Me",
                                )
                                    : OtherIdMessageWidget(
                                  message: messages[i],
                                  seniorName: "${petOwnerProfile?.firstName} ${petOwnerProfile?.lastName}",
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                try {
                                  if (DateFormat.yMMMd()
                                      .format(messages[index].dateTime!) !=
                                      DateFormat.yMMMd()
                                          .format(messages[index - 1].dateTime!)) {
                                    return buildContainerDate(messages, index);
                                  } else {
                                    return SizedBox();
                                  }
                                } catch (e) {
                                  print("eee $e");
                                  if (e
                                      .toString()
                                      .contains("Not in inclusive range 0..1: -1")) {
                                    return buildContainerDate(messages, index);
                                  }
                                  return SizedBox();
                                }
                              },
                            ),
                          );
                        }
                        return SizedBox();
                      },
                    ),
                  ),

                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onFieldSubmitted: (value){
                            sendMsg();
                          },
                          style: textStyle(),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: MyStyle.mainColor!, width: 2.0)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:  BorderSide(
                                    color: MyStyle.mainColor!, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:  BorderSide(
                                    color: MyStyle.mainColor!, width: 1.5),
                              ),
                              filled: true,

                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.send,
                                    color: MyStyle.mainColor!
                                  ),
                                  onPressed: () {
                                    sendMsg();
                                  })),
                          controller: _controller,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  )
                  ///
                ],
              ),
            ),
          )
        ],
      );
  }
  ///
  void _showDialog(BuildContext context ) {
    final TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Send message to pet owner' , style: textStyle(),),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(hintText: 'Type something...'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Handle the input when the button is pressed
                String inputText = textController.text;
                print('Input: $inputText'); // You can do whatever you want with the input here
                showLoadingDialog(context);
                await Provider.of<DataController>(context, listen: false).sendNotificationToPetOwner(inputText , widget.veterinarianSession.petOwnerId??"" , widget.veterinarianSession.veterinarianName??"");

                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }
  ///
  void sendMsg() {
    if (_controller!.text.isNotEmpty) {
      // ChatController().insertMessageNormalChatPetOwner( /// owner
      ChatController().insertMessageSessionChatVeterinarian( /// veterinarian
        message: MessageSessionModel(
          message: _controller!.text,
          petOwnerId: widget.veterinarianSession.petOwnerId,
          veterinarianUserId: widget.veterinarianSession.veterinarianName,
          veterinarianName: "Me",
          petOwnerName: "${petOwnerProfile?.firstName} ${petOwnerProfile?.lastName}" ,
        ),
        roomId: '${widget.veterinarianSession.petOwnerId}-${widget.veterinarianSession.veterinarianId}-${widget.veterinarianSession.sessionID}',
      );

    } else {}
    _controller!.clear();
  }

  Container buildContainerDate(List<MessageSessionModel> messages, int index) {
    return Container(
      child: Center(
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                Text(DateFormat.yMMMd().format(messages[index].dateTime!),
                    style: textStyle(
                      color: Colors.black,
                      fontSize: 15,
                    )),
              ))),
    );
  }

}


class MyMessageWidget extends StatelessWidget {
  final MessageSessionModel? message;
  final String? myName;
  final String? myImg;

  const MyMessageWidget({Key? key, this.myImg, this.myName, this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              getMessageClient(context),
              SizedBox(
                width: 5,
              ),
              Text(
                "${DateFormat.Hm().format(message!.dateTime!)}",
                maxLines: 20,
                style: textStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container getMessageClient(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * .7,
      ),
      decoration: BoxDecoration(
        color: MyStyle.mainColor!.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          "${message!.message}",
          maxLines: 20,
          style: textStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class OtherIdMessageWidget extends StatelessWidget {
  final MessageSessionModel? message;
  final String? seniorName;
  const OtherIdMessageWidget(
      {Key? key, this.seniorName, this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${DateFormat.Hm().format(message!.dateTime!)}",
                maxLines: 20,
                style: textStyle(
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              getMessageClient(context),
            ],
          ),
        ],
      ),
    );
  }

  Container getMessageClient(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * .7,
      ),
      decoration: BoxDecoration(
        color: Color.fromARGB(128, 231, 220, 199),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          "${message!.message}",
          maxLines: 20,
          style: textStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

