import 'dart:io';
import 'package:flutter/services.dart';
import 'package:help/home.dart';
import 'package:path/path.dart' as pathpkg;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'Utils/SizeConfig.dart';
import 'Utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class FormFill extends StatefulWidget {
  _FormFillState createState() => _FormFillState();
}

class Option {
  String option;
  Option(this.option);
  static List<Option> getOption() {
    return <Option>[
      Option('Google Pay'),
      Option('Cash'),
      Option('Online'),
    ];
  }
}

class Option1 {
  String option1;
  Option1(this.option1);
  static List<Option1> getOption1() {
    return <Option1>[
      Option1('Product'),
      Option1('Service'),
    ];
  }
}

class _FormFillState extends State<FormFill> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  File image1File;

  List<Option> _option = Option.getOption();
  List<Option1> _option1 = Option1.getOption1();

  List<DropdownMenuItem<Option>> _dropdownMenuItemsTime;
  List<DropdownMenuItem<Option1>> _dropdownMenuItemsType;
  Option1 _selectedType;
  Option _selectedTime;
  DateTime _selectedDate;
  var formattedDate;
  bool getImage = false;
  String imgFileName = "";

  @override
  void initState() {
    _dropdownMenuItemsTime = buildDropdownMenuItemsTime(_option);
    _dropdownMenuItemsType = buildDropdownMenuItemsType(_option1);
    _selectedType = _dropdownMenuItemsType[0].value;

    _selectedTime = _dropdownMenuItemsTime[0].value;
    super.initState();
  }

  List<DropdownMenuItem<Option>> buildDropdownMenuItemsTime(List options) {
    List<DropdownMenuItem<Option>> items = List();

    for (Option options in options) {
      items.add(
        DropdownMenuItem(
          value: options,
          child: Container(
            color: Colors.white,
            child: Text(
              options.option,
              style: TextStyle(
                color: Colors.black45,
                fontSize: SizeConfig.screenWidth * 14 / 400,
              ),
            ),
          ),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Option1>> buildDropdownMenuItemsType(List options) {
    List<DropdownMenuItem<Option1>> items = List();

    for (Option1 options in options) {
      items.add(
        DropdownMenuItem(
          value: options,
          child: Container(
            color: Colors.white,
            child: Text(
              options.option1,
              style: TextStyle(
                color: Colors.black45,
                fontSize: SizeConfig.screenWidth * 14 / 400,
              ),
            ),
          ),
        ),
      );
    }
    return items;
  }

  onchangeDropdownItemOption(Option selectedOption) {
    setState(() {
      _selectedTime = selectedOption;
    });
  }

  onchangeDropdownItemOption1(Option1 selectedOption) {
    setState(() {
      _selectedType = selectedOption;
    });
  }

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
          "Form Filling With Details",
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
                    getImageCont(getImage),
                    sh(30),
                    Container(
                      width: b * 345,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(b * 10),
                      ),
                      child: TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        style: txtS(Colors.black45, 16, FontWeight.w500),
                        decoration: dec('Name'),
                      ),
                    ),
                    sh(10),
                    Container(
                      width: b * 345,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(b * 10),
                      ),
                      child: TextFormField(
                        controller: mobileController,
                        keyboardType: TextInputType.number,
                        style: txtS(Colors.black45, 16, FontWeight.w500),
                        decoration: dec('Mobile Number'),
                      ),
                    ),
                    sh(10),
                    Container(
                      width: b * 345,
                      padding: EdgeInsets.symmetric(horizontal: b * 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: b * 0.7),
                        borderRadius: BorderRadius.circular(b * 5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          padding: EdgeInsets.zero,
                          child: DropdownButton(
                            dropdownColor: Colors.white,
                            itemHeight: kMinInteractiveDimension,
                            iconEnabledColor: Colors.green,
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: b * 18,
                              fontWeight: FontWeight.w400,
                            ),
                            value: _selectedType,
                            items: _dropdownMenuItemsType,
                            onChanged: onchangeDropdownItemOption1,
                          ),
                        ),
                      ),
                    ),
                    sh(10),
                    Container(
                      width: b * 345,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(b * 10),
                      ),
                      child: TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        style: txtS(Colors.black45, 16, FontWeight.w500),
                        decoration: dec('Amount'),
                      ),
                    ),
                    sh(10),
                    Container(
                      width: b * 345,
                      padding: EdgeInsets.symmetric(horizontal: b * 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: b * 0.7),
                        borderRadius: BorderRadius.circular(b * 5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          padding: EdgeInsets.zero,
                          child: DropdownButton(
                            dropdownColor: Colors.white,
                            itemHeight: kMinInteractiveDimension,
                            iconEnabledColor: Colors.green,
                            hint: Text(
                              'Select Payment Method',
                              style: txtS(Colors.black, 16, FontWeight.w400),
                            ),
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: b * 18,
                              fontWeight: FontWeight.w400,
                            ),
                            value: _selectedTime,
                            items: _dropdownMenuItemsTime,
                            onChanged: onchangeDropdownItemOption,
                          ),
                        ),
                      ),
                    ),
                    sh(10),
                    Container(
                      width: b * 345,
                      padding: EdgeInsets.symmetric(
                          horizontal: b * 20, vertical: b * 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: b * 0.7),
                        borderRadius: BorderRadius.circular(b * 5),
                      ),
                      child: Row(
                        children: [
                          _selectedDate == null
                              ? Text(
                                  "No date Selected",
                                  style:
                                      txtS(Colors.black45, 16, FontWeight.w400),
                                )
                              : Text(
                                  formattedDate,
                                  style:
                                      txtS(Colors.black45, 16, FontWeight.w400),
                                ),
                          Spacer(),
                          MaterialButton(
                            height: h * 35,
                            color: Colors.green,
                            padding: EdgeInsets.zero,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            child: Text('Select Date'),
                            onPressed: _pickDateDialog,
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
                        addDatatoLocalDB();
                        //tempFunction();
                      },
                      padding: EdgeInsets.symmetric(
                          horizontal: b * 25, vertical: h * 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(b * 5),
                      ),
                      elevation: 0,
                      child: Text(
                        "Submit",
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
        _selectedDate = pickedDate;
        var date1 = DateTime.parse(_selectedDate.toString());
        formattedDate = "${date1.day}-${date1.month}-${date1.year}";
      });
    });
  }

  InkWell getImageCont(bool isImage) {
    var b = SizeConfig.screenWidth / 400;
    var h = SizeConfig.screenHeight / 800;

    return InkWell(
      splashColor: Colors.green,
      onTap: () {
        pickImage();
      },
      child: isImage
          ? Container(
              height: h * 150,
              width: b * 150,
              decoration: BoxDecoration(
                border: Border.all(color: rc),
                borderRadius: BorderRadius.circular(b * 5),
              ),
              child: Image.file(
                image1File,
                fit: BoxFit.cover,
              ),
            )
          : Container(
              height: h * 150,
              width: b * 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: b * 0.7),
                borderRadius: BorderRadius.circular(b * 5),
              ),
              child: Container(
                child: Icon(Icons.add_a_photo, color: rc, size: b * 40),
              ),
            ),
    );
  }

  pickImage() async {
    var picker = await ImagePicker().getImage(source: ImageSource.gallery);

    imgFileName = picker.path.split('/').last;
    print(imgFileName);
    File selectedImage = File(picker.path);
    setState(() {
      image1File = selectedImage;
      getImage = true;
    });
  }

  InputDecoration dec(String txt) {
    var b = SizeConfig.screenWidth / 400;
    var h = SizeConfig.screenHeight / 800;

    return InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: b * 0.7),
        borderRadius: BorderRadius.circular(b * 5),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: b * 0.7),
        borderRadius: BorderRadius.circular(b * 5),
      ),
      hintText: txt,
      hintStyle: TextStyle(
        color: Colors.black45,
        fontSize: b * 16,
        fontWeight: FontWeight.w400,
      ),
      isDense: true,
      contentPadding: EdgeInsets.symmetric(
        vertical: h * 15,
        horizontal: b * 20,
      ),
    );
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

  addDatatoLocalDB() async {
    String name = nameController.text;
    String phone = mobileController.text;
    String product = _selectedType.option1;
    String amount = amountController.text;
    String paymentMethod = _selectedTime.option;
    String date = formattedDate.toString();
    int id;

    Map<String, dynamic> map = {
      'name': name,
      'phone': phone,
      'product': product,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'date': date
    };

    var databasePath = await getDatabasesPath();
    String path = pathpkg.join(databasePath, 'data.db');

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE person (id INTEGER PRIMARY KEY, name TEXT, phone TEXT, product TEXT, amount TEXT, paymentMethod TEXT, date TEXT)');
    }).then((databs) async {
      id = await databs.insert('person', map);

      print(id);
      List<Map<String, dynamic>> ls =
          await databs.query('person').then((value) {
        print(value);
      });
    });

    getExternalStorageDirectory().then((directory) async {
      String imagePath = pathpkg.join(
          directory.path, '${id}.png'); //imgFileName.split('.').last

      await image1File.copy(imagePath).then((value) {
        print(value.path);
      });
    });

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
      return HomePage();
    }), (route) => false);
  }
}
