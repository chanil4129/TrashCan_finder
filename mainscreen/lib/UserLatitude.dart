import 'dart:convert';
import 'dart:core';

void main(){
  var jsonData = """{LNG":123.002,"LAT":125.002}""";
  Map<String, dynamic> user = jsonDecode(jsonData);
}