import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controller/chatController.dart';
import '../../controller/dataController.dart';
import '../../controller/styleController.dart';
import '../../controller/widgetController.dart';
import '../../model/chatRoomSessionModel.dart';
import '../../model/messagesSessionModel.dart';
import '../../model/petVeterinarianModel.dart';
import '../../model/veterinarianSessionModel.dart';

class HistorySessionsPage extends StatefulWidget {
  const HistorySessionsPage({super.key});

  @override
  State<HistorySessionsPage> createState() => _HistorySessionsPageState();
}

class _HistorySessionsPageState extends State<HistorySessionsPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('sessions')
            // .where('status', isEqualTo: 'accepted')
            .where('veterinarianId', isEqualTo: FirebaseAuth.instance.currentUser?.uid) // Filter by current doctor
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var sessions = snapshot.data!.docs;

          if (sessions.isEmpty) {
            return Center(child: Text('No previous sessions.'));
          }

          return ListView.builder(
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              var session = sessions[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    'Session Date: ${DateFormat('yyyy-MM-dd hh:mm:ss a').format(((session['timestamp']) as Timestamp).toDate())}',
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pet Owner Name: ${session['petOwnerName']}'),
                      Text('Pet Owner ID: ${session['petOwnerID']}'),
                    ],
                  ),
                  trailing: Container(
                    width: 120,
                    child: MaterialButton(
                      onPressed: () async {
                        showLoadingDialog(context);
                        String status = session['status'];
                        String? petOwnerID = session['petOwnerID'];
                        PetVeterinarian? userProfile ;
                        userProfile = await Provider.of<DataController>(context, listen: false).getPetVeterinarianUser(FirebaseAuth.instance.currentUser?.uid??"");

                        final data = session.data()! as Map<String, dynamic>;
                        VeterinarianSession veterinarianSessionData = VeterinarianSession.fromJson(data);
                        print("ddd___ ${veterinarianSessionData.status}");
                        if (petOwnerID != null) {
                          // showLoadingDialog(context);
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
                      color: Colors.blue, // Change to your main color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.all(0.0),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Details",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

}
