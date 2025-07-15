class User {
  final String name;
  final String surname;
  final String organization;
  final String phone;
  final String password;

  User({
    required this.name,
    required this.surname,
    required this.organization,
    required this.phone,
    required this.password,
  });

  @override
  String toString() {
    return 'USER:\n -name: $name \n -surname: $surname\n -organization: $organization\n -phone: $phone\n -password: $password';
  }
}
