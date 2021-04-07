import 'dart:convert';

import 'package:parrotspellingapp/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  static const String LEVEL = 'level';
  static const String USER = 'user';
  static const String API_KEY = 'api_key';
  static const String REMINDER_DATE = 'reminder_date';
  static const String QUERIES = 'queries';

  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('counter') ?? 0) + 1;
    print('Pressed $counter times.');
    await prefs.setInt('counter', counter);
  }

  Future readUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userString = prefs.getString(USER);
    if (userString == null) return null;
    UserModel user = UserModel.fromMap(jsonDecode(userString));
    print(user.toString());
    return user;
  }

  Future saveUser(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(USER, jsonEncode(user.toMap()));
  }

  Future saveQueries(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        QUERIES,
        await readQueries()
          ..add(query));
  }

  Future<List<String>> readQueries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(QUERIES) ?? <String>[];
  }

  Future saveLevel(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(LEVEL, value);
  }

  Future readLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(LEVEL) ?? 0;
  }

  Future saveSpeechApiKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(API_KEY, key);
  }

  Future readSpeechApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(API_KEY);
  }

  Future saveReminderTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var now = DateTime.now();
    var tomorrow = DateTime(now.year, now.month, now.day, 24);
    var timeUntilTomorrow = tomorrow.difference(now);
    var reminderAfter = tomorrow.add(Duration(days: 2));
    prefs.setString(REMINDER_DATE, reminderAfter.toString());
  }

  Future<bool> isReminderTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String reminderAfter = prefs.getString(REMINDER_DATE);
    return (reminderAfter == null ||
        DateTime.now().isAfter(DateTime.parse(reminderAfter)));
  }

  Future clear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.clear();
  }
}
