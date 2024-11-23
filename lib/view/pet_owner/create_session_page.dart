import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controller/styleController.dart';
import '../../controller/userController.dart';
import '../../controller/widgetController.dart';
import '../../model/carProviderSlotModel.dart';
import '../../model/petOwnerModel.dart';
import '../../model/veterinarianSessionModel.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({super.key});

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  int screenIndex = 0;
  List<Widget> screens = [];
  PetOwnerProfile? petOwnerData ;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(microseconds: 3), () async {
      await updateData();
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    screens = [
      requestSession(),
      historySession(),
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: MyStyle.white),
        // leading: SizedBox(),
        backgroundColor: MyStyle.mainColor,
        title: Text(
          dataTitle(), style: textStyle(fontSize: 16, color: MyStyle.white),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Image.asset(
              "assets/images/logo.png",
              scale: 2,
              color: MyStyle.white,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: MyStyle.mainColor,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildRow(
                  title: "Request  a Session", icon: Icons.calendar_month, index: 0, onTap: () {
                setState(() {
                  screenIndex = 0;
                });
              }, screenIndex: screenIndex),
              buildRow(title:  "Sessions History",
                  icon: Icons.history,
                  index: 1,
                  onTap: () {
                    setState(() {
                      screenIndex = 1;
                    });
                  } ,screenIndex: screenIndex),
            ],
          ),
        ),
      ),
      body: screens[screenIndex],
    );
  }

  String dataTitle() {
    if (screenIndex == 0) {
      return 'Request  a Session';
    } else if (screenIndex == 1) {
      return 'Sessions History';
    }
    return "";
  }


  Widget requestSession(){
   return Column(
     mainAxisAlignment: MainAxisAlignment.center,
     crossAxisAlignment: CrossAxisAlignment.center,
     children: [
       Text("You can request a session with one of our available doctors." ,style: textStyle(fontSize: 16 , fontWeight: FontWeight.w600),),
        SizedBox(height: 50,),
       Align(
         alignment: Alignment.center,
         child: Container(
           width: 400,
           child: MaterialButton(
               onPressed: () async {
                  showLoadingDialog(context);

                  final session = VeterinarianSession(
                    petOwnerId: FirebaseAuth.instance.currentUser?.uid,
                    veterinarianId: null,
                    veterinarianName: null,
                    petOwnerName: "${petOwnerData?.firstName ?? ""} ${petOwnerData?.lastName ?? ""}",
                    status: 'pending',
                  );

                 DocumentReference docRef = await FirebaseFirestore.instance.collection('sessions').add(session.toJson());
                 String sessionId = docRef.id;
                  await FirebaseFirestore.instance
                      .collection("sessions")
                      .doc(sessionId)
                      .update({"sessionID": sessionId});

                  Navigator.of(context).pop();
                 showDialog(
                   context: context,
                   barrierDismissible: false,
                   builder: (context) {
                     return AlertDialog(
                       title: Text('Session Status' , style: textStyle(fontWeight: FontWeight.w600 , fontSize: 16),),
                       content: StreamBuilder<DocumentSnapshot>(
                         stream: FirebaseFirestore.instance.collection('sessions').doc(sessionId).snapshots(),
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
                           if (status == 'pending') {
                             return Column(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 Column(
                                   mainAxisSize: MainAxisSize.min,
                                   children: [
                                     Text('Waiting for a doctor to accept your session.' , style: textStyle(),),
                                     SizedBox(height: 10,),
                                     Text('Or you can see all sessions.' , style: textStyle(),),
                                     SizedBox(height: 20,),
                                     MaterialButton(
                                         onPressed: () async {
                                           Navigator.of(context).pop();
                                         setState(() {
                                           screenIndex = 1 ;
                                         });
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
                                               "Show all sessions",
                                               style: textStyle(
                                                   fontWeight: FontWeight.bold,
                                                   color: MyStyle.mainColor),
                                               textAlign: TextAlign.center,
                                             ),
                                           ),
                                         )),

                                   ],
                                 ),
                               ],
                             );
                           } else if (status == 'accepted') {
                             return Column(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 Text('A doctor has accepted your session.' , style: textStyle(),),
                                 SizedBox(height: 20,),
                                 MaterialButton(
                                     onPressed: () async {
                                       final data = snapshot.data! as Map<String, dynamic>;
                                       VeterinarianSession veterinarianSessionData = VeterinarianSession.fromJson(data);
                                       // /SessionBookedDetailsOwnerPage
                                       Navigator.pushNamed(
                                           context, '/SessionBookedDetailsOwnerPage',
                                           arguments: veterinarianSessionData);
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
                     "Request a session",
                     style: textStyle(
                         fontWeight: FontWeight.bold,
                         color: MyStyle.mainColor),
                     textAlign: TextAlign.center,
                   ),
                 ),
               )),
         ),
       ),

     ],
   );
  }

  Future<void> updateData() async {
    showLoadingDialog(context);

    String? user_id = FirebaseAuth.instance.currentUser?.uid;
    if (user_id != null) {
      await Provider.of<UserController>(context, listen: false).getPetOwnerProfile(user_id ?? "");
      petOwnerData = Provider.of<UserController>(context, listen: false).userPetOwnerProfile;
      Navigator.of(context).pop();
      // earnings

      setState(() {});
    }
  }


  Widget historySession() {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('sessions')
          .where('petOwnerID', isEqualTo: userId) // Filter by current user
      // .where('status', whereIn: ['accepted', 'completed']) // Include accepted or completed sessions
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var sessions = snapshot.data!.docs;

        if (sessions.isEmpty) {
          return Center(child: Text('No previous sessions.'));
        }

        // Sort sessions locally by timestamp
        sessions.sort((a, b) {
          return (b['timestamp'] as Timestamp).compareTo(a['timestamp'] as Timestamp);
        });


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
                    Text('Veterinarian Name: ${session['veterinarianName'] ?? 'N/A'}'), // Display doctor ID if available
                    Text('Status: ${session['status']}'),
                  ],
                ),
                trailing: session['status'] == 'pending' ? SizedBox()  : Container(
                  width: 120,
                  child: MaterialButton(
                      onPressed: () async {
                        final data = session.data()! as Map<String, dynamic>;
                        VeterinarianSession veterinarianSessionData = VeterinarianSession.fromJson(data);
                        // /SessionBookedDetailsOwnerPage
                        Navigator.pushNamed(
                            context, '/SessionBookedDetailsOwnerPage',
                            arguments: veterinarianSessionData);

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
                            "Details",
                            style: textStyle(
                                fontWeight: FontWeight.bold,
                                color: MyStyle.mainColor),
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
    );
  }

}
