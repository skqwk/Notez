import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notez/injection_container.dart';
import 'package:notez/presentation/bloc/profile_bloc.dart';
import 'package:notez/presentation/widget/message_display.dart';

class LoginPage extends StatelessWidget {
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

  BlocProvider<ProfileBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
                if (state is LoadingProfile) {
                  // TODO: 21.08.23 вынести сообщения в конфигурацию
                  return const MessageDisplay(message: 'Загрузка профиля');
                } else if (state is LoadedProfile) {
                  return MessageDisplay(message: 'Профиль: ${state.profile.username}');
                } else if (state is ProfileNotFound) {
                  return const MessageDisplay(message: 'Профиль не найден');
                }

                return Container();
              }),
              const SizedBox(
                height: 20,
              ),
              const LoginControls(),
            ],
          ),
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
              border: OutlineInputBorder(), hintText: 'Input a number'),
          onChanged: (value) {
            inputStr = value;
          },
        ),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              onPressed: dispatchCreateProfile,
              child: const Text("Create"),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              onPressed: dispatchLoginProfile,
              child: const Text("Login"),
            ),
          )
        ])
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
