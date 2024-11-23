import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pethotel/controller/styleController.dart';
import 'package:pethotel/controller/userController.dart';
import 'package:provider/provider.dart';

import '../../controller/dataController.dart';
import '../../controller/widgetController.dart';
import '../../model/petCareModel.dart';
import '../../model/servicesFireBaseModel.dart';

class CarProviderProfile extends StatefulWidget {
  const CarProviderProfile({super.key ,required this.carProviderData});
  final Map<String, dynamic> carProviderData ;
  @override
  State<CarProviderProfile> createState() => _CarProviderProfileState();
}

class _CarProviderProfileState extends State<CarProviderProfile> {
  PetCareProfile? carProviderData ;
  double? earnings ;
  List<Services> servicesList  = [] ;
  List<Services> myServicesListBase  = [] ;
  List<Services> myServicesList  = [] ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(microseconds: 3), () async {
      await updateData();
    });

  }

  Future<void> updateData() async {
    showLoadingDialog(context);
    await getServices();

    String? user_id = await Provider.of<DataController>(context, listen: false).getCareProviderAccountByEmail(widget.carProviderData["email"]);
    if (user_id != null) {
      await Provider.of<UserController>(context, listen: false).getCareProviderProfile(user_id ?? "");
      carProviderData = Provider.of<UserController>(context, listen: false).userCarProviderProfile;
      earnings = await Provider.of<UserController>(context, listen: false).getCareProviderEarnings(user_id ?? "");
      Navigator.of(context).pop();
      // earnings

      setState(() {});
    }
  }

  Future<void> getServices() async {
     servicesList.clear();
     myServicesList.clear();
    await Provider.of<DataController>(context, listen: false).fetchCareProviderServicesFromFirestore(servicesList);
    await Provider.of<DataController>(context, listen: false).fetchCareProviderServicesFromFirestore(myServicesList , mine: true);
     myServicesListBase = List.from(myServicesList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Padding(
        padding: const EdgeInsets.only(top :8.0 , bottom: 8 , right: 15 , left: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 150,
                    height: 150,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: MyStyle.mainColor!, width: 2.0),
                      // Border color and width
                      borderRadius: BorderRadius.circular(
                          25.0), // Border radius to match ClipRRect
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: Image.network(
                        carProviderData?.profileImage ?? "", width: 150,
                        height: 150,
                        errorBuilder: (BuildContext? context, Object? exception,
                            StackTrace? stackTrace) {
                          return Image.network(
                              "https://static.vecteezy.com/system/resources/previews/005/544/718/non_2x/profile-icon-design-free-vector.jpg",
                              width: 150, height: 150);
                        },),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, '/UpdateCarProviderProfile' , arguments: carProviderData,).then((value) async {
                          print("00__$value");
                          if(value != null){
                            await updateData();
                          }

                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.edit , color:MyStyle.mainColor,),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10,),

              customCard(carProviderData?.profileDescription ?? " - " , "Profile Description"),
              customCard(carProviderData?.hotelName ?? " - " , "Care Provider Name"),
              customCard(carProviderData?.hotelPlace ?? " - ","Shelter Place"),
              customCard("${earnings ?? "0.0"} SAR" , "Earnings"),

              Row(
                children: [
                  Expanded(child: customCard(myServicesListBase.isEmpty ? " - "  :   myServicesListBase
                      .map((service) => service.name)
                      .where((name) => name != null) // Filter out null names
                      .join(', '),"My Service")),
                  // Expanded(child: customCard(myServicesListBase.join(', ') ?? " - ","My Service")),
                  InkWell(
                    onTap: (){
                      servicesList.forEach((element) {
                        print("servicesList ${element.id}");
                        print("contains ${myServicesList.contains(element)}");
                      });
                      // myServicesList.forEach((element) {
                      //   print("myServicesList ${element.id}");
                      // });
                      _showServiceDialog();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.edit),
                    ),
                  )
                ],
              ),
              customCard(carProviderData?.email ?? " - ","Email"),
              customCard(carProviderData?.mobile ?? " - ","Mobile"),

              SizedBox(height: 20,),

            ],
          ),
        ),
      ),
    );
  }


  Future _showServiceDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (context, setState) {
            return AlertDialog(
              title: Text('Select Services'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: servicesList.map((Services service) {
                    // bool exists = serviceList.any((service) => service.id == myService.id);
                    bool isSelected = myServicesList.any((myService) => myService.id == service.id);

                    return CheckboxListTile(
                      activeColor: MyStyle.mainColor,
                      title: Text(service.name??"" , style: textStyle(),),
                      value: isSelected,
                      // value: myServicesList.contains(service),
                      onChanged: (bool? value) {
                        setState(() {
                          if(isSelected){
                            myServicesList.removeWhere((element) => element.id ==service.id );
                            // myServicesList.remove(service);
                          }else {
                            myServicesList.add(service);
                            // myServicesList.add(service);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    // Handle the selection
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Done'),
                  onPressed: () {
                    // Handle the selection
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          }
        );
      },
    ).then((value) async {
      print("data updated_1 ${value}");
      if(value){
        CoolAlert.show(width: 400,context: context, type: CoolAlertType.loading ,autoCloseDuration:  const Duration(seconds: 5));
        await Provider.of<DataController>(context, listen: false).removeAllItems() ;
        await Provider.of<DataController>(context, listen: false).addServicesSelectedItems(myServicesList) ;
        await getServices();
        setState(() {});
      }
    });
  }


}
