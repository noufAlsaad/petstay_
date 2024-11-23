import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pethotel/view/Veterinarians/session_booked_details_owner.dart';
import 'package:pethotel/view/Veterinarians/session_veterinarian_details.dart';
import 'package:pethotel/view/Veterinarians/update_veterinarian_profile.dart';
import 'package:pethotel/view/Veterinarians/veterinarian_home.dart';
import 'package:pethotel/view/authentication/signInScreen.dart';
import 'package:pethotel/view/authentication/signUpCareProviderScreen.dart';
import 'package:pethotel/view/authentication/signUpPetOwnerScreen.dart';
import 'package:pethotel/view/authentication/signUpVeterinarianScreen.dart';
import 'package:pethotel/view/car_providers/car_provider_profile.dart';
import 'package:pethotel/view/car_providers/car_provider_schedule.dart';
import 'package:pethotel/view/car_providers/slot_details.dart';
import 'package:pethotel/view/car_providers/update_car_provider_profile.dart';
import 'package:pethotel/view/home/car_provider_home.dart';
import 'package:pethotel/view/home/home_page.dart';
import 'package:pethotel/view/pet_owner/create_session_page.dart';
import 'package:pethotel/view/pet_owner/owner_booking_page.dart';
import 'package:pethotel/view/pet_owner/pet_owner_home.dart';
import 'package:pethotel/view/pet_owner/all_slots_owner.dart';
import 'package:pethotel/view/pet_owner/session_owner_details.dart';
import 'package:pethotel/view/pet_owner/slot_booked_details_owner.dart';
import 'package:pethotel/view/pet_owner/slot_details_owner.dart';
import 'package:pethotel/view/pet_owner/update_pet_owner_profile.dart';
import 'package:provider/provider.dart';
import 'controller/chatController.dart';
import 'controller/dataController.dart';
import 'controller/userController.dart';
import 'model/carProviderSlotModel.dart';
import 'model/petCareModel.dart';
import 'model/petOwnerModel.dart';
import 'model/petVeterinarianModel.dart';
import 'model/veterinarianSessionModel.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebaseConfig();


  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<DataController>(create: (_) => DataController()),
      ChangeNotifierProvider<ChatController>(create: (_) => ChatController()),
      ChangeNotifierProvider<UserController>(create: (_) => UserController()),
    ],
    child: const MyApp(),
  ));
}

Future<void> firebaseConfig() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCHH6dMu9sdzv2WtfjKZUvZtf48NzLup8k",
        authDomain: "pet-hotel-b1f59.firebaseapp.com",
        projectId: "pet-hotel-b1f59",
        storageBucket: "pet-hotel-b1f59.appspot.com",
        messagingSenderId: "971077362468",
        appId: "1:971077362468:web:d786580b400178f4f909b1",
        measurementId: "G-1D66MDKC4Z"
    ),
  );
}



class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      initialRoute: '/SignIn',
      routes: {
        '/SignIn': (context) => SignInScreen(),
        '/SignUpPetOwner': (context) => SignUpPetOwnerScreen(),
        '/SignUpVeterinarian': (context) => SignUpVeterinarianScreen(),
        '/SignUpCareProvider': (context) => SignUpCareProviderScreen(),
        '/HomePage': (context) => HomePage(),
        '/CarProviderHome': (context) => CarProviderHome(),
        '/PetOwnerHome': (context) => PetOwnerHome(),
        '/OwnerBookingPage': (context) => OwnerBookingPage(),
        '/SessionPage': (context) => SessionPage(),
        '/VeterinarianHomePage': (context) => VeterinarianHomePage(),
        '/UpdateCarProviderProfile': (context) {
          final PetCareProfile userData = ModalRoute.of(context)!.settings.arguments as PetCareProfile;
          return UpdateCarProviderProfile(carProviderData: userData);
        },
        '/UpdateVeterinarianProfile': (context) {
          final PetVeterinarian userData = ModalRoute.of(context)!.settings.arguments as PetVeterinarian;
          return UpdateVeterinarianProfile(veterinarianData: userData);
        },
        '/UpdatePetOwnerProfilePage': (context) {
          final PetOwnerProfile userData = ModalRoute.of(context)!.settings.arguments as PetOwnerProfile;
          return UpdatePetOwnerProfilePage(petOwnerProfile: userData);
        },
        '/SlotDetailsPage': (context) {
          final CarProviderSlot slot = ModalRoute.of(context)!.settings.arguments as CarProviderSlot;
          return SlotDetailsPage(slot: slot);
        },
        '/SessionVeterinarianDetailsPage': (context) {
          final VeterinarianSession veterinarianSession = ModalRoute.of(context)!.settings.arguments as VeterinarianSession;
          return SessionVeterinarianDetailsPage(veterinarianSession: veterinarianSession);
        },
        '/AllSlotPageOwner': (context) {
          final List<CarProviderSlot> slot = ModalRoute.of(context)!.settings.arguments as List<CarProviderSlot>;
          return AllSlotPageOwner(slot: slot);
        },
        '/SlotDetailsOwnerPage': (context) {
          final CarProviderSlot slot = ModalRoute.of(context)!.settings.arguments as CarProviderSlot;
          return SlotDetailsOwnerPage(slot: slot);
        },
        '/SlotBookedDetailsOwnerPage': (context) {
          final CarProviderSlot slot = ModalRoute.of(context)!.settings.arguments as CarProviderSlot;
          return SlotBookedDetailsOwnerPage(slot: slot);
        },
        '/SessionBookedDetailsOwnerPage': (context) {
          final VeterinarianSession veterinarianSession = ModalRoute.of(context)!.settings.arguments as VeterinarianSession;
          return SessionBookedDetailsOwnerPage(veterinarianSession: veterinarianSession);
        },
        // '/SignUp': (context) => SignUpScreen(),
      },

    );
  }


}