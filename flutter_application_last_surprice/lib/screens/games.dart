import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_last_surprice/helpers/database_helper_ps4.dart';
import 'package:flutter_application_last_surprice/models/ps4_model.dart';
import 'package:flutter_application_last_surprice/screens/carts.dart';
import 'package:flutter_application_last_surprice/screens/taken_picture_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_last_surprice/helpers/database_helper.dart';
import 'package:flutter_application_last_surprice/widgets/custom_item_widget.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:firebase_database/firebase_database.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../helpers/database_helper.dart';
import '../models/cat_model.dart';
import '../models/notas.dart';

class GamesSet extends StatefulWidget {
  final String? imagePath;

  final CameraDescription camera;

  const GamesSet({Key? key, this.imagePath, required this.camera})
      : super(key: key);

  @override
  State<GamesSet> createState() => _GamesSetState();
}

class _GamesSetState extends State<GamesSet> {
  final textControlPrice = TextEditingController();
  final textControllerName = TextEditingController();
  final textControllerConsole = TextEditingController();
  final textControllerGenero = TextEditingController();

  int? catID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PS4 Games"),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            Text("Games in the shop"),
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
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 50, 0, 50),
                                            child: Container(
                                              child:
                                                  Image.file(File(ps4.fotos)),
                                              height: 200,
                                              width: 200,
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 0, 0),
                                                child: Text(
                                                  'Name: ${ps4.name}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 0, 0),
                                                child: Text(
                                                  'Price: ${ps4.price}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 0, 0),
                                                child: Text(
                                                  'Console: ${ps4.console}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 0, 0),
                                                child: Text(
                                                  'Genero: ${ps4.genero}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyText1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => CartWidget(
                                                    camera: widget.camera,
                                                  )));
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
    );
  }
}
