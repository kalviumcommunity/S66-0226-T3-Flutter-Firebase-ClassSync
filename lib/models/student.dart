/// Student — demonstrates core Dart OOP concepts used in the assignment.
///
/// Concepts shown:
///  - Classes & Objects
///  - Constructors (this.name shorthand)
///  - Null Safety (non-nullable fields → String, int)
///  - Type Inference (var / final)
///  - String interpolation
///  - Async/Await (fetchProfile)
class Student {
  final String name; // null safety: non-nullable
  final int age;
  String? subject; // nullable with ?

  Student(this.name, this.age, {this.subject});

  // Instance method
  String introduce() {
    return "Hi, I'm $name and I'm $age years old.";
  }

  // Method showing null-aware operator (??)
  String currentSubject() {
    return subject ?? 'No subject assigned yet';
  }

  // Async method — simulates fetching a profile (mirrors Firebase fetch pattern)
  Future<String> fetchProfile() async {
    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 1));
    return 'Profile loaded for $name — Age: $age, Subject: ${currentSubject()}';
  }

  // toString override for easy printing
  @override
  String toString() => 'Student(name: $name, age: $age, subject: $subject)';
}
