import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lemme_in_profofconc/blocs/userinfo/userinfo_bloc.dart';
import 'package:lemme_in_profofconc/models/user_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MainScreen extends StatelessWidget {
  final User user;

  const MainScreen({super.key, required this.user});

  Widget userInfoDetails(BuildContext context, UserinfoState state) {
    if (state is UserinfoInitial) {
      return const CircularProgressIndicator();
    } else if (state is UserinfoLoaded) {
      return Text(state.userInfo.affiliation ?? "DNE");
    } else {
      return const Text("Failed to retrieve?");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserinfoBloc, UserinfoState>(
      builder: (context, state) {
        return Align(
          alignment: const Alignment(0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QrImageView(
                data: user.id,
                version: QrVersions.auto,
                size: 200.0,
              ),
              userInfoDetails(context, state),
              CircleAvatar(
                radius: 48,
                backgroundImage:
                    user.photo != null ? NetworkImage(user.photo!) : null,
                child: user.photo == null
                    ? const Icon(Icons.person_outline, size: 48)
                    : null,
              ),
              const SizedBox(height: 4),
              Text(user.email ?? '', style: const TextStyle(fontSize: 24)),
            ],
          ),
        );
      },
    );
  }
}
