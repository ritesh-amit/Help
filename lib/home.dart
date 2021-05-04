import 'dart:io';

import 'package:flutter/material.dart';
import 'package:help/speedDialStf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'Utils/SizeConfig.dart';
import 'package:path/path.dart' as pathpkg;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> dataList = [];
  String dirPath = "";

  Future<List<Map<String, dynamic>>> loadData() async {
    var databasePath = await getDatabasesPath();
    String path = pathpkg.join(databasePath, 'data.db');

    Database db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE person (id INTEGER PRIMARY KEY, name TEXT, phone TEXT, product TEXT, amount TEXT, paymentMethod TEXT, date TEXT)');
    });

    var dir = await getExternalStorageDirectory();
    dirPath = dir.path;

    var fileList = dir.list();
    dataList = await db.query('person');
    return dataList;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 400;
    var h = SizeConfig.screenHeight / 800;
    return Scaffold(
      floatingActionButton: Dial(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: Padding(
          padding: EdgeInsets.only(left: b * 10),
          child: Image.asset(
            'images/splash.png',
          ),
        ),
        centerTitle: true,
        title: Text(
          "Help Now",
          style: txtS(Colors.white, 20, FontWeight.w400),
        ),
      ),
      body: SafeArea(
        child: Container(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
              child: FutureBuilder(
                future: loadData(),
                builder: (context, snapshot) {
                  return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: dataList.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        if (dataList.isEmpty)
                          return Center(
                            child: Text(
                                "No Data Available, Click on Add to add Data"),
                          );
                        else
                          return Column(children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: b * 10, vertical: h * 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: b * 5),
                                  CircleAvatar(
                                    radius: b * 24,
                                    backgroundColor: Colors.green,
                                    backgroundImage: FileImage(
                                      File(dirPath + '/${index + 1}.png'),
                                    ),
                                  ),
                                  SizedBox(width: b * 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            dataList[index]['name'],
                                            style: txtS(Colors.black, 17,
                                                FontWeight.w500),
                                          ),
                                          SizedBox(width: b * 5),
                                        ],
                                      ),
                                      Text(
                                        dataList[index]['phone'],
                                        style: txtS(
                                            Colors.black, 14, FontWeight.w400),
                                      ),
                                      Text(
                                        dataList[index]['date'],
                                        style: txtS(
                                            Colors.black, 12, FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Text(
                                    "\u20B9 ${dataList[index]['amount']}",
                                    style:
                                        txtS(Colors.black, 16, FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.grey[300],
                              height: h * 0.5,
                            ),
                          ]);
                      });
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }

  TextStyle txtS(Color col, double siz, FontWeight wg) {
    return TextStyle(
      color: col,
      fontWeight: wg,
      fontSize: SizeConfig.screenWidth * siz / 414,
    );
  }

  SizedBox sh(double h) {
    return SizedBox(height: SizeConfig.screenHeight * h / 896);
  }
}
