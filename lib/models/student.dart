class Student {
  final String name; // null safety: non-nullable
  final int age;
  String? subject; // nullable with ?

  Student(this.name, this.age, {this.subject});

  String introduce() {
    return "Hi, I'm $name and I'm $age years old.";
  }

  String currentSubject() {
    return subject ?? 'No subject assigned yet';
  }

  Future<String> fetchProfile() async {
    await Future.delayed(const Duration(seconds: 1));
    return 'Profile loaded for $name — Age: $age, Subject: ${currentSubject()}';
  }

  @override
  String toString() => 'Student(name: $name, age: $age, subject: $subject)';
}
