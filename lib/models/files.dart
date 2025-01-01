import 'dart:convert';
import 'dart:io';

import 'package:file/models/student.dart';
import 'package:path_provider/path_provider.dart';

class Files {
  static writeToFile(List<Student> students) {
    getApplicationDocumentsDirectory().then((path) {
      File file = File('${path.path}/studentinfo.txt');

      String jsonString = jsonEncode(students.map((s) => s.toJson()).toList());

      file.writeAsStringSync(jsonString);
    });
  }

  static Future<List<Student>> readFromFile() async {
    List<Student> students = [];

    Directory appDocDir = await getApplicationDocumentsDirectory();
    File file = File('${appDocDir.path}/studentinfo.txt');

    if (file.existsSync()) {
      String jsonString = file.readAsStringSync();
      List<dynamic> jsonList = jsonDecode(jsonString);

      students = jsonList.map((json) => Student.fromJson(json)).toList();
    }

    return students;
  }
}
