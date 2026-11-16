part of '../main.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key, required this.habits});
  final List<Habit> habits;

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  String _range = 'Month';
  static const _inkColor = Color(0xFF1A192F);
  static const _mutedColor = Color(0xFF747184);

  @override
  Widget build(BuildContext context) {
    final rangeLabel = _range == 'Week' ? 'This week' : _range == 'Year' ? '2026' : 'November 2026';
    return Scaffold(
      body: SafeArea(bottom: false, child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(20, 12, 20, 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [const CircleAvatar(radius: 18, backgroundColor: Color(0xFFEAE6FA), child: Icon(Icons.person_rounded, color: _purple, size: 21)), const SizedBox(width: 10), const Text('Habitly', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _inkColor)), const Spacer(), IconButton(tooltip: 'Activity Calendar', onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ActivityCalendarPage(habits: widget.habits))), icon: const Icon(Icons.calendar_month_rounded, color: _purple)), IconButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kamu tidak punya pengingat baru.'))), icon: const Icon(Icons.notifications_none_rounded, color: _mutedColor))]),
        const SizedBox(height: 10),
        Row(children: [const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Your Statistics', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700, color: _inkColor)), SizedBox(height: 3), Text("See how far you've come.", style: TextStyle(fontSize: 12, color: _mutedColor))])), Text(rangeLabel, style: const TextStyle(fontSize: 11, color: _inkColor)), const Icon(Icons.expand_more_rounded, size: 19, color: _mutedColor)]),
        const SizedBox(height: 14),
        Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: const Color(0xFFEFEBFF), borderRadius: BorderRadius.circular(24)), child: Row(children: ['Week', 'Month', 'Year'].map((range) { final selected = _range == range; return Expanded(child: GestureDetector(onTap: () => setState(() => _range = range), child: AnimatedContainer(duration: const Duration(milliseconds: 160), padding: const EdgeInsets.symmetric(vertical: 9), decoration: BoxDecoration(color: selected ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(20), boxShadow: selected ? const [BoxShadow(color: Color(0x145949C0), blurRadius: 8, offset: Offset(0, 2))] : null), alignment: Alignment.center, child: Text(range, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? _purple : _mutedColor))))); }).toList())),
        const SizedBox(height: 16),
        _statCard(child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: const Color(0xFFEAE6FA), borderRadius: BorderRadius.circular(20)), child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.trending_up_rounded, size: 14, color: _purple), SizedBox(width: 4), Text('Overall Score', style: TextStyle(fontSize: 10, color: _purple, fontWeight: FontWeight.w600))])), const SizedBox(height: 11), const Text('78%', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: _inkColor)), Text('$_range completion rate', style: const TextStyle(fontSize: 10, color: _mutedColor)), const SizedBox(height: 11), Row(children: [const _MiniStat(value: '124', label: 'Completed'), Container(width: 1, height: 29, margin: const EdgeInsets.symmetric(horizontal: 13), color: const Color(0xFFEAE7F0)), _MiniStat(value: '${widget.habits.length}', label: 'Active Habits')])])), const SizedBox(width: 8), SizedBox(width: 94, height: 94, child: Stack(alignment: Alignment.center, children: [const SizedBox.expand(child: CircularProgressIndicator(value: .78, strokeWidth: 9, backgroundColor: Color(0xFFEFEBFF), color: Color(0xFF7263DB), strokeCap: StrokeCap.round)), Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.task_alt_rounded, size: 24, color: _purple), Text('Good', style: TextStyle(fontSize: 10, color: _mutedColor))])]))])),
        const SizedBox(height: 14),
        _statCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Weekly Activity', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _inkColor)), const SizedBox(height: 2), const Text('Avg 5.2 habits / day', style: TextStyle(fontSize: 11, color: _mutedColor)), const SizedBox(height: 14), const SizedBox(height: 125, child: _WeeklyBars()), const SizedBox(height: 6)])),
        const SizedBox(height: 14),
        _statCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Monthly Overview', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _inkColor)), const SizedBox(height: 2), Text(rangeLabel, style: const TextStyle(fontSize: 11, color: _mutedColor)), const SizedBox(height: 12), const SizedBox(height: 82, child: _TrendChart()), const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('W1', style: TextStyle(fontSize: 10, color: _mutedColor)), Text('W2', style: TextStyle(fontSize: 10, color: _mutedColor)), Text('W3', style: TextStyle(fontSize: 10, color: _mutedColor)), Text('W4', style: TextStyle(fontSize: 10, color: _purple, fontWeight: FontWeight.w700))])])),
        const SizedBox(height: 14),
        Row(children: [Expanded(child: _statCard(child: const _StreakMetric(title: 'Current Streak', value: '7 Days', subtitle: 'Keep it burning!', icon: Icons.local_fire_department_rounded))), const SizedBox(width: 10), Expanded(child: _statCard(child: const _StreakMetric(title: 'Longest Streak', value: '21 Days', subtitle: 'Personal best', icon: Icons.military_tech_rounded)))]),
        const SizedBox(height: 14),
        _statCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Row(children: [Expanded(child: Text('Most Consistent Habit', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _purple))), Text('Top Performer â­', style: TextStyle(fontSize: 9, color: _purple))]), const SizedBox(height: 14), Row(children: [Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFFEAE6FA), borderRadius: BorderRadius.circular(13)), child: const Icon(Icons.menu_book_rounded, color: _purple)), const SizedBox(width: 10), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Read Books', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _inkColor)), Text('Completed 28 of 30 days', style: TextStyle(fontSize: 10, color: _mutedColor))])), const Text('92%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _purple))]), const SizedBox(height: 12), const ClipRRect(borderRadius: BorderRadius.all(Radius.circular(9)), child: LinearProgressIndicator(value: .92, minHeight: 8, backgroundColor: Color(0xFFEFEBFF), color: Color(0xFF7263DB)))])),
        const SizedBox(height: 14),
        _statCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Category Performance', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _inkColor)), const SizedBox(height: 14), const _CategoryBar(label: 'Health', value: .85, icon: Icons.favorite_rounded), SizedBox(height: 12), const _CategoryBar(label: 'Learning', value: .92, icon: Icons.school_rounded), SizedBox(height: 12), const _CategoryBar(label: 'Productivity', value: .74, icon: Icons.bolt_rounded), SizedBox(height: 12), const _CategoryBar(label: 'Lifestyle', value: .68, icon: Icons.spa_rounded)])),
        const SizedBox(height: 20),
      ]))),
      bottomNavigationBar: NavigationBar(height: 65, selectedIndex: 2, onDestinationSelected: (index) { if (index == 0) { Navigator.of(context).popUntil((route) => route.isFirst); } else if (index == 1) { Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => MyHabitsPage(habits: widget.habits))); } else if (index == 3) { Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ProfilePage(habits: widget.habits))); } }, destinations: const [NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'), NavigationDestination(icon: Icon(Icons.explore_rounded), label: 'Explore'), NavigationDestination(icon: Icon(Icons.insights_rounded), label: 'Statistics'), NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profile')]),
    );
  }

  Widget _statCard({required Widget child}) => Container(width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0xFFEAE7F0)), boxShadow: const [BoxShadow(color: Color(0x0B5949C0), blurRadius: 10, offset: Offset(0, 2))]), child: child);
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.value, required this.label});
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _purple)), Text(label, style: const TextStyle(fontSize: 9, color: Color(0xFF747184)))]);
}

