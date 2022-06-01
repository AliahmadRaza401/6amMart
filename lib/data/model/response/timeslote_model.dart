import 'package:flutter/material.dart';

class TimeSlotModel {
  int day;
  DateTime startTime;
  DateTime endTime;

  TimeSlotModel({@required this.day, @required this.startTime, @required this.endTime});

  TimeSlotModel.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    return data;
  }
}
