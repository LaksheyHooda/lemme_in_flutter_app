import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lemme_in_profofconc/blocs/userinfo/userinfo_bloc.dart';
import 'package:lemme_in_profofconc/models/models.dart';
import 'package:lemme_in_profofconc/models/user_info_model.dart';
import 'package:lemme_in_profofconc/screens/home_screen_home.dart';
import 'package:lemme_in_profofconc/screens/home_screen_profile.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '/blocs/blocs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomeScreen());

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    String userId = BlocProvider.of<AppBloc>(context).state.user.id;
    BlocProvider.of<UserinfoBloc>(context).add(LoadUserinfo(userId));
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _currenScreenWidget(User user) {
    if (_selectedIndex == 0) {
      return MainScreen(user: user);
    } else if (_selectedIndex == 1) {
      return const ProfileScreen();
    } else {
      return const Text("error");
    }
  }

  List<BottomNavigationBarItem> _navBarItems(
      BuildContext context, UserinfoState state) {
    List<BottomNavigationBarItem> _barItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
    ];

    if (state is UserinfoLoaded) {
      if (state.userInfo.role == "scanner") {
        _barItems.add(const BottomNavigationBarItem(
            icon: Icon(Icons.camera), label: "scan"));
      }
    }

    return _barItems;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              context.read<AppBloc>().add(AppLogoutRequested());
              //context.read<UserinfoBloc>().add(UserLoggedOut());
            },
          )
        ],
      ),
      body: _currenScreenWidget(user),
      bottomNavigationBar: BlocBuilder<UserinfoBloc, UserinfoState>(
        builder: (context, state) {
          return BottomNavigationBar(
            currentIndex: _selectedIndex,
            elevation: 18,
            type: BottomNavigationBarType.fixed,
            //showSelectedLabels: false,
            iconSize: 35,
            backgroundColor: Colors.white,
            //showUnselectedLabels: false,
            selectedItemColor: Colors.deepPurple,
            items: _navBarItems(context, state),
            onTap: _onItemTapped,
          );
        },
      ),
    );
  }
}
