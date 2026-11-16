part of '../main.dart';

class MyHabitsPage extends StatefulWidget {
  const MyHabitsPage({super.key, required this.habits});
  final List<Habit> habits;

  @override
  State<MyHabitsPage> createState() => _MyHabitsPageState();
}

class _MyHabitsPageState extends State<MyHabitsPage> {
  final _search = TextEditingController();
  String _category = 'All';
  static const _categories = ['All', 'Health', 'Productivity', 'Learning', 'Lifestyle'];

  String _categoryOf(Habit habit) {
    return habit.category;
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final habits = widget.habits.where((habit) =>
      (_category == 'All' || _categoryOf(habit) == _category) &&
      habit.name.toLowerCase().contains(_search.text.toLowerCase())).toList();
    final done = widget.habits.where((habit) => habit.done).length;
    return Scaffold(
      body: SafeArea(bottom: false, child: CustomScrollView(slivers: [
        SliverPadding(padding: const EdgeInsets.fromLTRB(20, 14, 20, 110), sliver: SliverList(delegate: SliverChildListDelegate([
          Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [const Text('My Habits', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: _ink)), const SizedBox(width: 9), _pill('${widget.habits.length} Active')]),
            const SizedBox(height: 3), const Text('Manage your daily routines & streaks', style: TextStyle(fontSize: 12, color: _muted)),
          ])), IconButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kamu tidak punya pengingat baru.'))), icon: const Icon(Icons.notifications_none_rounded, color: _ink))]),
          const SizedBox(height: 15),
          TextField(controller: _search, onChanged: (_) => setState(() {}), decoration: InputDecoration(hintText: 'Search your habits...', prefixIcon: const Icon(Icons.search_rounded), suffixIcon: IconButton(onPressed: () {}, icon: const Icon(Icons.tune_rounded)), filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.symmetric(vertical: 5), border: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: const BorderSide(color: Color(0xFFEAE7F0))), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: const BorderSide(color: Color(0xFFEAE7F0))))),
          const SizedBox(height: 12),
          SizedBox(height: 38, child: ListView(scrollDirection: Axis.horizontal, children: _categories.map((category) {
            final count = category == 'All' ? widget.habits.length : widget.habits.where((habit) => _categoryOf(habit) == category).length;
            final selected = _category == category;
            return Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(label: Text('$category  $count'), selected: selected, onSelected: (_) => setState(() => _category = category), selectedColor: _purple, backgroundColor: Colors.white, labelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: selected ? Colors.white : _ink), side: BorderSide(color: selected ? _purple : const Color(0xFFEAE7F0))));
          }).toList())),
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFEAE7F0))), child: Row(children: [Expanded(child: _summary(widget.habits.length, 'Total')), Expanded(child: _summary(widget.habits.length, 'Active', color: _purple)), Expanded(child: _summary(done, 'Done Today', color: const Color(0xFF5F5293)))])),
          const SizedBox(height: 19),
          Row(children: [const Expanded(child: Text("Today's Schedule", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _ink))), Text('$done of ${widget.habits.length} Completed', style: const TextStyle(fontSize: 10, color: _muted))]),
          const SizedBox(height: 10),
          if (habits.isEmpty) const Padding(padding: EdgeInsets.all(24), child: Center(child: Text('No habits found', style: TextStyle(color: _muted)))),
          ...habits.map((habit) => Padding(padding: const EdgeInsets.only(bottom: 9), child: _myHabitTile(habit))),
          const SizedBox(height: 8),
          ExpansionTile(leading: const Icon(Icons.auto_awesome_rounded, color: _muted), title: const Text('Filter Preview & Tips', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)), children: const [Padding(padding: EdgeInsets.all(16), child: Text('Tap a category above or create a new mindful ritual to begin tracking today.', textAlign: TextAlign.center, style: TextStyle(color: _muted, fontSize: 12)))]),
        ])))
      ])),
      floatingActionButton: FloatingActionButton(onPressed: _addHabit, backgroundColor: _purple, foregroundColor: Colors.white, child: const Icon(Icons.add_rounded, size: 29)),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _summary(int value, String label, {Color color = _ink}) => Column(children: [Text('$value', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)), const SizedBox(height: 2), Text(label, style: const TextStyle(fontSize: 10, color: _muted))]);

  Future<void> _addHabit() async {
    final habit = await Navigator.of(context).push<Habit>(MaterialPageRoute(builder: (_) => const CreateHabitPage()));
    if (habit != null && mounted) setState(() => widget.habits.add(habit));
  }

  Widget _myHabitTile(Habit habit) => InkWell(onTap: () => setState(() => habit.done = !habit.done), borderRadius: BorderRadius.circular(16), child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: habit.done ? const Color(0xFFF3F0FF) : Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: habit.done ? const Color(0xFFD8D0FF) : const Color(0xFFEAE7F0))), child: Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFFEAE6FA), borderRadius: BorderRadius.circular(12)), child: Icon(habit.icon, color: _purple, size: 21)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Flexible(child: Text(habit.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _ink, decoration: habit.done ? TextDecoration.lineThrough : null))), const SizedBox(width: 6), _pill(_categoryOf(habit))]), const SizedBox(height: 4), Text('${habit.frequency} â€¢ ${habit.detail}', style: const TextStyle(fontSize: 10, color: _muted))])), const SizedBox(width: 8), Icon(habit.done ? Icons.check_circle_rounded : Icons.circle_outlined, color: habit.done ? _purple : const Color(0xFFC9C4D5), size: 25)])));

  Widget _pill(String text) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFEAE6FA), borderRadius: BorderRadius.circular(20)), child: Text(text, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: _purple)));

  Widget _buildBottomNav() => NavigationBar(height: 65, selectedIndex: 1, onDestinationSelected: (index) { if (index == 0) { Navigator.of(context).maybePop(); } else if (index == 2) { Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => StatisticsPage(habits: widget.habits))); } else if (index == 3) { Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ProfilePage(habits: widget.habits))); } }, destinations: const [NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'), NavigationDestination(icon: Icon(Icons.explore_rounded), label: 'Explore'), NavigationDestination(icon: Icon(Icons.insights_rounded), label: 'Statistics'), NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profile')]);
}

