import 'package:flutter/material.dart';

part 'pages/home_page.dart';
part 'pages/create_habit_page.dart';
part 'pages/profile_page.dart';
part 'pages/activity_calendar_page.dart';
part 'pages/statistics_page.dart';
part 'pages/habits_page.dart';

void main() => runApp(const HabitlyApp());

const _purple = Color(0xFF5949C0);
const _ink = Color(0xFF1A192F);
const _muted = Color(0xFF747184);
const _canvas = Color(0xFFFAF9FE);
final ValueNotifier<ThemeMode> _themeMode = ValueNotifier(ThemeMode.light);

class HabitlyApp extends StatelessWidget {
  const HabitlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(valueListenable: _themeMode, builder: (context, mode, _) => MaterialApp(
      title: 'Habitly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _canvas,
        colorScheme: ColorScheme.fromSeed(seedColor: _purple),
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark, colorScheme: ColorScheme.fromSeed(seedColor: _purple, brightness: Brightness.dark), scaffoldBackgroundColor: const Color(0xFF1E1D2F), fontFamily: 'Roboto', cardColor: const Color(0xFF2F2E45)),
      themeMode: mode,
      home: const HabitHomePage(),
    ));
  }
}

class Habit {
  Habit(this.name, this.detail, this.icon, this.color, {this.done = false, this.category = 'Lifestyle', this.frequency = 'Daily', this.days = const [1, 2, 3, 4, 5, 6, 7], this.reminder = true});
  final String name;
  final String detail;
  final IconData icon;
  final Color color;
  final String category;
  final String frequency;
  final List<int> days;
  final bool reminder;
  bool done;
}

