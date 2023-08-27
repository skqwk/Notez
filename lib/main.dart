import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notez/injection_container.dart';
import 'package:notez/presentation/bloc/profile_bloc.dart';
import 'package:notez/presentation/bloc/vault/vault_bloc.dart';
import 'package:notez/presentation/page/login_page.dart';
import 'package:notez/presentation/page/main_page.dart';
import 'package:notez/presentation/page/note_page.dart';

import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ProfileBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<VaultBloc>(),
        ),
      ],
      child: MaterialApp(
        initialRoute: LoginPage.route,
        routes: {
          LoginPage.route: (context) => LoginPage(),
          MainPage.route: (context) => MainPage(),
          NotePage.route: (context) => NotePage(),
        },
      ),
    );
  }
}
