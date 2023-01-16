import 'package:flutter/material.dart';
class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;

   DialogBox
       ({Key? key,
     required this.controller,
     required this.onSave,
     required this.onCancel
       }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      backgroundColor: Colors.yellow.shade200,
      content: SizedBox(
        height: 120,
        child: Column(children: [
          TextField(
            controller:controller ,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Add new task'
            ),
          ),
          const SizedBox(height: 13),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
            ElevatedButton(onPressed: onSave, child: Text("Save")),
            const SizedBox(width: 10),
            ElevatedButton(onPressed: onCancel, child: Text("Cancel")),
          ],)
        ],),
      ),
    );
  }
}
