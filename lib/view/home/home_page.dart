import 'package:flutter/material.dart';
import 'package:pethotel/controller/userController.dart';
import 'package:pethotel/controller/widgetController.dart';
import 'package:provider/provider.dart';

import '../../model/petOwnerModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key , this.accountType , this.accountName});
  final String? accountType ;
  final String? accountName ;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // PetOwnerProfile? userProfile ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // userProfile =Provider.of<UserController>(context , listen: false).userPetOwnerProfile ;
  }


  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;


    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Welcome ${args["account_name_n"]}" , style: textStyle(fontSize: 18),),
                Text("Your account is ${args["account_type_n"]}" , style: textStyle(fontSize: 15),),

              ],
            )
          ],
        ),
      ),
    );
  }
}
