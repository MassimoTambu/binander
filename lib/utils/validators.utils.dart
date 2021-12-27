part of utils;

class ValidatorUtils {
  static String? required<T>(T? value, {String? name}) {
    if (value == null) {
      if (name == null) return 'Required';
      return '$name is required';
    }
  }
}
