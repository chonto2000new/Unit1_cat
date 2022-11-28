import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_last_surprice/helpers/database_helper_ps4.dart';
import 'package:flutter_application_last_surprice/models/ps4_model.dart';
import 'package:flutter_application_last_surprice/screens/taken_picture_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_last_surprice/helpers/database_helper.dart';
import 'package:flutter_application_last_surprice/widgets/custom_item_widget.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:firebase_database/firebase_database.dart';

import '../helpers/database_helper.dart';
import '../models/cat_model.dart';
import '../models/notas.dart';

class HomeScreen extends StatefulWidget {
  final String? imagePath;
  final CameraDescription firstCamera;

  HomeScreen({Key? key, this.imagePath, required this.firstCamera})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final textControlPrice = TextEditingController();
  final textControllerName = TextEditingController();
  final textControllerConsole = TextEditingController();
  final textControllerGenero = TextEditingController();

  int? catID;
  int? psID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SQLite Database"),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            TextFormField(
              controller: textControlPrice,
              decoration: const InputDecoration(
                  icon: Icon(Icons.view_comfortable_outlined),
                  labelText: "input the price of the game"),
            ),
            TextFormField(
              controller: textControllerName,
              decoration: const InputDecoration(
                  icon: Icon(Icons.text_format_outlined),
                  labelText: "input the name of the game"),
            ),
            TextFormField(
              controller: textControllerConsole,
              decoration: const InputDecoration(
                  icon: Icon(Icons.text_format_outlined),
                  labelText: "input the console "),
            ),
            TextFormField(
              controller: textControllerGenero,
              decoration: const InputDecoration(
                  icon: Icon(Icons.text_format_outlined),
                  labelText: "input the genero "),
            ),
            ElevatedButton(
                onPressed: (() {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TakePictureScreen(
                            camera: widget.firstCamera,
                          )));
                }),
                child: Text('TAKEN PICTURE')),
            Center(
              child: (FutureBuilder<List<Cat>>(
                  future: DatabaseHelper.instance.getCats(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Cat>> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: const Text("Loading..."),
                        ),
                      );
                    } else {
                      return snapshot.data!.isEmpty
                          ? Center(
                              child: Container(
                                  child: const Text("No games in the list")))
                          : ListView(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              children: snapshot.data!.map((cat) {
                                return Center(
                                  child: GestureDetector(
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Image.file(File(cat.fotos)),
                                            height: 100,
                                            width: 100,
                                          ),
                                          Container(
                                            child: Text(
                                                'Name: ${cat.name} | price: ${cat.price}  | console: ${cat.console}| genero: ${cat.genero}'),
                                            width: 150,
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        textControllerName.text = cat.name;
                                        textControlPrice.text = cat.price;
                                        textControllerConsole.text =
                                            cat.console;
                                        textControllerGenero.text = cat.genero;

                                        catID = cat.id;
                                      });
                                    },
                                    onLongPress: () {
                                      DatabaseHelper.instance.delete(cat.id!);
                                      setState(() {});
                                    },
                                  ),
                                );
                              }).toList());
                    }
                  })),
            ),
            // la otra base de datos en mp3////////////////////////////////////////////////////////////////
            Center(
              child: (FutureBuilder<List<Ps4>>(
                  future: DatabaseHelperps4.instance.getPS4s(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Ps4>> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: const Text("Loading..."),
                        ),
                      );
                    } else {
                      return snapshot.data!.isEmpty
                          ? Center(
                              child: Container(
                                  child: const Text("No games in the list")))
                          : ListView(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              children: snapshot.data!.map((ps4) {
                                return Center(
                                  child: GestureDetector(
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Image.file(File(ps4.fotos)),
                                            height: 100,
                                            width: 100,
                                          ),
                                          Container(
                                            child: Text(
                                                'Name: ${ps4.name} | price: ${ps4.price}  | console: ${ps4.console}| genero: ${ps4.genero}'),
                                            width: 150,
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        textControllerName.text = ps4.name;
                                        textControlPrice.text = ps4.price;
                                        textControllerConsole.text =
                                            ps4.console;
                                        textControllerGenero.text = ps4.genero;

                                        psID = ps4.id;
                                      });
                                    },
                                    onLongPress: () {
                                      DatabaseHelper.instance.delete(ps4.id!);
                                      setState(() {});
                                    },
                                  ),
                                );
                              }).toList());
                    }
                  })),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () async {
          if (textControllerConsole != "consola ps4") {
            if (psID != null) {
              DatabaseHelper.instance.update(Cat(
                id: catID,
                price: textControlPrice.text,
                name: textControllerName.text,
                console: textControllerConsole.text,
                genero: textControllerGenero.text,
                fotos: widget.imagePath!,
              ));
            } else {
              DatabaseHelper.instance.add(Cat(
                price: textControlPrice.text,
                name: textControllerName.text,
                console: textControllerConsole.text,
                genero: textControllerGenero.text,
                fotos: widget.imagePath!,
              ));
            }
          }

          if (textControllerConsole.text == "ps4") {
            if (catID != null) {
              DatabaseHelperps4.instance.update(Ps4(
                id: psID,
                price: textControlPrice.text,
                name: textControllerName.text,
                console: textControllerConsole.text,
                genero: textControllerGenero.text,
                fotos: widget.imagePath!,
              ));
            } else {
              DatabaseHelperps4.instance.add(Ps4(
                price: textControlPrice.text,
                name: textControllerName.text,
                console: textControllerConsole.text,
                genero: textControllerGenero.text,
                fotos: widget.imagePath!,
              ));
            }
          }

          setState(() {
            textControlPrice.clear();
            textControllerName.clear();
            textControllerConsole.clear();
            textControllerGenero.clear();
          });
        },
      ),
    );
  }
}