class _StreakMetric extends StatelessWidget {
  const _StreakMetric({required this.title, required this.value, required this.subtitle, required this.icon});
  final String title, value, subtitle;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Expanded(child: Text(title, style: const TextStyle(fontSize: 10, color: Color(0xFF747184)))), Icon(icon, color: _purple, size: 18)]), const SizedBox(height: 12), Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A192F))), Text(subtitle, style: const TextStyle(fontSize: 9, color: Color(0xFF747184)))]);
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({required this.label, required this.value, required this.icon});
  final String label;
  final double value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            children: [
              Icon(icon, color: _purple, size: 16),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A192F),
                  ),
                ),
              ),
              Text(
                '${(value * 100).round()}%',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A192F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 7,
              backgroundColor: const Color(0xFFEFEBFF),
              color: const Color(0xFF7263DB),
            ),
          ),
        ],
      );
}

class _WeeklyBars extends StatelessWidget {
  const _WeeklyBars();
  @override
  Widget build(BuildContext context) {
    const values = [5, 6, 4, 6, 5, 4, 3];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(7, (index) {
        final highlight = index == 3;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('${values[index]}', style: TextStyle(fontSize: 9, color: highlight ? _purple : const Color(0xFF747184), fontWeight: highlight ? FontWeight.w700 : FontWeight.normal)),
                const SizedBox(height: 4),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 18,
                      height: 80 * values[index] / 8,
                      decoration: BoxDecoration(color: highlight ? const Color(0xFF7263DB) : const Color(0xFFE3DFFD), borderRadius: const BorderRadius.vertical(top: Radius.circular(7))),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(days[index], style: TextStyle(fontSize: 8, color: highlight ? _purple : const Color(0xFF747184), fontWeight: highlight ? FontWeight.w700 : FontWeight.normal)),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _TrendChart extends StatelessWidget {
  const _TrendChart();
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _TrendPainter(), child: const SizedBox.expand());
}

class _TrendPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final points = [Offset(0, size.height * .78), Offset(size.width * .25, size.height * .52), Offset(size.width * .5, size.height * .4), Offset(size.width * .75, size.height * .22), Offset(size.width, size.height * .12)];
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) { final previous = points[i - 1], current = points[i]; path.quadraticBezierTo((previous.dx + current.dx) / 2, previous.dy, current.dx, current.dy); }
    final linePaint = Paint()..color = const Color(0xFF7263DB)..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);
    for (var i = 1; i < points.length; i++) { canvas.drawCircle(points[i], i == points.length - 1 ? 4 : 3, Paint()..color = _purple); canvas.drawCircle(points[i], i == points.length - 1 ? 2 : 1.5, Paint()..color = Colors.white); }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

