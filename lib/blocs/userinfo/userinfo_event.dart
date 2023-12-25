part of 'userinfo_bloc.dart';

abstract class UserinfoEvent extends Equatable {
  const UserinfoEvent();

  @override
  List<Object> get props => [];
}

class LoadUserinfo extends UserinfoEvent {
  final String userId;

  const LoadUserinfo(this.userId);

  @override
  List<Object> get props => [userId];
}

class UserinfoChanged extends UserinfoEvent {
  final UserInfo userInfo;

  const UserinfoChanged(this.userInfo);

  @override
  List<Object> get props => [userInfo];
}

class UpdateUserInfo extends UserinfoEvent {
  final UserInfo updatedUserInfo;

  const UpdateUserInfo(this.updatedUserInfo);

  @override
  List<Object> get props => [updatedUserInfo];
}

class UserLoggedOut extends UserinfoEvent {}
