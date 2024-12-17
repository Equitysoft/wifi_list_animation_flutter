import 'package:flutter/material.dart';

class WifiListModel {
  IconData icons;
  String wifiName;
  bool onTap;

  WifiListModel({
    this.icons = Icons.insert_emoticon_sharp,
    this.wifiName = "",
    this.onTap=false,
  });
}
