
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pethotel/controller/widgetController.dart';
import 'package:provider/provider.dart';

import '../../controller/dataController.dart';
import '../../model/petOwnerNotificationModel.dart';

class NotificationPetOwnerPage extends StatefulWidget {
  const NotificationPetOwnerPage({super.key});

  @override
  State<NotificationPetOwnerPage> createState() => _NotificationPetOwnerPageState();
}

class _NotificationPetOwnerPageState extends State<NotificationPetOwnerPage> {
  List<PetOwnerNotification> myNotification = [] ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(microseconds: 3), () async {
      showLoadingDialog(context);
      myNotification.clear();
      myNotification = await Provider.of<DataController>(context, listen: false).getPetOwnerNotification(FirebaseAuth.instance.currentUser?.uid??"")??[];
      setState(() {});
      Navigator.of(context).pop();

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: myNotification == null ? SizedBox() : Column(
            children: List.generate(myNotification!.length, (index) {
              final item = myNotification![index] ;

              return Card(
                child: ListTile(
                  onTap: () async {

                  },
                  title: Text(
                    "${item.msg}",
                    style: textStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    "Notification from ${item.carProviderName}",
                    style: textStyle(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    "${item.addedAt!.toDate()??""}",
                    style: textStyle(),
                  ),
                ),
              );

            }),
          ),
        ),
    );
  }
}
