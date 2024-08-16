import 'package:assignment/taks_content.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Task_adder.dart';

class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  List Task_id=[];   // contain all task
  List Task_list=[];  // contain task id


  // fetchingk the task data to be going to display on listview

  Future<void> fetch_task()async{
    final db=FirebaseFirestore.instance;
    List tmp=[];
    List tmp_id=[];

    QuerySnapshot query = await db.collection("task_collection").get();

    for (var doc in query.docs) {
      tmp.add(doc.data() as Map );  // Add document data to list
      tmp_id.add(doc.id);                               // Add document ID to list
    }

    setState(() {
      Task_id=tmp_id;
      Task_list=tmp;
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

      // Container to wrap all the elements
      body: Container(
        color: Colors.blue,
        child: Column(
          children: [
            Expanded(
                flex: 2,

                // top section to add new taks in list
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,

                        //  images near add button
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "Assets/images/notebook.png"))),
                        )),


                    // Add task button
                    Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 4,
                                  child: Container(
                                    // alignment: Alignment.center,
                                    margin: const EdgeInsets.only(bottom: 15),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>task_adder_and_editor()));
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                        size: 70,
                                      ),
                                    ),
                                  )),
                              const Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Add Task",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                        )),
                  ],
                )),

            // Task list :-

            Expanded(
                flex: 6,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50)),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width * 0.9,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(50),
                                  topLeft: Radius.circular(50)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 2,
                                    blurRadius: 5)
                              ]),
                          child: const Text(
                            "Task list",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          color: Colors.white,
                          child: Task_list.isNotEmpty? ListView.builder(
                              itemCount: Task_list.length,
                              itemBuilder: (context, index) {
                                return task_block(
                                  title:Task_list[index]["title"],
                                  edate: Task_list[index]["date"],
                                  id:Task_id[index],
                                );
                              }):Container(
                              margin: const EdgeInsets.only(top: 30),
                              child: const Text("No Task ",style: TextStyle(fontSize: 20),)),
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class task_block extends StatelessWidget {
  final String title;
  final String edate;
  final String id;

  const task_block({required this.title, required this.edate, super.key,required this.id});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>task_content(id:id)));
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 2,
              blurRadius: 5,
            )
          ],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), bottomLeft: Radius.circular(40)),
        ),
        child: ListTile(
          leading: const CircleAvatar(
            maxRadius: 30,
            backgroundColor: Colors.white,
            child: Image(
              image: AssetImage("Assets/images/reminder_icon.png"),
              fit: BoxFit.cover ,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              //  fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            "End date: ($edate) ",
            style: const TextStyle(fontSize: 12),
          ),
          trailing: const CircleAvatar(
            child: Image(
              image: AssetImage("Assets/images/clock.png"),
              fit: BoxFit.cover,
            ),
            backgroundColor: Colors.white,
            maxRadius: 25,
          ),
        ),
      ),
    );
  }
}
