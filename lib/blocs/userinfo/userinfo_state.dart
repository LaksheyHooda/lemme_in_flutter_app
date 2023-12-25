part of 'userinfo_bloc.dart';

abstract class UserinfoState extends Equatable {}

class UserinfoInitial extends UserinfoState {
  @override
  List<Object> get props => [];
}

class UserinfoLoading extends UserinfoState {
  @override
  List<Object> get props => [];
}

class UserinfoUpdatedSuccessfully extends UserinfoState {
  final String successMsg;

  UserinfoUpdatedSuccessfully(this.successMsg);

  @override
  List<Object> get props => [successMsg];
}

class UserinfoLoaded extends UserinfoState {
  final UserInfo userInfo;

  UserinfoLoaded(this.userInfo);

  @override
  List<Object> get props => [userInfo];
}

class UserinfoError extends UserinfoState {
  final String errorMsg;

  UserinfoError(this.errorMsg);

  @override
  List<Object> get props => [errorMsg];
}
