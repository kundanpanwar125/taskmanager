import 'package:cloud_firestore/cloud_firestore.dart';

class task {
  final db=FirebaseFirestore.instance;

  void add_task(value)async{
    await db.collection("task_collection").add(value);
  }

  void deleted_task(String id){
    db.collection("task_collection").doc(id).delete();
  }

  void update_task(String id,value){
    db.collection("task_collection").doc(id).update(value);
  }

}

// this file is contain the function which perform operation on databse

