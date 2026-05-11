class ValidRegex {
  static final RegExp name = RegExp(r"^[a-zA-Z\s]{2,50}$");
  static final RegExp email = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
  static final RegExp phone = RegExp(r"^\d{10}$");

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    if (!name.hasMatch(value.trim())) return 'Please enter a valid name';
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!email.hasMatch(value.trim())) return 'Please enter a valid email address';
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone number is required';
    if (!phone.hasMatch(value.trim())) return 'Please enter a valid 10-digit phone number';
    return null;
  }
}
