import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lemme_in_profofconc/blocs/app/app_bloc.dart';
import 'package:lemme_in_profofconc/blocs/userinfo/userinfo_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/user_info_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget userInfoDetails(BuildContext context, UserinfoState state) {
    if (state is UserinfoInitial) {
      return const CircularProgressIndicator();
    } else if (state is UserinfoLoaded) {
      return Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(state.userInfo.affiliation ?? "DNE"),
              const SizedBox(width: 50),
              ElevatedButton(
                  onPressed: () {
                    _showAddTodoDialog(context, state);
                  },
                  child: const Icon(Icons.edit))
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          QrImageView(
            data: jsonEncode(state.userInfo),
            version: QrVersions.auto,
            errorCorrectionLevel: QrErrorCorrectLevel.L,
            size: 200.0,
          ),
          const SizedBox(
            height: 25,
          ),
          ElevatedButton(
              onPressed: () =>
                  context.read<AppBloc>().add(AppLogoutRequested()),
              child: const Text(
                "log out",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    decoration: TextDecoration.underline),
              ))
        ],
      );
    } else {
      return const Text("Failed to retrieve?");
    }
  }

  void _showAddTodoDialog(BuildContext context, UserinfoState state) {
    final _affiliationController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Affiliation'),
          content: TextField(
            controller: _affiliationController,
            decoration: const InputDecoration(hintText: 'Affiliation'),
          ),
          actions: [
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text('Update'),
              onPressed: () {
                if (state is UserinfoLoaded &&
                    _affiliationController.text.isNotEmpty) {
                  final updatedUserinfo = UserInfo(
                    id: state.userInfo.id,
                    firstName: state.userInfo.firstName,
                    lastName: state.userInfo.lastName,
                    verified: state.userInfo.verified,
                    affiliation: _affiliationController.text,
                    gender: state.userInfo.gender,
                    age: state.userInfo.age,
                    email: state.userInfo.email,
                    role: state.userInfo.role,
                  );
                  BlocProvider.of<UserinfoBloc>(context)
                      .add(UpdateUserInfo(updatedUserinfo));
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserinfoBloc, UserinfoState>(
      listener: (context, state) {
        if (state is UserinfoUpdatedSuccessfully) {
          final snackBar = SnackBar(
            content: Text(state.successMsg),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: BlocBuilder<UserinfoBloc, UserinfoState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                userInfoDetails(context, state),
              ],
            ),
          );
        },
      ),
    );
  }
}
