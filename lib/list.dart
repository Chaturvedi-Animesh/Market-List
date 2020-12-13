import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyList extends StatefulWidget {
  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  final tasttest= TextEditingController();
  var dbref=FirebaseDatabase().reference().child("tasks");

  void addclick(){
    String tx=tasttest.text;
    tasttest.clear();
    dbref.push().set({
      "task":tx,
      "status":false
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 250,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextField(
                  onSubmitted: (t)=>addclick(),
                  controller: tasttest,
                  decoration: InputDecoration(
                    hintText: "Enter new item",
                  ),
                ),
              ),
              Container(
                color: Colors.red[500],
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed:addclick,
                ),
              )
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: StreamBuilder<Event>(
                  stream: dbref.onValue,
                  builder: (context, snapshot) {
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData && !snapshot.hasError && snapshot.data.snapshot.value != null){
                      List item=[];
                      Map map=snapshot.data.snapshot.value;
                      map.forEach((key, value) {item.add({'key':key,'value':value});});
                      return new ListView.builder(
                        itemCount: item.length,
                        itemBuilder: (BuildContext ctxt,int index){
                          return Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child:Text(
                                      item[index]['value']['task'].toString(),
                                      style:TextStyle(
                                          fontSize: 18,
                                          decoration: item[index]['value']['status']?TextDecoration.lineThrough:TextDecoration.none
                                      ) ,
                                    )
                                ),
                                RawMaterialButton(
                                    shape: CircleBorder(),
                                    fillColor: Colors.red[500],
                                    child: Icon(Icons.clear),
                                    onPressed:()=>dbref.child(item[index]['key']).remove()
                                ),
                                RawMaterialButton(
                                    shape: CircleBorder(),
                                    fillColor: Colors.green[500],
                                    child: Icon(Icons.check),
                                    onPressed:()=>dbref.child(item[index]['key']).update({'status':true})
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }else{
                      var l=snapshot.connectionState;
                      return Center(child: Text("Nothing $l"));
                    }}
              ),
            ),
          ),
        ],
      ),
    );
  }
}
