import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liste_de_course/customWidgets/ListTileCustom.dart';

class MainPage extends StatelessWidget {
  final _tfController = TextEditingController();

  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection("ListeCourse").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return LinearProgressIndicator();
          else
            return Scaffold(
                appBar: AppBar(
                  title: Text("Liste de course"),
                ),
                body: Column(
                  children: <Widget>[
                    TextField(
                      controller: _tfController,
                      decoration: InputDecoration(
                        hintText: "produit",
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blueAccent, width: 4),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onSubmitted: (text) {
                        _tfController.clear();
                        Firestore.instance
                            .collection("ListeCourse")
                            .document(DateTime.now().toString())
                            .setData({"produit": text});
                      },
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            Key key = UniqueKey();
                            return Dismissible(
                              background: Container(color: Colors.red,),
                                key: key,
                                onDismissed: (direction) => Firestore.instance
                                    .collection("ListeCourse")
                                    .getDocuments()
                                    .then((snapshot) => snapshot
                                        .documents[index].reference
                                        .delete()),
                                child: ListTileCustom(snapshot
                                    .data.documents[index].data["produit"]));
                          }),
                    )
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                    child: Icon(Icons.delete),
                    onPressed: () {
                      displayDialog(context);
                    }));
        });
  }

  void displayDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text("Attention vous allez supprimer la liste!"),
              actions: <Widget>[
                CupertinoDialogAction(
                    child: Text("supprimer"),
                    onPressed: () {
                      Firestore.instance
                          .collection("ListeCourse")
                          .getDocuments()
                          .then((snapshot) {
                        for (DocumentSnapshot ds in snapshot.documents) {
                          ds.reference.delete();
                        }
                        Navigator.of(context).pop();
                      });
                    }),
                CupertinoDialogAction(
                  child: Text("annuler"),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ));
  }
}
