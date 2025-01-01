import 'package:date_format/date_format.dart';
import 'package:file/models/files.dart';
import 'package:file/models/student.dart';
import 'package:flutter/material.dart';

class StudentInfoScreen extends StatefulWidget {
  const StudentInfoScreen({super.key});

  @override
  State<StudentInfoScreen> createState() => _StudentInfoScreenState();
}

class _StudentInfoScreenState extends State<StudentInfoScreen> {
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var birthOfDate = TextEditingController();
  bool isDeleted = false;

  var isDateClicked = false;
  List<Student> dataList = [];

  @override
  void initState() {
    Files.readFromFile().then((value) {
      setState(() {
        dataList = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          ListTile(
            leading: Text(
              "Student",
              style: TextStyle(fontSize: 40),
            ),
            trailing: GestureDetector(
              onTap: () {
                setState(() {
                  firstName.clear();
                  lastName.clear();
                  birthOfDate.clear();
                });

                operationStudent(context);
              },
              child: Icon(Icons.add, size: 30),
            ),
          ),
          if (dataList.isNotEmpty)
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) => listItem(dataList[index],
                          () {
                        setState(() {
                          firstName.text = dataList[index].firstName;
                          lastName.text = dataList[index].lastName;
                          birthOfDate.text = dataList[index].dateOfBirth;
                        });

                        operationStudent(context, index: index, isEdit: true);
                      },
                          () => operationStudent(context,
                              index: index, isDelete: true)),
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: dataList.length),
            )
        ],
      )),
    );
  }

  void operationStudent(BuildContext context,
      {bool isEdit = false, bool isDelete = false, int index = 0}) {
    if (!isDelete) {
      showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 45,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              inputData(title: isEdit ? "Edit Student" : "Add Student"),
              ElevatedButton(
                onPressed: () {
                  if (firstName.text.isEmpty ||
                      lastName.text.isEmpty ||
                      birthOfDate.text.isEmpty) {
                    return;
                  }

                  setState(() {
                    if (!isEdit && !isDelete) {
                      dataList.add(Student(
                          firstName: firstName.text,
                          lastName: lastName.text,
                          dateOfBirth: birthOfDate.text));
                    }

                    if (isEdit) {
                      dataList[index] = Student(
                        firstName: firstName.text,
                        lastName: lastName.text,
                        dateOfBirth: birthOfDate.text,
                      );
                    }
                  });

                  Files.writeToFile(dataList);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  backgroundColor: Colors.black,
                ),
                child: Text(
                  !isEdit ? "SAVE" : "UPDATE",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 10,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.warning,
                    ),
                    Text(
                      "Do you want to delete this item ?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                        onPressed: () {
                          setState(() {
                            isDeleted = false;
                          });
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            backgroundColor: Colors.red),
                        child: Text(
                          "CANCEL",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )),
                    OutlinedButton(
                        onPressed: () {
                          setState(() {
                            isDeleted = true;
                          });

                          if (isDeleted) {
                            setState(() {
                              dataList.removeAt(index);
                            });

                            Files.writeToFile(dataList);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 1),
                                backgroundColor: Colors.green,
                                content: Text(
                                  "Delete sucessfully",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                ),
                              ),
                            );
                          }
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            backgroundColor: Colors.green),
                        child: Text("YES",
                            style:
                                TextStyle(color: Colors.white, fontSize: 13)))
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget inputData({String title = "Enter Informations"}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 28),
        ),
        inputField(
          "First Name",
          suffixWidget: Icon(Icons.person),
          controller: firstName,
        ),
        inputField(
          "Last Name",
          suffixWidget: Icon(Icons.male),
          controller: lastName,
        ),
        TextField(
          controller: birthOfDate,
          readOnly: true,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              setState(() {
                birthOfDate.text =
                    formatDate(pickedDate, [dd, '/', mm, '/', yyyy]);
              });
            }
          },
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.calendar_month),
            hintText: "Birthdate",
            border: OutlineInputBorder(),
          ),
        )
      ],
    );
  }

  Widget listItem(Student student, VoidCallback edit, VoidCallback delete) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: Colors.white38,
      child: Row(
        spacing: 10,
        children: [
          Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                color: Colors.white,
              )),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Text(
                      student.firstName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      student.lastName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(student.dateOfBirth),
                  ],
                ),
                Row(
                  children: [
                    IconButton(onPressed: edit, icon: Icon(Icons.edit)),
                    IconButton(
                      onPressed: delete,
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget inputField(String? hint,
      {TextEditingController? controller,
      Widget? suffixWidget,
      bool? isSuffixWidget = false}) {
    return TextField(
      keyboardType: TextInputType.text,
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: isSuffixWidget != true ? suffixWidget : Text(""),
        hintText: hint ?? "Name ",
        border: OutlineInputBorder(),
      ),
    );
  }
}
