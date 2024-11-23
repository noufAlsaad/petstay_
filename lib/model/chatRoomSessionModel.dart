import '../model/messagesModel.dart';
import 'messagesSessionModel.dart';

class ChatRoomSessionModel {
  String? id;
  String? petOwnerId;
  String? veterinarianId;
  String? petOwnerName;
  String? veterinarianName;
  bool? isPetCare;
  MessageSessionModel? message;

  ChatRoomSessionModel({
    this.id,
    this.petOwnerId,
    this.veterinarianId,
    this.petOwnerName,
    this.veterinarianName,
    this.isPetCare,
    this.message,
  });

  ChatRoomSessionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    petOwnerId = json['petOwnerId'];
    veterinarianId = json['veterinarianId'];
    petOwnerName = json['petOwnerName'];
    veterinarianName = json['veterinarianName'];
    isPetCare = json['isPetCare'];
    if (json['lastMessage'] != null) {
      message = MessageSessionModel.fromJson(json['lastMessage'], '');
    }
  }
}
