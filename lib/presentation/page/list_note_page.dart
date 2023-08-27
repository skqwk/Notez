import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notez/domain/note.dart';
import 'package:notez/domain/vault.dart';
import 'package:notez/presentation/bloc/profile_bloc.dart';
import 'package:notez/presentation/bloc/vault/vault_bloc.dart';
import 'package:notez/presentation/page/note_page.dart';
import 'package:notez/presentation/widget/message_display.dart';

class ListNotePage extends StatefulWidget {
  static const route = '/list-note';

  const ListNotePage({super.key});

  @override
  State<ListNotePage> createState() => _ListNotePageState();
}

class _ListNotePageState extends State<ListNotePage> {
  @override
  void initState() {
    ProfileState profileState = BlocProvider.of<ProfileBloc>(context).state;
    if (profileState is LoadedProfile) {
      BlocProvider.of<VaultBloc>(context)
          .add(LoadVaultsEvent(profileState.profile.username));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<VaultBloc, VaultState>(
        builder: (context, state) {
          if (state is LoadingVaults) {
            // TODO: 26.08.23 вынести сообщения в конфигурацию
            return const MessageDisplay(message: 'Загрузка заметок');
          } else if (state is LoadedVaults) {
            List<Vault> vaults = state.vaults;
            List<Note> notes = vaults.isNotEmpty ? vaults[0].notes : [];
            return buildGridView(notes);
          }
          return buildGridView([]);
        },
      ),
    );
  }

  GridView buildGridView(List<Note> notes) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: notes.length,
        itemBuilder: (BuildContext ctx, index) {
          return InkWell(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(notes[index].title),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(
                NotePage.route,
                arguments: NoteArgs(notes[index]),
              );
            },
          );
        });
  }
}
