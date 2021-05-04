import 'dart:io';
import 'dart:isolate';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:help/home.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'Utils/SizeConfig.dart';
import 'Utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as pathpkg;

class ExportForm extends StatefulWidget {
  _ExportFormState createState() => _ExportFormState();
}

class _ExportFormState extends State<ExportForm> {
  DateTime _selectedDateStart;
  var formattedDateStart;
  DateTime _selectedDateEnd;
  var formattedDateEnd;
  var startDate;
  List<Map<String, dynamic>> records = [];
  List<Map<String, dynamic>> filterRecordList = [];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 400;
    var h = SizeConfig.screenHeight / 800;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          "Dates for Exporting",
          style: txtS(Colors.white, 16, FontWeight.w400),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: b * 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    sh(30),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: b * 20, vertical: b * 5),
                      child: Row(
                        children: [
                          _selectedDateStart == null
                              ? Text(
                                  "No date Selected",
                                  style:
                                      txtS(Colors.black, 18, FontWeight.w400),
                                )
                              : Text(
                                  formattedDateStart,
                                  style:
                                      txtS(Colors.black, 18, FontWeight.w400),
                                ),
                          Spacer(),
                          MaterialButton(
                            height: h * 35,
                            color: Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: b * 10),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            child: Text('Select Start Date'),
                            onPressed: _pickDateDialog,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: b * 20, vertical: b * 5),
                      child: Row(
                        children: [
                          _selectedDateEnd == null
                              ? Text(
                                  "No date Selected",
                                  style:
                                      txtS(Colors.black, 18, FontWeight.w400),
                                )
                              : Text(
                                  formattedDateEnd,
                                  style:
                                      txtS(Colors.black, 18, FontWeight.w400),
                                ),
                          Spacer(),
                          MaterialButton(
                            height: h * 35,
                            color: Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: b * 10),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            child: Text('Select End Date'),
                            onPressed: _pickDateDialogEnd,
                          ),
                        ],
                      ),
                    ),
                    sh(40),
                    MaterialButton(
                      minWidth: b * 240,
                      splashColor: maC,
                      color: Colors.green,
                      onPressed: () {
                        exportToExcel();
                      },
                      padding: EdgeInsets.symmetric(
                          horizontal: b * 25, vertical: h * 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(b * 5),
                      ),
                      elevation: 0,
                      child: Text(
                        "Export",
                        style: txtS(Colors.white, 20, FontWeight.w300),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void _pickDateDialog() {
    showDatePicker(
      context: context,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.orange,
              onPrimary: Colors.white,
              surface: Colors.orange,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime(2000, 8),
      lastDate: DateTime(2030, 8),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDateStart = pickedDate;
        var date1 = DateTime.parse(_selectedDateStart.toString());
        startDate = DateTime.parse(_selectedDateStart.toString());
        formattedDateStart = "${date1.day}-${date1.month}-${date1.year}";
      });
    });
  }

  void _pickDateDialogEnd() {
    showDatePicker(
      context: context,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.orange,
              onPrimary: Colors.white,
              surface: Colors.orange,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child,
        );
      },
      initialDate: DateTime(startDate.year.toInt(), startDate.month.toInt(),
          startDate.day.toInt() + 1),
      firstDate: DateTime(startDate.year.toInt(), startDate.month.toInt(),
          startDate.day.toInt() + 1),
      lastDate: DateTime(2022, 8),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDateEnd = pickedDate;
        var date1 = DateTime.parse(_selectedDateEnd.toString());
        formattedDateEnd = "${date1.day}-${date1.month}-${date1.year}";
      });
    });
  }

  TextStyle txtS(Color col, double siz, FontWeight wg) {
    return TextStyle(
      color: col,
      fontWeight: wg,
      fontSize: SizeConfig.screenWidth * siz / 400,
    );
  }

  SizedBox sh(double h) {
    return SizedBox(height: SizeConfig.screenHeight * h / 800);
  }

  Future<DateTime> convertToDate(String dateString) async {
    var dateComp = dateString.split('-');
    int day = int.parse(dateComp[0]);
    int month = int.parse(dateComp[1]);
    int year = int.parse(dateComp[2]);

    DateTime dateTime = DateTime(year, month, day);
    return dateTime;
  }

  exportToExcel() async {
    var databasePath = await getDatabasesPath();
    String path = pathpkg.join(databasePath, 'data.db');

    Database db = await openDatabase(path);

    records = await db.query('person');
    filterRecords();

    var prettify = new Map<dynamic, dynamic>();

    prettify['name'] = "Name";
    prettify['phone'] = 'Phone No.';
    prettify['product'] = 'Product Type';
    prettify['amount'] = 'Amount';
    prettify['paymentMethod'] = 'Payment Method';
    prettify['date'] = 'Date';

    Directory directory = await getExternalStorageDirectory();
    String exportPath =
        directory.parent.parent.parent.parent.path + '/HelpNow/Records.xlsx';

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    var excel = Excel.createExcel();
    Sheet sheetObject = excel['User Data'];

    sheetObject.insertRowIterables(
        ['Id', 'Name', 'Phone No.', 'Type', 'Amount', 'Payment Method', 'Date'],
        0);

    for (int i = 0; i < filterRecordList.length; i++) {
      List<String> dataList = [
        filterRecordList[i]['id'].toString(),
        filterRecordList[i]['name'],
        filterRecordList[i]['phone'],
        filterRecordList[i]['product'],
        filterRecordList[i]['amount'],
        filterRecordList[i]['paymentMethod'],
        filterRecordList[i]['date']
      ];

      sheetObject.insertRowIterables(dataList, i + 1);
    }

    excel.setDefaultSheet('User Data');
    excel.encode().then((value) {
      File(exportPath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(value);
    });

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
      return HomePage();
    }), (route) => false);
  }

  filterRecords() async {
    for (int i = 0; i < records.length; i++) {
      String dateString = records[i]['date'];

      DateTime recordDate = await convertToDate(dateString);

      if ((recordDate.isAfter(_selectedDateStart) ||
              recordDate.isAtSameMomentAs(_selectedDateStart)) &&
          (recordDate.isBefore(_selectedDateEnd) ||
              recordDate.isAtSameMomentAs(_selectedDateEnd))) {
        filterRecordList.add(records[i]);
      }
    }
  }
}
