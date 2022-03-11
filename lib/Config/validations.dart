String? validateEmailField(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern.toString());
  if (value.isEmpty)
    return 'Email is Required.';
  else if (!regex.hasMatch(value)) return 'Invalid Email';
  return null;
}

String? validateName(String value) {
  Pattern pattern = r'^[a-z A-Z]+$';
  RegExp regex = new RegExp(pattern.toString());
  if (value.isEmpty)
    return 'Name is Required.';
  else if (!regex.hasMatch(value))
    return 'Name accept only characters';
  else if (value.length < 3)
    return 'Name required at least 3 character';
  else if (value.length > 45)
    return 'Name required at most 45 character';
  else
    return null;
}

String? validateLastName(String value) {
  Pattern pattern = r'^[a-z A-Z]+$';
  RegExp regex = new RegExp(pattern.toString());
  if (value.isEmpty)
    return ' Last Name is Required.';
  else if (!regex.hasMatch(value))
    return 'Name accept only characters';
  else if (value.length < 3)
    return 'Name required at least 3 character';
  else if (value.length > 45)
    return 'Name required at most 45 character';
  else
    return null;
}

String? validateEmail(String value) {
  if (value.isEmpty) return 'Email is Required.';
  return null;
}

String? validateSubject(String value) {
  if (value.isEmpty) return 'Subject is Required.';
  return null;
}

String? validateMessage(String value) {
  if (value.isEmpty) return 'Message is Required.';
  return null;
}

String? validateAddress(String value) {
  if (value.isEmpty) return 'Address is Required.';
  return null;
}

String? validatePin(String value) {
  if (value.isEmpty) return 'Pin is Required.';
  return null;
}

String? validateState(String value) {
  if (value.isEmpty) return 'State is Required.';
  return null;
}

String? validateCity(String value) {
  if (value.isEmpty) return 'City is Required.';
  return null;
}

String? validateCountry(String value) {
  if (value.isEmpty) return 'Country is Required.';
  return null;
}

String? validateMobile(String value) {
  if (value.isEmpty)
    return 'Mobile Number is Required.';
  else if (value.length < 10)
    return 'Mobile Number required at least 10 numbers';
  else if (value.length > 10)
    return 'Mobile Number required at most 10 numbers';
  else
    return null;
}

String? validatePassword(String value) {
  if (value.isEmpty) return 'Password is Required.';
  return null;
}

String? cnfPassword(String value) {
  if (value.isEmpty) return 'Confirm Password is Required.';
  return null;
}
