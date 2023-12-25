part of 'signup_cubit.dart';

enum SignupStatus { initial, submitting, success, error }

class SignupState extends Equatable {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final SignupStatus status;

  const SignupState({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.status,
  });

  factory SignupState.initial() {
    return const SignupState(
      email: '',
      password: '',
      firstName: '',
      lastName: '',
      status: SignupStatus.initial,
    );
  }

  SignupState copyWith({
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    SignupStatus? status,
  }) {
    return SignupState(
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [email, firstName, lastName, password, status];
}
