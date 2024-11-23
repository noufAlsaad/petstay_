import 'package:flutter/material.dart';
import '../../model/carProviderSlotModel.dart';

class SessionOwnerDetailsPage extends StatefulWidget {
  const SessionOwnerDetailsPage({super.key , required this.slot});
  final CarProviderSlot slot ;
  @override
  State<SessionOwnerDetailsPage> createState() => _SessionOwnerDetailsPageState();
}

class _SessionOwnerDetailsPageState extends State<SessionOwnerDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
