class MessageModel {
  String? messageId;
  String? message;
  String? idForLastUser;
  DateTime? dateTime;
  String? petOwnerId;
  String? petCareUserId;
  String? petOwnerName;
  String? hotelName;

  MessageModel(
      {this.message,
      this.idForLastUser,
      this.messageId,
      this.dateTime,
      this.petOwnerId,
      this.petCareUserId,
      this.petOwnerName,
      this.hotelName});

  MessageModel.fromJson(Map<String, dynamic> json, String id) {
    messageId = id;
    message = json['message'];
    dateTime = json['dateTime'].toDate();
    idForLastUser = json['idForLastUser'];
    petOwnerId = json['petOwnerId'];
    petCareUserId = json['petCareUserId'];
    petOwnerName = json['petOwnerName'];
    hotelName = json['hotelName'];
  }
}
