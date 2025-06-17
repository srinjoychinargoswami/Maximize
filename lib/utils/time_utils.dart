
class CustomTimeOfDay {
  final int hour;
  final int minute;

  CustomTimeOfDay(this.hour, this.minute);

  // Format the time as a string (HH:mm)
  String format() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  // Convert to a string for storage (HH:mm)
  String toStorageString() {
    return '$hour:$minute';
  }

  // Factory method to create from a string (HH:mm)
  static CustomTimeOfDay fromStorageString(String timeString) {
    final parts = timeString.split(':');
    if (parts.length != 2) {
      throw FormatException('Invalid time format: $timeString');
    }
    return CustomTimeOfDay(int.parse(parts[0]), int.parse(parts[1]));
  }

  // Convert to DateTime using a given date
  DateTime toDateTime(DateTime date) {
    return DateTime(date.year, date.month, date.day, hour, minute);
  }
}