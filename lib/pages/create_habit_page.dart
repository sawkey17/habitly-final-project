part of '../main.dart';

class CreateHabitPage extends StatefulWidget {
  const CreateHabitPage({super.key});

  @override
  State<CreateHabitPage> createState() => _CreateHabitPageState();
}

class _CreateHabitPageState extends State<CreateHabitPage> {
  final _nameController = TextEditingController();
  String _category = 'Learning';
  IconData _icon = Icons.auto_stories_rounded;
  String _frequency = 'Every Day';
  final List<bool> _selectedDays = [true, true, true, true, true, false, false];
  int _minutes = 30;
  bool _reminder = true;

  static const _dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _dayLetters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  static const _categories = [
    ('Health', 'Vitality', Icons.favorite_rounded),
    ('Productivity', 'Focus', Icons.bolt_rounded),
    ('Learning', 'Growth', Icons.auto_stories_rounded),
    ('Lifestyle', 'Balance', Icons.spa_rounded),
  ];
  static const _icons = [
    Icons.auto_stories_rounded,
    Icons.water_drop_rounded,
    Icons.directions_run_rounded,
    Icons.self_improvement_rounded,
    Icons.psychology_rounded,
    Icons.bedtime_rounded,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveHabit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Masukkan nama kebiasaan dulu.')));
      return;
    }
    final days = _frequency == 'Every Day'
        ? List<int>.generate(7, (index) => index + 1)
        : List<int>.generate(7, (index) => index + 1).where((day) => _selectedDays[day - 1]).toList();
    if (days.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih minimal satu hari.')));
      return;
    }
    final schedule = _frequency == 'Every Day'
        ? 'Daily'
        : _frequency == 'Custom'
            ? '${days.length} days/week'
            : days.map((day) => _dayNames[day - 1]).join(', ');
    Navigator.of(context).pop(Habit(
      name,
      '$_minutes minutes',
      _icon,
      _purple,
      category: _category,
      frequency: schedule,
      days: days,
      reminder: _reminder,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(bottom: false, child: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 6, 16, 8), child: Row(children: [
          IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.chevron_left_rounded, size: 27)),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Create New Habit', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: _ink)), Text('Build a better routine, one step at a time.', style: TextStyle(fontSize: 10, color: _muted))])),
          IconButton(onPressed: () => showDialog<void>(context: context, builder: (context) => AlertDialog(title: const Text('A small tip'), content: const Text('Start with a goal that feels easy to repeat. You can build on it as your routine grows.'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Got it'))])), icon: const Icon(Icons.lightbulb_outline_rounded, color: _purple)),
        ])),
        Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(20, 4, 20, 20), children: [
          _sectionLabel('Habit Name'),
          TextField(controller: _nameController, maxLength: 30, textCapitalization: TextCapitalization.sentences, decoration: InputDecoration(prefixIcon: const Icon(Icons.edit_note_rounded, color: _purple), hintText: 'e.g. Read Books', counterText: '${_nameController.text.length}/30', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(17), borderSide: const BorderSide(color: Color(0xFFD9D5E2))), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(17), borderSide: const BorderSide(color: Color(0xFFD9D5E2))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(17), borderSide: const BorderSide(color: _purple, width: 1.5))), onChanged: (_) => setState(() {})),
          const SizedBox(height: 15),
          Row(children: [const Expanded(child: _SectionTitle('Choose Category')), TextButton(onPressed: () => _showCategoryInfo(), child: const Text('View All', style: TextStyle(fontSize: 11)))]),
          GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 2.45, children: _categories.map(_categoryCard).toList()),
          const SizedBox(height: 15),
          _sectionLabel('Choose Icon'),
          GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 6, mainAxisSpacing: 8, crossAxisSpacing: 8, children: _icons.map(_iconButton).toList()),
          const SizedBox(height: 16),
          _sectionLabel('Frequency'),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFEFEBFF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: ['Every Day', 'Specific Days', 'Custom'].map((option) {
                final selected = _frequency == option;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _frequency = option),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                      decoration: BoxDecoration(
                        color: selected ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: selected
                            ? const [BoxShadow(color: Color(0x145949C0), blurRadius: 6, offset: Offset(0, 1))]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        option,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: selected ? _purple : _muted),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          if (_frequency != 'Every Day') ...[
            const SizedBox(height: 9),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12), decoration: _formCard(), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List.generate(7, (index) => GestureDetector(onTap: () => setState(() => _selectedDays[index] = !_selectedDays[index]), child: Column(children: [AnimatedContainer(duration: const Duration(milliseconds: 120), width: 35, height: 35, alignment: Alignment.center, decoration: BoxDecoration(color: _selectedDays[index] ? _purple : const Color(0xFFEFEBFF), shape: BoxShape.circle, border: Border.all(color: _selectedDays[index] ? _purple : const Color(0xFFD9D5E2))), child: Text(_dayLetters[index], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _selectedDays[index] ? Colors.white : _muted))), const SizedBox(height: 4), Text(_dayNames[index], style: TextStyle(fontSize: 8, color: _selectedDays[index] ? _purple : _muted, fontWeight: FontWeight.w600))]))))),
          ],
          const SizedBox(height: 15),
          _sectionLabel('Daily Target'),
          Container(padding: const EdgeInsets.all(15), decoration: _formCard(), child: Column(children: [Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Duration Goal', style: TextStyle(fontSize: 11, color: _muted)), const SizedBox(height: 3), Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [Text('$_minutes', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: _ink)), const SizedBox(width: 5), const Text('minutes', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _purple))])])), IconButton(onPressed: () => setState(() => _minutes = (_minutes - 5).clamp(5, 180).toInt()), style: IconButton.styleFrom(backgroundColor: const Color(0xFFEAE6FA), foregroundColor: _purple), icon: const Icon(Icons.remove_rounded)), const SizedBox(width: 5), IconButton(onPressed: () => setState(() => _minutes = (_minutes + 5).clamp(5, 180).toInt()), style: IconButton.styleFrom(backgroundColor: _purple, foregroundColor: Colors.white), icon: const Icon(Icons.add_rounded))]), const Divider(height: 22), Row(children: [15, 30, 45, 60].map((value) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 3), child: ChoiceChip(label: Text('$value min'), selected: _minutes == value, onSelected: (_) => setState(() => _minutes = value), selectedColor: const Color(0xFFEAE6FA), labelStyle: TextStyle(fontSize: 9, color: _minutes == value ? _purple : _muted), side: BorderSide(color: _minutes == value ? _purple : Colors.transparent))))).toList())])),
          const SizedBox(height: 15),
          _sectionLabel('Set Reminder'),
          Container(padding: const EdgeInsets.all(14), decoration: _formCard(), child: Row(children: [Container(width: 39, height: 39, decoration: BoxDecoration(color: const Color(0xFFEFEBFF), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.notifications_active_rounded, color: _purple, size: 21)), const SizedBox(width: 10), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Daily Notification', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _ink)), Text('Gentle nudge to stay on streak', style: TextStyle(fontSize: 9, color: _muted))])), Switch.adaptive(value: _reminder, activeColor: _purple, onChanged: (value) => setState(() => _reminder = value))])),
        ])),
      ])),
      bottomNavigationBar: SafeArea(top: false, child: Padding(padding: const EdgeInsets.fromLTRB(20, 8, 20, 12), child: SizedBox(height: 52, child: FilledButton.icon(onPressed: _saveHabit, style: FilledButton.styleFrom(backgroundColor: _purple, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), icon: const Icon(Icons.add_rounded), label: const Text('Create Habit', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)))))),
    );
  }

  Widget _sectionLabel(String label) => Padding(padding: const EdgeInsets.only(bottom: 7), child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _ink)));
  Widget _categoryCard((String, String, IconData) item) {
    final selected = _category == item.$1;
    return InkWell(onTap: () => setState(() => _category = item.$1), borderRadius: BorderRadius.circular(14), child: AnimatedContainer(duration: const Duration(milliseconds: 130), padding: const EdgeInsets.all(9), decoration: BoxDecoration(color: selected ? const Color(0xFFEAE6FA) : Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: selected ? _purple : const Color(0xFFD9D5E2), width: selected ? 1.5 : 1)), child: Row(children: [Container(width: 35, height: 35, decoration: BoxDecoration(color: selected ? _purple : const Color(0xFFEFEBFF), borderRadius: BorderRadius.circular(11)), child: Icon(item.$3, color: selected ? Colors.white : _purple, size: 19)), const SizedBox(width: 8), Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.$1, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: selected ? _purple : _ink)), Text(item.$2, style: TextStyle(fontSize: 9, color: selected ? _purple : _muted))]))])));
  }
  Widget _iconButton(IconData icon) { final selected = _icon == icon; return InkWell(onTap: () => setState(() => _icon = icon), borderRadius: BorderRadius.circular(15), child: AnimatedContainer(duration: const Duration(milliseconds: 130), decoration: BoxDecoration(color: selected ? const Color(0xFFEAE6FA) : Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: selected ? _purple : const Color(0xFFD9D5E2), width: selected ? 1.5 : 1)), child: Icon(icon, color: selected ? _purple : _muted, size: 23))); }
  BoxDecoration _formCard() => BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17), border: Border.all(color: const Color(0xFFD9D5E2)));
  void _showCategoryInfo() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Choose the category that best fits this habit.')));
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _ink));
}

