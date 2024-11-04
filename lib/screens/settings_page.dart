import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;

  SettingsPage(
      {required this.notificationsEnabled,
      required this.onNotificationsChanged});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _notificationsEnabled;

  @override
  void initState() {
    super.initState();
    _notificationsEnabled = widget.notificationsEnabled;
  }

  void _toggleNotifications(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
    widget.onNotificationsChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListTile(
          title: Text('Enable Health Notifications'),
          trailing: Switch(
            value: _notificationsEnabled,
            onChanged: _toggleNotifications,
          ),
        ),
      ),
    );
  }
}
