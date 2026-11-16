part of '../main.dart';

class ActivityCalendarPage extends StatefulWidget {
  const ActivityCalendarPage({super.key, required this.habits});
  final List<Habit> habits;

  @override
  State<ActivityCalendarPage> createState() => _ActivityCalendarPageState();
}

class _ActivityCalendarPageState extends State<ActivityCalendarPage> {
  late DateTime _month;
  late DateTime _selectedDay;
  static const _completedDays = {2, 3, 4, 6, 7, 9, 10, 11, 13, 14, 16, 17};
  static const _partialDays = {1, 8, 12, 18};
  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
    _selectedDay = DateTime(now.year, now.month, now.day);
  }

  bool get _isSelectedToday => _selectedDay.year == DateTime.now().year && _selectedDay.month == DateTime.now().month && _selectedDay.day == DateTime.now().day;
  bool get _isSelectedPast => !_selectedDay.isAfter(DateTime.now());
  int get _completedCount => _isSelectedToday ? widget.habits.where((habit) => habit.done).length : (_isSelectedPast ? widget.habits.length : 0);
  String get _monthTitle => '${_month.monthName} ${_month.year}';

  void _changeMonth(int amount) {
    setState(() {
      _month = DateTime(_month.year, _month.month + amount);
      final lastDay = DateTime(_month.year, _month.month + 1, 0).day;
      _selectedDay = DateTime(_month.year, _month.month, _selectedDay.day.clamp(1, lastDay).toInt());
    });
  }

  void _selectDate(int day) => setState(() => _selectedDay = DateTime(_month.year, _month.month, day));

  String get _selectedLabel {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${weekdays[_selectedDay.weekday - 1]}, ${months[_selectedDay.month - 1]} ${_selectedDay.day}';
  }

  @override
  Widget build(BuildContext context) {
    final activeDays = _month.year == DateTime.now().year && _month.month == DateTime.now().month ? DateTime.now().day : 18;
    final completedTotal = _isSelectedToday ? _completedCount : (_isSelectedPast ? widget.habits.length : 0);
    final progress = widget.habits.isEmpty ? 0.0 : completedTotal / widget.habits.length;
    return Scaffold(
      body: SafeArea(bottom: false, child: CustomScrollView(slivers: [
        SliverPadding(padding: const EdgeInsets.fromLTRB(20, 8, 20, 28), sliver: SliverList(delegate: SliverChildListDelegate([
          Row(children: [IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back_rounded)), const SizedBox(width: 4), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Activity Calendar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _ink)), Text('Your consistency, day by day.', style: TextStyle(fontSize: 11, color: _muted))])), IconButton(onPressed: () => setState(() { _month = DateTime.now(); _selectedDay = DateTime.now(); }), icon: const Icon(Icons.calendar_month_rounded, color: _purple))]),
          const SizedBox(height: 8),
          _calendarCard(),
          const SizedBox(height: 14),
          Row(children: [Expanded(child: _calendarMetric(Icons.local_fire_department_rounded, '$activeDays', 'Active Days')), const SizedBox(width: 8), Expanded(child: _calendarMetric(Icons.verified_rounded, '${activeDays * 3}', 'Completed')), const SizedBox(width: 8), Expanded(child: _calendarMetric(Icons.trending_up_rounded, '82%', 'Success Rate'))]),
        ])))
      ])),
      bottomNavigationBar: NavigationBar(height: 65, selectedIndex: 2, onDestinationSelected: (index) { if (index == 0) { Navigator.of(context).popUntil((route) => route.isFirst); } else if (index == 1) { Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => MyHabitsPage(habits: widget.habits))); } else if (index == 2) { Navigator.of(context).maybePop(); } else if (index == 3) { Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ProfilePage(habits: widget.habits))); } }, destinations: const [NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'), NavigationDestination(icon: Icon(Icons.explore_rounded), label: 'Explore'), NavigationDestination(icon: Icon(Icons.insights_rounded), label: 'Statistics'), NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profile')]),
    );
  }

  Widget _calendarCard() {
    final firstOffset = DateTime(_month.year, _month.month, 1).weekday - 1;
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final cells = ((firstOffset + daysInMonth + 6) ~/ 7) * 7;
    final today = DateTime.now();
    return Container(padding: const EdgeInsets.all(14), decoration: _calendarDecoration(), child: Column(children: [
      Row(children: [Text(_monthTitle, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _ink)), const SizedBox(width: 8), _calendarPill('Q${((_month.month - 1) ~/ 3) + 1}'), const Spacer(), IconButton(visualDensity: VisualDensity.compact, onPressed: () => _changeMonth(-1), icon: const Icon(Icons.chevron_left_rounded, size: 20)), IconButton(visualDensity: VisualDensity.compact, onPressed: () => _changeMonth(1), icon: const Icon(Icons.chevron_right_rounded, size: 20))]),
      Row(children: _weekdays.map((day) => Expanded(child: Center(child: Text(day, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: _muted))))).toList()),
      const SizedBox(height: 5),
      GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: cells, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 4, crossAxisSpacing: 4, childAspectRatio: .95), itemBuilder: (context, index) {
        final day = index - firstOffset + 1;
        if (day < 1 || day > daysInMonth) return const SizedBox.shrink();
        final date = DateTime(_month.year, _month.month, day);
        final isFuture = date.isAfter(DateTime(today.year, today.month, today.day));
        final selected = date.year == _selectedDay.year && date.month == _selectedDay.month && date.day == _selectedDay.day;
        final done = !isFuture && (_month.year != today.year || _month.month != today.month ? day % 5 != 0 : _completedDays.contains(day));
        final partial = !isFuture && !done && (_month.year != today.year || _month.month != today.month ? day % 5 == 0 : _partialDays.contains(day));
        final fill = done ? _purple : (partial ? const Color(0xFFEFEBFF) : Colors.transparent);
        final textColor = done ? Colors.white : (isFuture ? const Color(0xFFB9B5C4) : _ink);
        return GestureDetector(onTap: () => _selectDate(day), child: AnimatedContainer(duration: const Duration(milliseconds: 140), decoration: BoxDecoration(color: fill, borderRadius: BorderRadius.circular(12), border: selected ? Border.all(color: _purple, width: 1.6) : null), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('$day', style: TextStyle(fontSize: 11, fontWeight: selected || done ? FontWeight.w700 : FontWeight.w400, color: selected && !done ? _purple : textColor)), const SizedBox(height: 2), Container(width: 5, height: 5, decoration: BoxDecoration(shape: BoxShape.circle, color: done ? Colors.white : (partial || selected ? _purple : Colors.transparent), border: partial ? Border.all(color: _purple, width: 1) : null))])));
      }),
      const SizedBox(height: 9),
      const Divider(height: 1, color: Color(0xFFEAE7F0)),
      const SizedBox(height: 10),
      const Wrap(alignment: WrapAlignment.spaceBetween, spacing: 8, runSpacing: 5, children: [_CalendarLegend(color: _purple, label: 'Completed'), _CalendarLegend(color: Color(0xFFEFEBFF), label: 'Partially', outline: true), _CalendarLegend(color: Color(0xFFD9D5E2), label: 'No Activity')]),
    ]));
  }

  Widget _dailyHabit(Habit habit, int index) {
    final completed = _isSelectedToday ? habit.done : (_isSelectedPast && index < _completedCount);
    return Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11), decoration: _calendarDecoration(), child: Row(children: [Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFFEFEBFF), borderRadius: BorderRadius.circular(14)), child: Icon(habit.icon, color: _purple, size: 22)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(habit.name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _ink, decoration: completed ? TextDecoration.lineThrough : null)), const SizedBox(height: 3), Text('${habit.detail}  â€¢  ${completed ? 'Daily Goal' : (_isSelectedPast ? 'Pending' : 'Upcoming')}', style: const TextStyle(fontSize: 9, color: _muted))])), Icon(completed ? Icons.check_circle_rounded : Icons.circle_outlined, size: 24, color: completed ? _purple : const Color(0xFFC9C4D5))]));
  }

  Widget _calendarMetric(IconData icon, String value, String label) => Container(padding: const EdgeInsets.all(10), decoration: _calendarDecoration(), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 27, height: 27, decoration: BoxDecoration(color: const Color(0xFFEFEBFF), borderRadius: BorderRadius.circular(9)), child: Icon(icon, size: 16, color: _purple)), const SizedBox(height: 7), Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _ink)), Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 9, color: _muted))]));

  Widget _calendarPill(String text) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFEFEBFF), borderRadius: BorderRadius.circular(20)), child: Text(text, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: _purple)));

  BoxDecoration _calendarDecoration() => BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFEAE7F0)), boxShadow: const [BoxShadow(color: Color(0x0A5949C0), blurRadius: 9, offset: Offset(0, 2))]);
}

class _CalendarLegend extends StatelessWidget {
  const _CalendarLegend({required this.color, required this.label, this.outline = false});
  final Color color;
  final String label;
  final bool outline;
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 9, height: 9, decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: outline ? Border.all(color: _purple) : null)), const SizedBox(width: 5), Text(label, style: const TextStyle(fontSize: 9, color: _muted))]);
}

