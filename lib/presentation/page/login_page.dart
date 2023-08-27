import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notez/presentation/bloc/profile_bloc.dart';
import 'package:notez/presentation/page/main_page.dart';
import 'package:notez/presentation/widget/message_display.dart';

class LoginPage extends StatelessWidget {
  static const route = '/login';

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zettedele'),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            BlocListener<ProfileBloc, ProfileState>(
              listener: (BuildContext context, ProfileState state) {
                if (state is LoadedProfile) {
                  Navigator.of(context).pushNamed(MainPage.route);
                }
              },
              child: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                if (state is LoadingProfile) {
                  // TODO: 21.08.23 вынести сообщения в конфигурацию
                  return const MessageDisplay(message: 'Загрузка профиля');
                } else if (state is LoadedProfile) {
                  return MessageDisplay(
                      message: 'Профиль: ${state.profile.username}');
                } else if (state is ProfileError) {
                  return MessageDisplay(message: state.message);
                }

                return Container();
              }),
            ),
            const SizedBox(
              height: 20,
            ),
            const LoginControls(),
          ],
        ),
      ),
    );
  }
}

class LoginControls extends StatefulWidget {
  const LoginControls({super.key});

  @override
  State<LoginControls> createState() => _LoginControlsState();
}

class _LoginControlsState extends State<LoginControls> {
  String inputStr = "";
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Введите название профиля',
          ),
          onChanged: (value) {
            inputStr = value;
          },
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(50.0),
            backgroundColor: Colors.green,
          ),
          onPressed: dispatchCreateProfile,
          child: const Text("Создать"),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(50.0),
            backgroundColor: Colors.green,
          ),
          onPressed: dispatchLoginProfile,
          child: const Text("Войти"),
        )
      ],
    );
  }

  void dispatchCreateProfile() {
    controller.clear();
    BlocProvider.of<ProfileBloc>(context).add(CreateProfileEvent(inputStr));
  }

  void dispatchLoginProfile() {
    controller.clear();
    BlocProvider.of<ProfileBloc>(context).add(LoginProfileEvent(inputStr));
  }
}
