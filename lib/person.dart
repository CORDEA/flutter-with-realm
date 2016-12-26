class Person {
  String firstName;

  String lastName;

  int age;

  String country;

  Person({this.firstName, this.lastName, this.age, this.country});

  Person.fromMap(Map map) {
    firstName = map['firstName'];
    lastName = map['lastName'];
    age = map['age'];
    country = map['country'];
  }

  Map toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'country': country
    };
  }

  bool validate() {
    return firstName != null &&
        lastName != null &&
        age != -1 &&
        country != null;
  }
}
