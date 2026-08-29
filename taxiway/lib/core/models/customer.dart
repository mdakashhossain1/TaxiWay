class Customer {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? photoUrl;

  const Customer({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.photoUrl,
  });

  Customer copyWith({String? name, String? email, String? photoUrl}) {
    return Customer(
      id: id,
      name: name ?? this.name,
      phone: phone,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
