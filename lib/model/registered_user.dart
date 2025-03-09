class RegisteredUser {
  final String fullName;
  final String email;
  final String password;
  final String city;
  final bool isFrequentDriver;
  final double weight;

  RegisteredUser({
    required this.fullName,
    required this.email,
    required this.password,
    required this.city,
    required this.isFrequentDriver,
    required this.weight,
  });
}
