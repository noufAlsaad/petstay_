import '../model/messagesModel.dart';

class ChatRoomModel {
  String? id;
  String? petOwnerId;
  String? petCareUserId;
  String? petOwnerName;
  String? hotelName;
  bool? isPetCare;
  MessageModel? message;

  ChatRoomModel({
    this.id,
    this.petOwnerId,
    this.petCareUserId,
    this.petOwnerName,
    this.hotelName,
    this.isPetCare,
    this.message,
  });

  ChatRoomModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    petOwnerId = json['petOwnerId'];
    petCareUserId = json['petCareUserId'];
    petOwnerName = json['petOwnerName'];
    hotelName = json['hotelName'];
    isPetCare = json['isPetCare'];
    if (json['lastMessage'] != null) {
      message = MessageModel.fromJson(json['lastMessage'], '');
    }
  }
}
