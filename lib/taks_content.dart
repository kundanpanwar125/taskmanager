import 'package:assignment/Home_page.dart';
import 'package:assignment/Task_adder.dart';
import 'package:assignment/database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class task_content extends StatefulWidget {

  final String id;

  const task_content({super.key,required this.id});

  @override
  State<task_content> createState() => _task_contentState();
}

class _task_contentState extends State<task_content> {
  late  Map<String, dynamic> data={};


  // fetching the task data from firebase which going to display on page

  Future<void> fetch_task()async{
    final db=FirebaseFirestore.instance;
    DocumentSnapshot query = await db.collection("task_collection").doc(widget.id).get();
    Map<String, dynamic> taskData = query.data() as Map<String, dynamic>;
    setState(() {
      data=taskData;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch_task();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task manager "),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      backgroundColor: Colors.blue,
      body: Center(

        // wrap all the elements

        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 2,
                blurRadius: 2,
              )
            ],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              // heding of the screen
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black))),
                  child: Row(
                    children: [

                      // heading icon
                      const Expanded(
                          flex: 1,
                          child: Image(
                            image: AssetImage("Assets/images/task.png"),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          )),

                      // heading title
                      Expanded(
                        flex: 3,
                        child: Container(
                          //  alignment: Alignment.center,
                          margin: const EdgeInsets.only(left: 30),
                          child: Text(
                            data.isNotEmpty? data["title"]:" fetching ...",
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              // task description ---

              Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    child: Container(
                      alignment: Alignment.topLeft,

                      child: Text(
                        data.isNotEmpty? data["desc"]:" fetching ...",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  )),


              // edit and delete button

              Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.black))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        // edit button
                        custom_btn(text:"Edit",callback: (){
                           Navigator.push(context, MaterialPageRoute(builder: (context)=>task_adder_and_editor(edit: true,id:widget.id)));
                        },icon: Icons.edit,icon_color: Colors.blue,),

                        // delete button
                        custom_btn(text:"Delete",callback: (){
                             task t = task();
                             t.deleted_task(widget.id);
                             Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const home_page()));

                        },icon: Icons.delete,icon_color: Colors.red,),

                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
 // custom btn design
class custom_btn extends StatelessWidget {
  final String text;
  final Function callback;
  final IconData icon;
  final Color icon_color;
  const custom_btn({super.key,required this.text,required this.callback,required this.icon,this.icon_color=Colors.black});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed:(){
       return callback();
    }, child: Row(
       children: [
         Icon(icon,color:icon_color),
         const SizedBox(
           width: 10,
         ),
         Text(text,style: const TextStyle(color: Colors.black,fontSize: 20),),
       ],
    ));
  }
}
