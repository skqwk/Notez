import 'package:flutter/material.dart';
import 'package:notez/domain/note.dart';
import 'package:notez/domain/paragraph.dart';

class NoteArgs {
  final Note note;

  NoteArgs(this.note);
}

class NotePage extends StatelessWidget {
  static const route = '/note';

  const NotePage({super.key});

  @override
  Widget build(BuildContext context) {
    final NoteArgs args =
        ModalRoute.of(context)!.settings.arguments as NoteArgs;

    final Note note = args.note;

    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              for (Paragraph paragraph in note.paragraphs)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: TextEditingController(text: paragraph.content),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}
