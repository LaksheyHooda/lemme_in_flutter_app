import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lemme_in_profofconc/models/user_info_model.dart';

class DatabaseRepository {
  final db = FirebaseFirestore.instance;
  var currentUserInfo = UserInfo.empty;

  Future<bool> initUserSignup(UserInfo userInfo) async {
    final docRef = db
        .collection("users")
        .withConverter(
          fromFirestore: UserInfo.fromFirestore,
          toFirestore: (UserInfo userInfo, options) => userInfo.toFirestore(),
        )
        .doc(userInfo.id);
    try {
      await docRef.set(userInfo);
      return true;
    } catch (_) {
      return false;
    }
  }

  Stream<DocumentSnapshot<UserInfo>> getUserCurrentInfo(String userId) {
    final docRef = db.collection("users").doc(userId).withConverter(
          fromFirestore: UserInfo.fromFirestore,
          toFirestore: (UserInfo userInfo, _) => userInfo.toFirestore(),
        );
    return docRef.snapshots();
  }

  Future<void> updateUserinfo(UserInfo updatedInfo) async {
    final docRef = db.collection("users").doc(updatedInfo.id).withConverter(
          fromFirestore: UserInfo.fromFirestore,
          toFirestore: (UserInfo userInfo, _) => userInfo.toFirestore(),
        );
    await docRef.update(updatedInfo.toFirestore());
  }
}
