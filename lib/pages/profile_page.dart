part of '../main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.habits});
  final List<Habit> habits;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = 'Alex Johnson';
  String _email = 'alex.johnson@email.com';

  Future<void> _editProfile() async {
    final nameController = TextEditingController(text: _name);
    final emailController = TextEditingController(text: _email);
    final result = await showDialog<(String, String)>(context: context, builder: (context) => AlertDialog(title: const Text('Edit Profile'), content: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')), TextField(controller: emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email'))]), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(context, (nameController.text.trim(), emailController.text.trim())), child: const Text('Save'))]));
    nameController.dispose();
    emailController.dispose();
    if (result != null && result.$1.isNotEmpty && mounted) setState(() { _name = result.$1; _email = result.$2; });
  }

  @override
  Widget build(BuildContext context) {
    final habits = widget.habits;
    final completed = habits.where((habit) => habit.done).length;
    return Scaffold(
      body: SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 28), children: [
        Row(children: [Expanded(child: Text('My Profile', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: _ink))), IconButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kamu tidak punya notifikasi baru.'))), icon: const Icon(Icons.notifications_none_rounded, color: _muted))]),
        const SizedBox(height: 8),
        Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26), border: Border.all(color: const Color(0xFFEAE7F0)), boxShadow: const [BoxShadow(color: Color(0x0A5949C0), blurRadius: 12, offset: Offset(0, 3))]), child: Column(children: [
          Container(padding: const EdgeInsets.all(3), decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [_purple, Color(0xFFE4E0F4)])), child: const CircleAvatar(radius: 44, backgroundColor: Color(0xFFEAE6FA), child: Icon(Icons.person_rounded, size: 48, color: _purple))),
          const SizedBox(height: 12), Row(mainAxisAlignment: MainAxisAlignment.center, children: [Flexible(child: Text(_name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: _ink), overflow: TextOverflow.ellipsis)), const SizedBox(width: 7), const Icon(Icons.stars_rounded, size: 17, color: _purple), const Text('Pro Member', style: TextStyle(fontSize: 10, color: _purple, fontWeight: FontWeight.w600))]),
          const SizedBox(height: 3), Text(_email, style: const TextStyle(fontSize: 12, color: _muted)),
          const SizedBox(height: 12), OutlinedButton.icon(onPressed: _editProfile, icon: const Icon(Icons.edit_rounded, size: 16), label: const Text('Edit Profile')),
        ])),
        const SizedBox(height: 14),
        Row(children: [Expanded(child: _metric('${habits.length}', 'Total Habits')), const SizedBox(width: 8), Expanded(child: _metric('$completed', 'Completed')), const SizedBox(width: 8), Expanded(child: _metric('7 Days', 'Current Streak'))]),
        const SizedBox(height: 20), const Text('Personal Information', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _muted)),
        _card(Column(children: [ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.person_outline, color: _purple), title: const Text('Full Name', style: TextStyle(fontSize: 12, color: _muted)), subtitle: Text(_name, style: const TextStyle(fontSize: 14, color: _ink)), trailing: const Icon(Icons.chevron_right, color: _muted), onTap: _editProfile), const Divider(height: 1), ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.mail_outline, color: _purple), title: const Text('Email Address', style: TextStyle(fontSize: 12, color: _muted)), subtitle: Text(_email, style: const TextStyle(fontSize: 14, color: _ink)), trailing: const Icon(Icons.verified, size: 17, color: _purple), onTap: _editProfile), const Divider(height: 1), _ProfileSetting(icon: Icons.lock_reset_rounded, title: 'Account Information', subtitle: 'Manage login & security', onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => AccountInformationPage(name: _name, email: _email)))) ])),
        const SizedBox(height: 18), const Text('Appearance', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _muted)),
        _card(Row(children: [Expanded(child: GestureDetector(onTap: () => _themeMode.value = ThemeMode.light, child: _appearanceOption('Light Mode', _themeMode.value == ThemeMode.light))), const SizedBox(width: 10), Expanded(child: GestureDetector(onTap: () => _themeMode.value = ThemeMode.dark, child: _appearanceOption('Dark Mode', _themeMode.value == ThemeMode.dark)))])),
        const SizedBox(height: 14),
        OutlinedButton.icon(onPressed: () => showDialog<void>(context: context, builder: (ctx) => AlertDialog(title: const Text('Log out of Habitly?'), content: const Text('Are you sure you want to log out? Your habit data remains safely backed up.'), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(ctx), child: const Text('Yes, Log Out'))])), icon: const Icon(Icons.logout_rounded), label: const Text('Log Out'), style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFBA1A1A), side: const BorderSide(color: Color(0xFFFFDAD6)), padding: const EdgeInsets.all(14))),
      ])),
      bottomNavigationBar: NavigationBar(height: 65, selectedIndex: 3, onDestinationSelected: (index) { if (index == 0) Navigator.of(context).popUntil((route) => route.isFirst); if (index == 1) Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => MyHabitsPage(habits: habits))); if (index == 2) Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => StatisticsPage(habits: habits))); }, destinations: const [NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'), NavigationDestination(icon: Icon(Icons.explore_rounded), label: 'Explore'), NavigationDestination(icon: Icon(Icons.insights_rounded), label: 'Statistics'), NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profile')]),
    );
  }

  Widget _card(Widget child) => Container(width: double.infinity, padding: const EdgeInsets.all(16), margin: const EdgeInsets.only(top: 10), decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0xFFEAE7F0)), boxShadow: const [BoxShadow(color: Color(0x0A5949C0), blurRadius: 10, offset: Offset(0, 2))]), child: child);
  Widget _appearanceOption(String title, bool selected) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: selected ? Theme.of(context).colorScheme.surfaceContainerHighest : Theme.of(context).cardColor, borderRadius: BorderRadius.circular(15), border: Border.all(color: selected ? _purple : const Color(0xFFEAE7F0), width: selected ? 2 : 1)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(height: 46, decoration: BoxDecoration(color: title == 'Light Mode' ? const Color(0xFFFAFAFC) : const Color(0xFF1E1D2F), borderRadius: BorderRadius.circular(10)), child: Center(child: Icon(title == 'Light Mode' ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined, color: title == 'Light Mode' ? _purple : Colors.white))), const SizedBox(height: 8), Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)), Text(title == 'Light Mode' ? 'Clean lavender' : 'Dark navy', style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant))]));
  Widget _metric(String value, String label) => _card(Column(children: [const Icon(Icons.auto_awesome_rounded, color: _purple), const SizedBox(height: 5), Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _ink)), Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 9, color: _muted))]));
}

