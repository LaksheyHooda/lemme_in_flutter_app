import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:lemme_in_profofconc/models/user_info_model.dart';
import 'package:lemme_in_profofconc/repositories/auth_repository.dart';
import 'package:lemme_in_profofconc/repositories/database_repository.dart';

part 'userinfo_event.dart';
part 'userinfo_state.dart';

class UserinfoBloc extends Bloc<UserinfoEvent, UserinfoState> {
  final DatabaseRepository _databaseRepository;
  StreamSubscription<DocumentSnapshot<UserInfo>>? _userInfoStream;

  UserinfoBloc(this._databaseRepository) : super(UserinfoInitial()) {
    on<LoadUserinfo>((event, emit) async {
      _userInfoStream =
          _databaseRepository.getUserCurrentInfo(event.userId).listen((event) {
        add(UserinfoChanged(event.data() ?? UserInfo.empty));
      });

      emit(UserinfoLoading());
    });

    on<UpdateUserInfo>((event, emit) async {
      try {
        await _databaseRepository.updateUserinfo(event.updatedUserInfo);
        emit(UserinfoUpdatedSuccessfully("User info updated Success!"));
        emit(UserinfoLoaded(event.updatedUserInfo));
      } catch (e) {
        emit(UserinfoError("Failed to update user info"));
      }
    });

    on<UserinfoChanged>((event, emit) {
      emit(UserinfoLoading());
      if (event.userInfo.isNotEmpty) {
        emit(UserinfoLoaded(event.userInfo));
      } else {
        emit(UserinfoError("Failed to load user info"));
      }
    });

    on<UserLoggedOut>(((event, emit) {
      _userInfoStream?.cancel();
      emit(UserinfoInitial());
    }));
  }
}
