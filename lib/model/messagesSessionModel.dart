class MessageSessionModel {
  String? messageId;
  String? message;
  String? idForLastUser;
  DateTime? dateTime;
  String? petOwnerId;
  String? veterinarianUserId;
  String? petOwnerName;
  String? veterinarianName;

  MessageSessionModel(
      {this.message,
      this.idForLastUser,
      this.messageId,
      this.dateTime,
      this.petOwnerId,
      this.veterinarianUserId,
      this.petOwnerName,
      this.veterinarianName});

  MessageSessionModel.fromJson(Map<String, dynamic> json, String id) {
    messageId = id;
    message = json['message'];
    dateTime = json['dateTime'].toDate();
    idForLastUser = json['idForLastUser'];
    petOwnerId = json['petOwnerId'];
    veterinarianUserId = json['veterinarianUserId'];
    petOwnerName = json['petOwnerName'];
    veterinarianName = json['veterinarianName'];
  }
}
