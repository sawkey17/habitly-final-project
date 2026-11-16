part of '../main.dart';

class HabitHomePage extends StatefulWidget {
  const HabitHomePage({super.key});

  @override
  State<HabitHomePage> createState() => _HabitHomePageState();
}

class _HabitHomePageState extends State<HabitHomePage> {
  final List<Habit> _habits = [
    Habit('Read Books', '30 minutes', Icons.menu_book_rounded, _purple, done: true, category: 'Learning', frequency: 'Daily'),
    Habit('Drink Water', '8 glasses', Icons.water_drop_rounded, const Color(0xFF3486D8), done: true, category: 'Health', frequency: 'Daily'),
    Habit('Morning Exercise', '20 minutes', Icons.fitness_center_rounded, const Color(0xFF23966B), done: true, category: 'Health', frequency: 'Mon, Wed, Fri', days: const [1, 3, 5]),
    Habit('Learn English', '15 minutes', Icons.translate_rounded, const Color(0xFF7657C8), category: 'Learning', frequency: 'Daily'),
    Habit('Morning Prayer', 'Daily', Icons.auto_awesome_rounded, const Color(0xFFD78B22), category: 'Lifestyle', frequency: 'Daily'),
    Habit('Practice Coding', '45 minutes', Icons.terminal_rounded, const Color(0xFF3486D8), category: 'Productivity', frequency: 'Mon to Fri', days: const [1, 2, 3, 4, 5]),
  ];
  int _selectedTab = 0;

  int get _completed => _habits.where((habit) => habit.done).length;

  Future<void> _addHabit() async {
    final habit = await Navigator.of(context).push<Habit>(MaterialPageRoute(builder: (_) => const CreateHabitPage()));
    if (habit != null && mounted) setState(() => _habits.add(habit));
  }