class HabitDetailsPage extends StatefulWidget {
  const HabitDetailsPage({super.key, required this.habit});

  final Habit habit;

  @override
  State<HabitDetailsPage> createState() => _HabitDetailsPageState();
}

class _HabitDetailsPageState extends State<HabitDetailsPage> {
  late bool _doneToday;
  late DateTime _month = DateTime.now();

  static const _weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  static const _completedDays = {0, 1, 2, 4, 5};

  @override
  void initState() {
    super.initState();
    _doneToday = widget.habit.done;
  }

  void _changeMonth(int amount) {
    setState(() => _month = DateTime(_month.year, _month.month + amount));
  }

  String get _monthTitle =>
      '${_month.monthName} ${_month.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _header()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _heroCard(),
                  const SizedBox(height: 16),
                  _statsRow(),
                  const SizedBox(height: 16),
                  _weeklyCard(),
                  const SizedBox(height: 16),
                  _calendarCard(),
                  const SizedBox(height: 20),
                  _recentActivity(),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  Widget _header() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
        child: Row(children: [
          _roundButton(Icons.arrow_back_rounded, 'Kembali', () => Navigator.pop(context)),
          const Expanded(
            child: Text('Habit Details', textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _ink)),
          ),
          _roundButton(Icons.more_vert_rounded, 'Opsi lainnya', () {
            showModalBottomSheet<void>(
              context: context,
              builder: (context) => SafeArea(
                child: ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: const Text('Edit kebiasaan'),
                  onTap: () => Navigator.pop(context),
                ),
              ),
            );
          }),
        ]),
      );

  Widget _roundButton(IconData icon, String label, VoidCallback onTap) => IconButton(
        tooltip: label,
        onPressed: onTap,
        style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: _ink),
        icon: Icon(icon, size: 21),
      );

  Widget _heroCard() => _detailCard(
        padding: const EdgeInsets.all(22),
        child: Column(children: [
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(color: const Color(0xFFEAE6FA), borderRadius: BorderRadius.circular(22)),
            child: Icon(widget.habit.icon, color: widget.habit.color, size: 39),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(color: const Color(0xFFF0EDFF), borderRadius: BorderRadius.circular(20)),
            child: Text(_category, style: const TextStyle(color: _purple, fontSize: 11, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 9),
          Text(widget.habit.name, textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700, color: _ink)),
          const SizedBox(height: 5),
          Text('Spend time building a little progress every day.', textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, height: 1.45, color: _muted)),
          const SizedBox(height: 15),
          Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center, children: [
            _specChip(Icons.repeat_rounded, 'Every day'),
            _specChip(Icons.schedule_rounded, widget.habit.detail),
          ]),
        ]),
      );

  String get _category {
    final name = widget.habit.name.toLowerCase();
    if (name.contains('read') || name.contains('learn') || name.contains('english')) return 'Learning';
    if (name.contains('exercise') || name.contains('run') || name.contains('workout')) return 'Health';
    if (name.contains('water') || name.contains('drink')) return 'Wellness';
    return 'Personal';
  }

  Widget _specChip(IconData icon, String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: const Color(0xFFF7F5FC), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFECE9F3))),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 15, color: _purple),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _muted)),
        ]),
      );

  Widget _statsRow() => Row(children: [
        _statCard(Icons.local_fire_department_rounded, const Color(0xFFEAE6FA), '7 Days', 'Current Streak'),
        const SizedBox(width: 9),
        _statCard(Icons.emoji_events_rounded, const Color(0xFFF0EDFF), '14 Days', 'Best Streak'),
        const SizedBox(width: 9),
        _statCard(Icons.check_circle_rounded, const Color(0xFFEAE6FA), '28 Days', 'Completed'),
      ]);

  Widget _statCard(IconData icon, Color tint, String value, String label) => Expanded(
        child: _detailCard(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Column(children: [
            Container(width: 31, height: 31, decoration: BoxDecoration(color: tint, shape: BoxShape.circle), child: Icon(icon, size: 18, color: _purple)),
            const SizedBox(height: 5),
            FittedBox(fit: BoxFit.scaleDown, child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _ink))),
            const SizedBox(height: 2),
            FittedBox(fit: BoxFit.scaleDown, child: Text(label, style: const TextStyle(fontSize: 9, color: _muted))),
          ]),
        ),
      );

  Widget _weeklyCard() => _detailCard(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(children: [
            const Expanded(child: Text('This Week', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _ink))),
            _pill('5 of 7 days (71%)'),
          ]),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List.generate(7, (index) {
            final completed = _completedDays.contains(index);
            final today = index == 6;
            return Column(children: [
              Text(_weekDays[index], style: TextStyle(fontSize: 11, color: today ? _purple : _muted, fontWeight: today ? FontWeight.w700 : FontWeight.w500)),
              const SizedBox(height: 7),
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: completed ? _purple : (today ? const Color(0xFFF0EDFF) : Colors.transparent),
                  shape: BoxShape.circle,
                  border: completed ? null : Border.all(color: today ? _purple : const Color(0xFFD9D5E2), width: today ? 1.7 : 1.2),
                ),
                child: completed ? const Icon(Icons.check_rounded, color: Colors.white, size: 19) : Icon(today ? Icons.circle : Icons.remove_rounded, size: today ? 7 : 15, color: today ? _purple : _muted),
              ),
            ]);
          })),
        ]),
      );

  Widget _calendarCard() {
    final firstWeekday = DateTime(_month.year, _month.month, 1).weekday - 1;
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final today = DateTime.now();
    final isCurrentMonth = today.year == _month.year && today.month == _month.month;
    final cellCount = ((firstWeekday + daysInMonth + 6) ~/ 7) * 7;
    return _detailCard(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        Row(children: [
          const Expanded(child: Text('Activity History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _ink))),
          IconButton(visualDensity: VisualDensity.compact, onPressed: () => _changeMonth(-1), icon: const Icon(Icons.chevron_left_rounded, size: 20)),
          Text(_monthTitle, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _ink)),
          IconButton(visualDensity: VisualDensity.compact, onPressed: () => _changeMonth(1), icon: const Icon(Icons.chevron_right_rounded, size: 20)),
        ]),
        const SizedBox(height: 4),
        Row(children: ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'].map((d) => Expanded(child: Center(child: Text(d, style: const TextStyle(fontSize: 10, color: _muted))))).toList()),
        const SizedBox(height: 7),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cellCount,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 5, crossAxisSpacing: 3),
          itemBuilder: (context, index) {
            final day = index - firstWeekday + 1;
            if (day < 1 || day > daysInMonth) return const SizedBox.shrink();
            final future = isCurrentMonth && day > today.day;
            final isToday = isCurrentMonth && day == today.day;
            final completed = !future && !isToday && day % 5 != 0;
            return Container(
              decoration: BoxDecoration(
                color: completed ? _purple : (isToday ? const Color(0xFFF0EDFF) : Colors.transparent),
                shape: BoxShape.circle,
                border: isToday ? Border.all(color: _purple, width: 1.6) : null,
              ),
              alignment: Alignment.center,
              child: Text('$day', style: TextStyle(fontSize: 11, color: completed ? Colors.white : (future ? const Color(0xFFB9B5C4) : (isToday ? _purple : _muted)), fontWeight: isToday || completed ? FontWeight.w600 : FontWeight.normal)),
            );
          },
        ),
        const SizedBox(height: 11),
        const Divider(height: 1, color: Color(0xFFF0EEF5)),
        const SizedBox(height: 10),
        Wrap(alignment: WrapAlignment.center, spacing: 12, runSpacing: 6, children: [
          _legend(const Color(0xFF5949C0), 'Completed'),
          _legend(Colors.white, 'Incomplete', border: true),
          _legend(const Color(0xFFF0EDFF), 'Today', border: true, borderColor: _purple),
        ]),
      ]),
    );
  }

  Widget _legend(Color color, String label, {bool border = false, Color borderColor = _muted}) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 9, height: 9, decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: border ? Border.all(color: borderColor, width: 1) : null)),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 9, color: _muted)),
      ]);

  Widget _recentActivity() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(padding: EdgeInsets.only(left: 2, bottom: 9), child: Text('Recent Activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _ink))),
        _activityTile('Today', 'Completed at 08:30 AM', widget.habit.detail),
        const SizedBox(height: 8),
        _activityTile('Yesterday', 'Completed at 09:00 AM', widget.habit.detail),
        const SizedBox(height: 8),
        _activityTile('Monday', 'Completed at 07:45 AM', widget.habit.detail),
      ]);

  Widget _activityTile(String day, String time, String detail) => _detailCard(
        padding: const EdgeInsets.all(13),
        child: Row(children: [
          Container(width: 39, height: 39, decoration: const BoxDecoration(color: Color(0xFFEAE6FA), shape: BoxShape.circle), child: const Icon(Icons.check_circle_rounded, color: _purple, size: 21)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(day, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _ink)),
            const SizedBox(height: 3),
            Text(time, style: const TextStyle(fontSize: 10, color: _muted)),
          ])),
          _pill(detail),
        ]),
      );

  Widget _pill(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(color: const Color(0xFFF0EDFF), borderRadius: BorderRadius.circular(18)),
        child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _purple)),
      );

  Widget _detailCard({required Widget child, required EdgeInsets padding}) => Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFEAE7F0)), boxShadow: const [BoxShadow(color: Color(0x0A5949C0), blurRadius: 10, offset: Offset(0, 2))]),
        child: child,
      );

  Widget _bottomBar() => Column(mainAxisSize: MainAxisSize.min, children: [
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: () {
                  setState(() => _doneToday = !_doneToday);
                  widget.habit.done = _doneToday;
                },
                style: FilledButton.styleFrom(backgroundColor: _doneToday ? const Color(0xFFEAE6FA) : _purple, foregroundColor: _doneToday ? _purple : Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                icon: Icon(_doneToday ? Icons.task_alt_rounded : Icons.check_circle_outline_rounded),
                label: Text(_doneToday ? 'Completed for Today!' : 'Mark as Completed', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Color(0x101A192F), blurRadius: 12, offset: Offset(0, -3))]),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 7, 8, 6),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _navItem(Icons.home_rounded, 'Home', true),
                _navItem(Icons.explore_rounded, 'Explore', false),
                _navItem(Icons.insights_rounded, 'Statistics', false),
                _navItem(Icons.person_rounded, 'Profile', false),
              ]),
            ),
          ),
        ),
      ]);

  Widget _navItem(IconData icon, String label, bool selected) => Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 21, color: selected ? _purple : _muted),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 9, color: selected ? _purple : _muted, fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
      ]);
}

extension on DateTime {
  String get monthName => const [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December',
      ][month - 1];
}
