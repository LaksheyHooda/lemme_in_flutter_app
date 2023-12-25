import "package:cloud_firestore/cloud_firestore.dart";
import "package:equatable/equatable.dart";
import "package:flutter/material.dart";

class UserInfo extends Equatable {
  const UserInfo(
      {required this.id,
      this.firstName,
      this.lastName,
      this.verified,
      this.affiliation,
      this.gender,
      this.age,
      this.email,
      this.role});

  final String id;
  final String? firstName;
  final String? lastName;
  final bool? verified;
  final String? affiliation;
  final String? email;
  final String? gender;
  final int? age;
  final String? role;

  static const empty = UserInfo(id: '');

  bool get isEmpty => this == UserInfo.empty;
  bool get isNotEmpty => this != UserInfo.empty;

  factory UserInfo.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserInfo(
        id: data?['id'],
        firstName: data?['first_name'],
        lastName: data?['last_name'],
        verified: data?['verified'],
        affiliation: data?['affiliation'],
        email: data?['email'],
        gender: data?['gender'],
        age: data?['age'],
        role: data?['role']);
  }

  Map toJson() => {
        'id': id,
        'name': "$firstName $lastName",
        'verified': verified,
        'affiliation': affiliation,
        'gender': gender,
        'age': age,
      };

  Map<String, dynamic> toFirestore() {
    return {
      if (id != '') "id": id,
      if (firstName != null) "first_name": firstName,
      if (lastName != null) "last_name": lastName,
      if (verified != null) "verified": verified,
      if (affiliation != null) "affiliation": affiliation,
      if (email != null) "email": email,
      if (gender != null) "gender": gender,
      if (age != null) "age": age,
      if (role != null) "role": role
    };
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        verified,
        affiliation,
        email,
        gender,
        age,
        role
      ];
}
