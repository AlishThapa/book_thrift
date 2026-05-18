class ProfileData {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String userType;
  final String location;
  final String institution;
  final String className;
  final String semester;
  final String createdAt;
  final String? updatedAt;

  ProfileData({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.userType,
    required this.location,
    required this.institution,
    required this.className,
    required this.semester,
    required this.createdAt,
    this.updatedAt,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      phone: json['phone'],
      userType: json['user_type'],
      location: json['location'],
      institution: json['institution'],
      className: json['class_name'],
      semester: json['semester'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'user_type': userType,
      'location': location,
      'institution': institution,
      'class_name': className,
      'semester': semester,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
