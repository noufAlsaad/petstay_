import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:pethotel/model/messagesSessionModel.dart';
import '../model/chatRoomSessionModel.dart';
import '../model/messagesModel.dart';
import '../model/chatRoomModel.dart';

class ChatController extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;


  Future createChatRoom(
      {required ChatRoomModel chatRoom ,required String slotID}) async {
    print("ff");
    // print("ff ${'${chatRoom.petOwnerId}-${chatRoom.petCareUserId}-$slotID'}");
    await firestore
        .collection('ChatRooms')
        .doc("NormalChat")
        .collection("Chat")
        .doc('${chatRoom.petOwnerId}-${chatRoom.petCareUserId}-$slotID')
        .set({
      'petOwnerId': chatRoom.petOwnerId,
      'petOwnerName': chatRoom.petOwnerName,
      'petCareUserId': chatRoom.petCareUserId,
      'hotelName': chatRoom.hotelName,
      'lastMessage': {
        'message': chatRoom.message!.message,
        'dateTime': Timestamp.now(),
        'isClient': true,
      }
    });
  }


  Future createChatRoomSession(
      {required ChatRoomSessionModel chatRoom ,required String sessionID}) async {
    print("ff");
    // print("ff ${'${chatRoom.petOwnerId}-${chatRoom.petCareUserId}-$slotID'}");
    await firestore
        .collection('ChatRooms')
        .doc("SessionChat")
        .collection("Chat")
        .doc('${chatRoom.petOwnerId}-${chatRoom.veterinarianId}-$sessionID')
        .set({
      'petOwnerId': chatRoom.petOwnerId,
      'petOwnerName': chatRoom.petOwnerName,
      'veterinarianId': chatRoom.veterinarianId,
      'veterinarianName': chatRoom.veterinarianName,
      'lastMessage': {
        'message': chatRoom.message!.message,
        'dateTime': Timestamp.now(),
        'isClient': true,
      }
    });
  }

  Future insertMessageNormalChat(
      {required String roomId, required MessageModel message}) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference reference = firestore
        .collection('ChatRooms')
        .doc("NormalChat")
        .collection("Chat")
        .doc(roomId);

    DocumentReference ref = firestore
        .collection('ChatRooms')
        .doc("NormalChat")
        .collection("Chat")
        .doc(roomId)
        .collection('messages')
        .doc();

    batch.update(reference, {
      'lastMessage': {
        'message': message.message,
        'dateTime': Timestamp.now(),
        'isClient': false,
        'idForLastUser': FirebaseAuth.instance.currentUser!.uid,
        'petOwnerId': message.petOwnerId,
        'petCareUserId': message.petCareUserId,
        'hotelName': message.hotelName,
        'petOwnerName': message.petOwnerName,
      }
    });

    batch.set(ref, {
      'message': message.message,
      'idForLastUser': FirebaseAuth.instance.currentUser!.uid,
      'dateTime': Timestamp.now(),
      'isClient': false,
      'petOwnerId': message.petOwnerId,
    });

    await batch.commit().catchError((e) {
      throw e;
    });
  }



  Future insertMessageSessionChatVeterinarian(
      {required String roomId, required MessageSessionModel message}) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference reference = firestore
        .collection('ChatRooms')
        .doc("SessionChat")
        .collection("Chat")
        .doc(roomId);

    DocumentReference ref = firestore
        .collection('ChatRooms')
        .doc("SessionChat")
        .collection("Chat")
        .doc(roomId)
        .collection('messages')
        .doc();

    batch.update(reference, {
      'lastMessage': {
        'message': message.message,
        'dateTime': Timestamp.now(),
        'isClient': false,
        'idForLastUser': FirebaseAuth.instance.currentUser!.uid,
        'petOwnerId': message.petOwnerId,
        'veterinarianUserId': message.veterinarianUserId,
        'veterinarianName': message.veterinarianName,
        'petOwnerName': message.petOwnerName,
      }
    });

    batch.set(ref, {
      'message': message.message,
      'idForLastUser': FirebaseAuth.instance.currentUser!.uid,
      'dateTime': Timestamp.now(),
      'isClient': false,
      'petOwnerId': message.petOwnerId,
    });

    await batch.commit().catchError((e) {
      throw e;
    });
  }



  Future insertMessageNormalChatPetOwner(
      {required String roomId, required MessageModel message}) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference reference = firestore
        .collection('ChatRooms')
        .doc("NormalChat")
        .collection("Chat")
        .doc(roomId);

    DocumentReference ref = firestore
        .collection('ChatRooms')
        .doc("NormalChat")
        .collection("Chat")
        .doc(roomId)
        .collection('messages')
        .doc();

    batch.update(reference, {
      'lastMessage': {
        'message': message.message,
        'dateTime': Timestamp.now(),
        'isClient': true,
        'idForLastUser': message.petOwnerId,
        // 'idForLastUser': FirebaseAuth.instance.currentUser!.uid,
        'petOwnerId': message.petOwnerId,
        'petCareUserId': message.petCareUserId,
        'hotelName': message.hotelName,
        'petOwnerName': message.petOwnerName,
      }
    });

    batch.set(ref, {
      'message': message.message,
      'idForLastUser': message.petOwnerId,
      // 'idForLastUser': FirebaseAuth.instance.currentUser!.uid,
      'dateTime': Timestamp.now(),
      'isClient': true,
      'petOwnerId': message.petOwnerId,
    });

    await batch.commit().catchError((e) {
      throw e;
    });
  }


  Future insertMessageSessionChatPetOwner(
      {required String roomId, required MessageSessionModel message}) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference reference = firestore
        .collection('ChatRooms')
        .doc("SessionChat")
        .collection("Chat")
        .doc(roomId);

    DocumentReference ref = firestore
        .collection('ChatRooms')
        .doc("SessionChat")
        .collection("Chat")
        .doc(roomId)
        .collection('messages')
        .doc();

    batch.update(reference, {
      'lastMessage': {
        'message': message.message,
        'dateTime': Timestamp.now(),
        'isClient': true,
        'idForLastUser': message.petOwnerId,
        // 'idForLastUser': FirebaseAuth.instance.currentUser!.uid,
        'petOwnerId': message.petOwnerId,
        'veterinarianUserId': message.veterinarianUserId,
        'veterinarianName': message.veterinarianName,
        'petOwnerName': message.petOwnerName,
      }
    });

    batch.set(ref, {
      'message': message.message,
      'idForLastUser': message.petOwnerId,
      // 'idForLastUser': FirebaseAuth.instance.currentUser!.uid,
      'dateTime': Timestamp.now(),
      'isClient': true,
      'petOwnerId': message.petOwnerId,
    });

    await batch.commit().catchError((e) {
      throw e;
    });
  }


  Stream<List<MessageModel>> messagesStream(
      {required String roomId}) {
    var snapshots = firestore
        .collection('ChatRooms')
        .doc("NormalChat")
        .collection("Chat")
        .doc(roomId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots();

    return snapshots.map((event) => event.docs
        .map((e) => MessageModel.fromJson(e.data(), e.id))
        .toList()
        .reversed
        .toList());
  }


  Stream<List<MessageSessionModel>> messagesSessionStream(
      {required String roomId}) {
      var snapshots = firestore
          .collection('ChatRooms')
          .doc("SessionChat")
          .collection("Chat")
          .doc(roomId)
          .collection('messages')
          .orderBy('dateTime')
          .snapshots();

      return snapshots.map((event) => event.docs
          .map((e) => MessageSessionModel.fromJson(e.data(), e.id))
          .toList()
          .reversed
          .toList());
  }

  Stream<List<ChatRoomModel>> roomsStream(
      {required String id, required bool isClient, required String chatType}) {
    return firestore
        .collection('ChatRooms')
        .doc(chatType)
        .collection("Chat")
        .snapshots()
        .map((event) {
      List<ChatRoomModel> _list = [];

      List<ChatRoomModel> rooms =
          event.docs.map((e) => ChatRoomModel.fromJson(e.data())).toList();
      print(rooms.length);
      for (var element in rooms) {
        print("petOwnerId: ${element.petOwnerId}");
        print("petCareUserId: ${element.petCareUserId}");
        if (element.petOwnerId == FirebaseAuth.instance.currentUser!.uid) {
          _list.add(element);
        } else if (element.petCareUserId == FirebaseAuth.instance.currentUser!.uid) {
          print("_list.length_2");
          _list.add(element);
        }
      }

      _list
          .sort((a, b) => a.message!.dateTime!.compareTo(b.message!.dateTime!));
      print(_list.length);
      return _list.reversed.toList();
    });
  }
}
