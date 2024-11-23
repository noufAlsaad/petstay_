import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pethotel/model/messagesSessionModel.dart';
import 'package:provider/provider.dart';

import '../../controller/chatController.dart';
import '../../controller/dataController.dart';
import '../../controller/styleController.dart';
import '../../controller/widgetController.dart';
import '../../model/chatRoomModel.dart';
import '../../model/chatRoomSessionModel.dart';
import '../../model/messagesModel.dart';
import '../../model/petVeterinarianModel.dart';
import '../../model/veterinarianSessionModel.dart';

class PendingSessionsPage extends StatefulWidget {
  const PendingSessionsPage({super.key});

  @override
  State<PendingSessionsPage> createState() => _PendingSessionsPageState();
}

class _PendingSessionsPageState extends State<PendingSessionsPage> {
  PetVeterinarian? userProfile ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      userProfile = await Provider.of<DataController>(context, listen: false).getPetVeterinarianUser(FirebaseAuth.instance.currentUser?.uid??"");

    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('sessions')
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var sessions = snapshot.data!.docs;

          if (sessions.isEmpty) {
            return Center(child: Text('No pending sessions.'));
          }

          return ListView.builder(
            itemCount: sessions.length,
            itemBuilder: (contextB, index) {
              var session = sessions[index];
              return Card(
                child: ListTile(
                  title: Text('Session Date: ${DateFormat('yyyy-MM-dd hh:mm:ss a').format(((session['timestamp']) as Timestamp).toDate())}'),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pet Owner Name: ${session['petOwnerName']}'),
                      Text('Pet Owner ID: ${session['petOwnerID']}'),
                    ],
                  ),
                  trailing:    Container(
                    width: 120,
                    child: MaterialButton(
                        onPressed: () async {
                          showLoadingDialog(context);
                         await  acceptSession(session.id);
                          Navigator.pop(context);
                         showDialog(
                           context: context,
                           barrierDismissible: false,
                           builder: (context) {
                             return AlertDialog(
                               title: Text('Session Accepted' , style: textStyle(fontWeight: FontWeight.w600 , fontSize: 16),),
                               content: StreamBuilder<DocumentSnapshot>(
                                 stream: FirebaseFirestore.instance.collection('sessions').doc(session.id).snapshots(),
                                 builder: (context, snapshot) {
                                   if (!snapshot.hasData) {
                                     return Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child: Column(
                                         mainAxisSize: MainAxisSize.min,
                                         children: [
                                           SizedBox(
                                             width: 25,
                                             height: 25,
                                             // padding: const EdgeInsets.all(15.0),
                                             child: CircularProgressIndicator(),
                                           ),
                                         ],
                                       ),
                                     );
                                   }
                                   String status = snapshot.data!['status'];
                                   String? petOwnerID = snapshot.data?['petOwnerID'];
                                  if (status == 'accepted') {
                                     return Column(
                                       mainAxisSize: MainAxisSize.min,
                                       children: [
                                         MaterialButton(
                                             onPressed: () async {
                                               final data = snapshot.data!.data()! as Map<String, dynamic>;
                                               VeterinarianSession veterinarianSessionData = VeterinarianSession.fromJson(data);
                                                print("ddd___ ${veterinarianSessionData.status}");
                                               if (petOwnerID != null) {
                                                 showLoadingDialog(context);
                                                 if (userProfile != null) {
                                                   final chatRoom = ChatRoomSessionModel(
                                                     petOwnerId: petOwnerID,
                                                     petOwnerName: "${userProfile!.firstName} ${userProfile!.lastName}",
                                                     isPetCare: true,
                                                     veterinarianName: "${userProfile?.firstName ?? ""} ${userProfile?.lastName ?? ""}",
                                                     veterinarianId: FirebaseAuth.instance.currentUser!.uid,
                                                     message: MessageSessionModel(
                                                       message: '',
                                                     ),
                                                   );
                                                   ///
                                                   await ChatController().createChatRoomSession(chatRoom: chatRoom ,sessionID: session.id??"");
                                                   Navigator.pop(context);
                                                   Navigator.pushNamed(
                                                       context, '/SessionVeterinarianDetailsPage',
                                                       arguments: veterinarianSessionData);
                                                 }
                                               }
                                             },
                                             color: MyStyle.grey200,
                                             elevation: 4,
                                             // color: Theme_Information.Button_Color,
                                             // color: MyStyle.mainColor,
                                             shape: RoundedRectangleBorder(
                                                 borderRadius: BorderRadius.circular(10.0)),
                                             padding: const EdgeInsets.all(0.0),
                                             child: Center(
                                               child: Padding(
                                                 padding: const EdgeInsets.all(16.0),
                                                 child: Text(
                                                   "Enter the session details",
                                                   style: textStyle(
                                                       fontWeight: FontWeight.bold,
                                                       color: MyStyle.mainColor),
                                                   textAlign: TextAlign.center,
                                                 ),
                                               ),
                                             )),
                                       ],
                                     );
                                   }
                                   return Container();
                                 },
                               ),
                             );
                           },
                         );
                        },
                        color: MyStyle.mainColor,
                        elevation: 4,
                        // color: Theme_Information.Button_Color,
                        // color: MyStyle.mainColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        padding: const EdgeInsets.all(0.0),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "Accept",
                              style: textStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
  Future<void> acceptSession(String sessionId) async {
    await FirebaseFirestore.instance.collection('sessions').doc(sessionId).update({
      'veterinarianId': FirebaseAuth.instance.currentUser?.uid??"",
      'veterinarianName': "${userProfile?.firstName??""}  ${userProfile?.lastName??""}",
      'status': 'accepted',
    });
  }
}
