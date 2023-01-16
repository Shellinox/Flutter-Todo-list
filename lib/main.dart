import 'package:flutter/material.dart';
import 'package:todolist/data/database.dart';
import 'package:todolist/util/dialog_box.dart';
import 'package:todolist/util/todo_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';


 void main() async {
  await Hive.initFlutter();
  var box=await Hive.openBox('mybox');
  runApp(const ToDoList());
}

class ToDoList extends StatelessWidget {
  const ToDoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow
      ),
      title: 'ToDo List',
      home: const Homepage(),
    );
  }
}
class Homepage extends StatefulWidget {

  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
   final _myBox=Hive.box('mybox');
   ToDoDatabase db=ToDoDatabase();
   @override
  void initState() {
     if(_myBox.get("TODOLIST")==null){
       db.createInitialData();
     }
     else{
       db.loadData();
     }
    super.initState();
  }
  final _controller=TextEditingController();

  void checkBoxChanged( int index,bool? value){
    setState(() {
      db.toDoList[index][1]=!db.toDoList[index][1];
    });
    db.updateDataBase();
  }
  void createNewTask(){
    showDialog(context: context, builder: (context){
      return DialogBox(controller: _controller, onSave: saveNewTask, onCancel:()=>Navigator.of(context).pop());
    });
  }
  void saveNewTask(){
    setState(() {
      db.toDoList.add([_controller.text,false]);
      _controller.clear();
      Navigator.of(context).pop();
      db.updateDataBase();
    });
  }
  void deleteTask(int index){
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade200,
      appBar: AppBar(
        title: const Center(child:Text('Todo List')),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
          itemBuilder: (context,index){
          return TodoTile(
              taskName: db.toDoList[index][0],
              taskCompleted: db.toDoList[index][1],
              onChanged:(value)=> checkBoxChanged(index,value),
              deleteFunction: (context)=>deleteTask(index),
          );
          }
      )
      );
  }
}

