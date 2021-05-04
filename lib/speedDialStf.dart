import 'package:help/export.dart';
import 'package:help/form.dart';
import 'Utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'Utils/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Dial extends StatefulWidget {
  @override
  _Dial createState() => _Dial();
}

class _Dial extends State<Dial> {
  ScrollController scrollController;
  bool dialVisible = true;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
  }

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 400;
    var h = SizeConfig.screenHeight / 800;
    return SpeedDial(
      backgroundColor: gc,
      animatedIcon: AnimatedIcons.add_event,
      visible: dialVisible,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                MdiIcons.fileExport,
                color: Colors.white,
                size: b * 20,
              ),
            ]),
            backgroundColor: mc,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return ExportForm();
                }),
              );
            }),
        SpeedDialChild(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                Icons.add,
                color: Colors.white,
                size: b * 24,
              ),
            ]),
            backgroundColor: mc,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return FormFill();
                }),
              );
            }),
      ],
    );
  }
}