  @override
  Widget build(BuildContext context) {
    final progress = _habits.isEmpty ? 0.0 : _completed / _habits.length;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildStreakCard(),
                  const SizedBox(height: 14),
                  _buildProgressCard(progress),
                  const SizedBox(height: 22),
                  _buildHabitsHeader(),
                  const SizedBox(height: 11),
                  ..._habits.asMap().entries.map((entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 9),
                        child: _buildHabitTile(entry.value, entry.key),
                      )),
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addHabit,
        backgroundColor: _purple,
        foregroundColor: Colors.white,
        elevation: 5,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() => Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE8E2FF),
              border: Border.all(color: const Color(0xFFC7BFFF), width: 2),
            ),
            child: const Icon(Icons.person_rounded, color: _purple, size: 28),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Good Morning, Alex!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _ink)),
              SizedBox(height: 3),
              Text("Let's make today count.", style: TextStyle(fontSize: 12, color: _muted)),
            ]),
          ),
          IconButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Kamu tidak punya pengingat baru.')),
            ),
            icon: const Icon(Icons.notifications_none_rounded, color: _ink, size: 26),
          ),
        ],
      );

  Widget _buildStreakCard() => _card(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: const Color(0xFFFFF2E5), borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.local_fire_department_rounded, color: Color(0xFFF29C38), size: 27),
            ),
            const SizedBox(width: 11),
            const Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
                  Text('7 Days', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: _ink)),
                  SizedBox(width: 7),
                  Text('STREAK', style: TextStyle(fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.w700, color: _purple)),
                ]),
                SizedBox(height: 3),
                Text('Keep your consistency going!', style: TextStyle(fontSize: 11, color: _muted)),
              ]),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: const Color(0xFFF0EDFF), borderRadius: BorderRadius.circular(20)),
              child: const Text('Top 5%', style: TextStyle(color: _purple, fontSize: 10, fontWeight: FontWeight.w700)),
            ),
          ]),
          const Padding(padding: EdgeInsets.symmetric(vertical: 13), child: Divider(height: 1, color: Color(0xFFF0EEF5))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
              final today = index == 6;
              return Column(children: [
                Text(labels[index], style: TextStyle(fontSize: 10, color: today ? _purple : _muted, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: today ? const Color(0xFFF0EDFF) : _purple,
                    shape: BoxShape.circle,
                    border: today ? Border.all(color: _purple, width: 1.5) : null,
                  ),
                  child: Icon(today ? Icons.circle : Icons.check_rounded, size: today ? 7 : 15, color: today ? _purple : Colors.white),
                ),
              ]);
            }),
          ),
        ]),
      );

  Widget _buildProgressCard(double progress) => _card(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Expanded(child: Text("Today's Progress", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _ink))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: const Color(0xFFEAE6FA), borderRadius: BorderRadius.circular(20)),
              child: Text('$_completed of ${_habits.length} done', style: const TextStyle(fontSize: 11, color: _purple, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            SizedBox(
              width: 88,
              height: 88,
              child: Stack(alignment: Alignment.center, children: [
                SizedBox.expand(child: CircularProgressIndicator(value: progress, strokeWidth: 7, strokeCap: StrokeCap.round, backgroundColor: const Color(0xFFECE9F5), color: _purple)),
                Column(mainAxisSize: MainAxisSize.min, children: [
                  Text('${(progress * 100).round()}%', style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700, color: _ink)),
                  const Text('DONE', style: TextStyle(fontSize: 9, letterSpacing: 1, color: _muted, fontWeight: FontWeight.w600)),
                ]),
              ]),
            ),
            const SizedBox(width: 17),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [Icon(Icons.star_rounded, color: _purple, size: 17), SizedBox(width: 4), Expanded(child: Text("You're doing great today!", style: TextStyle(fontSize: 12, color: _purple, fontWeight: FontWeight.w700)))]),
              const SizedBox(height: 7),
              Text('Complete ${_habits.length - _completed} more habits to reach your daily goal.', style: const TextStyle(fontSize: 11, height: 1.4, color: _muted)),
              const SizedBox(height: 10),
              ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: progress, minHeight: 6, backgroundColor: const Color(0xFFECE9F5), color: _purple)),
            ])),
          ]),
        ]),
      );

  Widget _buildHabitsHeader() => Row(children: [
        const Text("Today's Habits", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: _ink)),
        const SizedBox(width: 9),
        Container(
          width: 21,
          height: 21,
          alignment: Alignment.center,
          decoration: const BoxDecoration(color: Color(0xFFEAE6FA), shape: BoxShape.circle),
          child: Text('${_habits.length}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _purple)),
        ),
        const Spacer(),
        TextButton(onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => MyHabitsPage(habits: _habits)));
          if (mounted) setState(() {});
        }, child: const Text('See All', style: TextStyle(fontSize: 12, color: _purple, fontWeight: FontWeight.w700))),
      ]);

  Widget _buildHabitTile(Habit habit, int index) => InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (_) => HabitDetailsPage(habit: habit),
          ));
          if (mounted) setState(() {});
        },
        child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
        decoration: BoxDecoration(
          color: habit.done ? const Color(0xFFF6F3FF) : Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: habit.done ? const Color(0xFFE4DFFF) : const Color(0xFFEAE7F0)),
          boxShadow: const [BoxShadow(color: Color(0x0B5949C0), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Row(children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: habit.color.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(13)),
            child: Icon(habit.icon, color: habit.color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(habit.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: habit.done ? _muted : _ink, decoration: habit.done ? TextDecoration.lineThrough : null)),
            const SizedBox(height: 4),
            Text(habit.detail, style: const TextStyle(fontSize: 11, color: _muted)),
          ])),
          const SizedBox(width: 10),
          Semantics(
            label: habit.done ? 'Batalkan ${habit.name}' : 'Tandai ${habit.name} selesai',
            button: true,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => setState(() => _habits[index].done = !_habits[index].done),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 29,
                height: 29,
                decoration: BoxDecoration(color: habit.done ? _purple : Colors.transparent, shape: BoxShape.circle, border: Border.all(color: habit.done ? _purple : const Color(0xFFD6D2E0), width: 2)),
                child: habit.done ? const Icon(Icons.check_rounded, size: 18, color: Colors.white) : null,
              ),
            ),
          ),
        ]),
        ),
      );

  Widget _buildBottomNav() {
    const items = [
      (Icons.home_rounded, 'Home'),
      (Icons.explore_rounded, 'Explore'),
      (Icons.insights_rounded, 'Statistics'),
      (Icons.person_rounded, 'Profile'),
    ];
    return Container(
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Color(0x101A192F), blurRadius: 12, offset: Offset(0, -3))]),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final selected = index == _selectedTab;
              return InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () async {
                  if (index == 1) {
                    await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => MyHabitsPage(habits: _habits)));
                    if (mounted) setState(() {});
                  } else if (index == 2) {
                    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => StatisticsPage(habits: _habits)));
                  } else if (index == 3) {
                    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ProfilePage(habits: _habits)));
                  } else {
                    setState(() => _selectedTab = index);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(color: selected ? const Color(0xFFEAE6FA) : Colors.transparent, borderRadius: BorderRadius.circular(24)),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(items[index].$1, size: 21, color: selected ? _purple : _muted),
                    const SizedBox(height: 2),
                    Text(items[index].$2, style: TextStyle(fontSize: 10, fontWeight: selected ? FontWeight.w700 : FontWeight.w500, color: selected ? _purple : _muted)),
                  ]),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _card({required Widget child, required EdgeInsets padding}) => Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFEAE7F0)),
          boxShadow: const [BoxShadow(color: Color(0x0B5949C0), blurRadius: 12, offset: Offset(0, 3))],
        ),
        child: child,
      );
}

