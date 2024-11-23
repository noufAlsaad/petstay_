import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/chatController.dart';
import '../../controller/dataController.dart';
import '../../controller/styleController.dart';
import '../../controller/widgetController.dart';
import '../../model/carProviderSlotModel.dart';
import '../../model/chatRoomModel.dart';

class AllSlotPageOwner extends StatefulWidget {
  const AllSlotPageOwner({super.key , required this.slot});
  final List<CarProviderSlot> slot ;
  @override
  State<AllSlotPageOwner> createState() => _AllSlotPageOwnerState();
}

class _AllSlotPageOwnerState extends State<AllSlotPageOwner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: MyStyle.white),
        // leading: SizedBox(),
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
        backgroundColor: MyStyle.mainColor,
        title: Text('All Slots' , style: textStyle(fontSize: 16 , color: MyStyle.white),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(widget.slot.length, (index) {
            final item = widget.slot[index] ;

            return Card(
              child: ListTile(
                onTap: () async {
                  Navigator.pushNamed(
                      context, '/SlotDetailsOwnerPage',
                      arguments: item);
                },
                title: Text(
                  "Slot on: ${item.date} With ${item.careProviderName?? " - "}",
                  style: textStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  "Time: ${item.fromTime}",
                  style: textStyle(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  item.status?.toUpperCase() ?? "",
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
