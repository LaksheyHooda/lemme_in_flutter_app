import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:lemme_in_profofconc/blocs/userinfo/userinfo_bloc.dart';
import 'package:lemme_in_profofconc/firebase_options.dart';
import 'package:lemme_in_profofconc/repositories/database_repository.dart';

import 'package:lemme_in_profofconc/screens/screens.dart';

import '/repositories/repositories.dart';
import '/bloc_observer.dart';
import '/blocs/blocs.dart';
import 'config/app_router.dart';

Future<void> main() {
  return BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      Repositories repositories = Repositories();

      runApp(App(repositories: repositories));
    },
    blocObserver: AppBlocObserver(),
  );
}

class App extends StatelessWidget {
  const App({
    Key? key,
    required Repositories repositories,
  })  : _repositories = repositories,
        super(key: key);

  final Repositories _repositories;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
        value: _repositories,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AppBloc>(
                create: (_) => AppBloc(
                      authRepository: _repositories.authRepository,
                    )),
            BlocProvider<UserinfoBloc>(
                create: (_) => UserinfoBloc(_repositories.databaseRepository)),
          ],
          child: Builder(
            builder: (context) {
              return MaterialApp.router(
                title: "lemmein",
                routerConfig: AppRouter(context.read<AppBloc>()).router,
              );
            },
          ),
        ));
  }
}
