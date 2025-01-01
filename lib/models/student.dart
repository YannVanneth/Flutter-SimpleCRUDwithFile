class Student {
  late String firstName;
  late String lastName;
  late String dateOfBirth;

  Student(
      {required this.firstName,
      required this.lastName,
      required this.dateOfBirth});

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "dateOfBirth": dateOfBirth,
    };
  }

  Student.fromJson(Map<String, dynamic> json)
      : firstName = json["firstName"],
        lastName = json["lastName"],
        dateOfBirth = json["dateOfBirth"];
}
