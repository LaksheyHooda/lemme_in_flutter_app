import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lemme_in_profofconc/models/user_info_model.dart'
    as UserInfoModel;
import 'package:lemme_in_profofconc/repositories/auth_repository.dart';
import 'package:lemme_in_profofconc/repositories/database_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;
  final DatabaseRepository _databaseRepository;

  SignupCubit(this._authRepository, this._databaseRepository)
      : super(SignupState.initial());

  void emailChanged(String value) {
    emit(
      state.copyWith(
        email: value,
        status: SignupStatus.initial,
      ),
    );
  }

  void passwordChanged(String value) {
    emit(
      state.copyWith(
        password: value,
        status: SignupStatus.initial,
      ),
    );
  }

  void firstNameChanged(String value) {
    emit(
      state.copyWith(
        firstName: value,
        status: SignupStatus.initial,
      ),
    );
  }

  void lastNameChanged(String value) {
    emit(
      state.copyWith(
        lastName: value,
        status: SignupStatus.initial,
      ),
    );
  }

  Future<void> signupFormSubmitted() async {
    if (state.status == SignupStatus.submitting) return;
    emit(state.copyWith(status: SignupStatus.submitting));
    try {
      bool success = await _authRepository.signup(
          email: state.email,
          password: state.password,
          firstName: state.firstName,
          lastName: state.lastName);
      if (success) {
        UserInfoModel.UserInfo userInfo = UserInfoModel.UserInfo(
            id: _authRepository.currentUser.id,
            firstName: state.firstName,
            lastName: state.lastName,
            verified: _authRepository.currentUser.verified,
            affiliation: "pkt",
            email: state.email,
            gender: "male",
            age: 69,
            role: "User");
        bool saveSuccess = await _databaseRepository.initUserSignup(userInfo);
        if (saveSuccess) {
          emit(state.copyWith(status: SignupStatus.success));
          print("sucessfully updated user info");
        } else {
          print("failed updated user info");
          emit(state.copyWith(status: SignupStatus.initial));
        }
      } else {
        emit(state.copyWith(status: SignupStatus.initial));
      }
    } catch (_) {}
  }
}
