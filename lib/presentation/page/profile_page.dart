import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notez/common/log.dart';
import 'package:notez/presentation/bloc/profile_bloc.dart';
import 'package:notez/presentation/page/login_page.dart';
import 'package:notez/presentation/widget/message_display.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        BlocListener<ProfileBloc, ProfileState>(
          listener: (BuildContext context, ProfileState state) {
            if (state is ProfileInitial) {
              Navigator.of(context).pushNamed(LoginPage.route);
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
                return const MessageDisplay(message: 'Профиль не найден');
              }

              return Container();
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        ProfileControls()
      ],
    );
  }
}

class ProfileControls extends StatelessWidget {
  const ProfileControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
          ),
          onPressed: () => dispatchLogoutProfile(context),
          child: const Text("Выйти"),
        ),
      ),
    ]);
  }

  void dispatchLogoutProfile(BuildContext context) {
    log.info('Пользователь нажал на кнопку "Выйти"');
    BlocProvider.of<ProfileBloc>(context).add(LogoutProfileEvent());
  }
}
