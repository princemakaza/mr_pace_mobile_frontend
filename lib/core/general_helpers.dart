
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class GeneralHelpers {
  // Method to navigate to another screen with back function
  static void temporaryNavigator(BuildContext context, Widget nextScreen) {
    Navigator.push(context, MaterialPageRoute(builder: (c) => nextScreen));
  }

  // Method to navigate to another screen without back function
  static void permanentNavigator(BuildContext context, Widget nextScreen) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (c) => nextScreen));
  }

  // Method to navigate to previous screen
  static void back(BuildContext context) {
    Navigator.pop(context);
  }


  /// This methods capitalizes the first word of a [String]
  static String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input.substring(0, 1).toUpperCase() + input.substring(1);
  }
  
  static String getTimeFromTimeStamp({required String format, required String timeStamp}){
    return DateFormat(format).format(DateTime.parse(timeStamp));
  }

  /// FORMAT CREDIT CARD NUMBER
  static String formatCardNumber(String cardNumber) {
    String formattedNumber = '';
    for (int i = 0; i < cardNumber.length; i++) {
      if (i != 0 && i % 4 == 0) {
        formattedNumber += ' '; // Add a space after every 4 digits
      }
      formattedNumber += cardNumber[i];
    }
    return formattedNumber;
  }


  /// OBSUCURE THE CREDIT CARDNUMBER
  static String obscureCardNumber(String cardNumber) {
    // Obfuscate the first 12 digits of the card number
    String obscuredDigits = cardNumber.substring(0, 14).replaceAll(RegExp(r'\d'), '●');
    return obscuredDigits + cardNumber.substring(14);
  }




  static String formatTimeDifference(String isoDateTime) {
    DateTime givenTime = DateTime.parse(isoDateTime);
    DateTime currentTime = DateTime.now();
    Duration diff = currentTime.difference(givenTime);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minutes ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else if (diff.inDays < 30) {
      int weeks = (diff.inDays / 7).round();
      return '$weeks weeks ago';
    } else {
      int months = (diff.inDays / 30).round();
      return '$months months ago';
    }
  }

  // Function to check if a string represents a numeric value
  static bool isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  // Function to check if a string represents an integer value
  static bool isInteger(String str) {
    if (str == null) {
      return false;
    }
    final pattern = RegExp(r'^[0-9]+$');
    return pattern.hasMatch(str);
  }

  static bool isEmail(String email) {
    if (email == null) {
      return false;
    }
    final pattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return pattern.hasMatch(email);
  }

  static bool isStrongPassword(String password) {
    if (password == null) {
      return false;
    }

    // Check for at least one uppercase letter
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);

    // Check for at least one lowercase letter
    final hasLowercase = RegExp(r'[a-z]').hasMatch(password);

    // Check for at least one number
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);

    // Check for at least one special character
    final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

    // Return true if all criteria are met
    return hasUppercase && hasLowercase && hasNumber && hasSpecialChar;
  }


}
