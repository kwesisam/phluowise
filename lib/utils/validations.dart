import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Validations {
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  static String? phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Contact number is required';
    }

    // Note: phoneUtil requires 'phonenumber' package, which is not included here
    // Replace with regex-based validation for simplicity
    final phoneRegex = RegExp(r'^\+?\d{10,15}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid contact number (10-15 digits).';
    }

    return null;
  }

  static String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Product name is required';
    }

    if (value.length < 4 || value.length > 20) {
      return 'Product name must be between 4 and 20 characters.';
    }

    final validCharacters = RegExp(r'^[a-zA-Z0-9_ ]+$');
    if (!validCharacters.hasMatch(value)) {
      return 'Product name can only contain letters, numbers, underscores, and spaces.';
    }

    return null;
  }

  static String? priceValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price is required';
    }

    final validPrice = RegExp(r'^\d+(\.\d{1,2})?$');
    if (!validPrice.hasMatch(value)) {
      return 'Please enter a valid price (e.g., 10, 10.5, 10.99).';
    }

    return null;
  }

  static String? discountValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final validPrice = RegExp(r'^\d+(\.\d{1,2})?$');
    if (!validPrice.hasMatch(value)) {
      return 'Please enter a valid discount (e.g., 10, 10.5, 10.99).';
    }

    return null;
  }

  static String? desValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Product description is required';
    }

    if (value.length < 4 || value.length > 300) {
      return 'Product description must be between 4 and 300 characters.';
    }

    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    if (value.trim().length < 8) {
      return 'Password must be at least 8 characters.';
    }

    final hasNumber = RegExp(r'\d'); // Checks for at least one digit
    final hasSpecialChar = RegExp(
      r'[!@#\$%^&*(),.?":{}|<>]',
    ); // Checks for at least one special character

    if (!hasNumber.hasMatch(value)) {
      return 'Password must contain at least one number.';
    }

    if (!hasSpecialChar.hasMatch(value)) {
      return 'Password must contain at least one special character.';
    }

    return null;
  }
}
