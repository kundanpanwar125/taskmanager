import 'package:assignment/Home_page.dart';
import 'package:assignment/database.dart';
import 'package:flutter/material.dart';
import 'package:date_input_form_field/date_input_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class task_adder_and_editor extends StatelessWidget {
  final String id;
  final bool edit;
  final GlobalKey<FormState> _form=GlobalKey();
  task_adder_and_editor({super.key,this.edit=false,this.id=""}){
      if(edit){
          fetch_task();
      }
  }


  var title = TextEditingController();
  var date =TextEditingController();
  var desc=TextEditingController();

  final task T=task();

  Future<void> fetch_task()async{
    final db=FirebaseFirestore.instance;
    DocumentSnapshot query = await db.collection("task_collection").doc(id).get();
    Map<String, dynamic> taskData = query.data() as Map<String, dynamic>;
    title.text=taskData["title"];
    desc.text= taskData["desc"];
    String d=taskData["date"];
    if(d!="no limit"){
        date.text=taskData["date"];
    }

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
        child: SingleChildScrollView(

          // Container to wrap all elements
          child: Container(
            margin: const EdgeInsets.all(5),
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

                    // heading of the page
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

                        // heading text
                        Expanded(
                          flex: 3,
                          child: Container(
                            //  alignment: Alignment.center,
                            margin: const EdgeInsets.only(left: 30),
                            child: Text(
                              edit? "Edit Task": "Add New Task",
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                // taking input from the user
                Expanded(flex: 5,child: Form(
                    key: _form,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(

                      children: [

                        // task title
                         Expanded(
                           flex: 1,
                           child: ListTile(
                             leading: const Text("Title",style: TextStyle(fontSize: 20),),
                             title: TextFormField(
                               controller: title,
                                 decoration: InputDecoration(
                                   hintText: "Task name ",
                                    border: OutlineInputBorder(
                                       borderRadius: BorderRadius.circular(10),
                                    )
                                 ),
                               validator: (value){
                                     if(value==null || value.isEmpty){
                                         return "enter the value";
                                     }
                                     return null;
                               },
                             ),
                           ),
                         ),
                        const SizedBox(height: 20,),

                        // task submission date

                        Expanded(
                          flex: 1,
                          child: ListTile(
                            leading: const Text("End Date",style: TextStyle(fontSize: 20),),
                            title: DateInputFormField(
                              controller: date,
                              autovalidateMode: AutovalidateMode.always,
                              decoration: InputDecoration(
                                  hintText: "yyyy-mm-dd",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )
                              ),
                            )
                          ),
                        ),
                        const SizedBox(height: 20,),

                        // Task description content
                        const Text("Description",style: TextStyle(fontSize: 20),),
                      //  SizedBox(height: 20,),
                        Expanded(
                          flex: 3,
                          child: Container(
                             margin: const EdgeInsets.all(15),
                             height: 100,
                             child: TextFormField(
                               controller: desc,
                               maxLines: 100,
                               keyboardType: TextInputType.multiline,
                               decoration: InputDecoration(
                                   border: OutlineInputBorder(
                                     borderRadius: BorderRadius.circular(10),
                                   )
                               ),
                               validator: (value){
                                 if(value==null || value.isEmpty){
                                   return "enter the value";
                                 }
                                 return null;
                               },
                             ),
                          )
                        ),


                        // final action button
                        // singe button is used for as edit or adding of task
                        ElevatedButton(
                           onPressed: (){
                               if(_form.currentState!.validate()){
                                 String  d= date.text.isEmpty? "no limit":date.text;
                                 if(edit){
                                     // update data
                                     T.update_task(id,{
                                       "title":title.text,
                                       "desc":desc.text,
                                       "date":d
                                     });
                                 }
                                 else{
                                      T.add_task({
                                          "title":title.text,
                                          "desc":desc.text,
                                          "date":d
                                      });
                                     // add data
                                 }
                                 Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const home_page()));
                               }
                           },
                          child: Text( edit?"Submit":"Add",style: const TextStyle(
                             fontSize: 20,
                             fontWeight: FontWeight.bold
                          ),
                          ),
                        )

                      ],
                )),
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }
}