class _ProfileSetting extends StatelessWidget {
  const _ProfileSetting({required this.icon, required this.title, required this.subtitle, this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => ListTile(onTap: onTap, contentPadding: EdgeInsets.zero, leading: Icon(icon, color: _purple), title: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _ink)), subtitle: Text(subtitle, style: const TextStyle(fontSize: 10, color: _muted)), trailing: const Icon(Icons.chevron_right_rounded, color: _muted));
}

class AccountInformationPage extends StatelessWidget {
  const AccountInformationPage({super.key, required this.name, required this.email});
  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final surface = dark ? const Color(0xFF2F2E45) : Colors.white;
    final text = Theme.of(context).colorScheme.onSurface;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Scaffold(
      appBar: AppBar(title: const Text('Account Information'), backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: Theme.of(context).dividerColor)), child: Row(children: [Container(width: 48, height: 48, decoration: BoxDecoration(color: _purple.withValues(alpha: .12), shape: BoxShape.circle), child: const Icon(Icons.verified_user_outlined, color: _purple)), const SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Your account is secure', style: TextStyle(color: text, fontWeight: FontWeight.w700, fontSize: 15)), const SizedBox(height: 3), Text('Review your sign-in and security details.', style: TextStyle(color: muted, fontSize: 12))]))])),
        const SizedBox(height: 22), Text('ACCOUNT DETAILS', style: TextStyle(color: muted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)), const SizedBox(height: 9),
        Card(color: surface, child: Column(children: [_accountRow(context, Icons.person_outline, 'Account name', name), const Divider(height: 1, indent: 54), _accountRow(context, Icons.email_outlined, 'Email address', email, trailing: const Icon(Icons.verified_rounded, color: Color(0xFF23966B), size: 19)), const Divider(height: 1, indent: 54), _accountRow(context, Icons.login_rounded, 'Sign-in method', 'Email and password')])),
      ]),
    );
  }

  Widget _accountRow(BuildContext context, IconData icon, String title, String value, {Widget? trailing}) => ListTile(leading: Icon(icon, color: _purple), title: Text(title, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)), subtitle: Text(value, style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w500)), trailing: trailing);
}

