# Stage 5 — Track C: Daily Reminder

## Today's goal
Add a Settings screen with a toggle that enables a daily local notification reminding the user to write a memory.

## What the app will look like at the end
A settings icon in the AppBar opens a Settings screen. There, a switch turns the daily reminder on/off. When enabled, the device sends a notification at the selected time every day — even when the app is closed.

## Minimum required outcome (checkpoint)
- [ ] A Settings screen is accessible from the AppBar
- [ ] The screen has a toggle (switch) for enabling/disabling the reminder
- [ ] Toggling on schedules a daily notification
- [ ] The notification arrives at the configured time (test on a device or emulator)

---

## Step-by-step guide

### Step 1: Platform setup

**Android** — open `starter/android/app/src/main/AndroidManifest.xml` and add inside `<manifest>`:
```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
```

And inside `<application>`:
```xml
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver"/>
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
    </intent-filter>
</receiver>
```

**iOS** — open `starter/ios/Runner/Info.plist` and add:
```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

> **Note:** On iOS, you need **iOS 16 Simulator or newer** (Xcode 14+) for local notifications to work. Older simulators did not support them. Android emulator works regardless of version.

---

### Step 2: Initialize notifications in main.dart
Update `main()` to initialize the notifications plugin before the app starts:

```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required before async setup

  // Initialize timezone data
  tz.initializeTimeZones();

  // Initialize the notifications plugin
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings();
  await notificationsPlugin.initialize(
    const InitializationSettings(android: androidSettings, iOS: iosSettings),
  );

  runApp(const MemoryCardsApp());
}
```

---

### Step 3: Create the settings screen
Create `lib/screens/settings_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../main.dart'; // to access notificationsPlugin

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _reminderEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 0);

  void _toggleReminder(bool enabled) {
    setState(() => _reminderEnabled = enabled);
    if (enabled) {
      _scheduleReminder();
    } else {
      _cancelReminder();
    }
  }

  Future<void> _scheduleReminder() async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      _reminderTime.hour,
      _reminderTime.minute,
    );
    // If the time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await notificationsPlugin.zonedSchedule(
      0, // notification ID
      'Memory Cards',
      'Time to write today\'s memory! ✨',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Daily Reminder',
          channelDescription: 'Reminds you to write a memory each day',
          importance: Importance.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily at this time
    );
  }

  Future<void> _cancelReminder() async {
    await notificationsPlugin.cancel(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Daily reminder'),
            subtitle: Text(
              _reminderEnabled
                  ? 'Reminder set for ${_reminderTime.format(context)}'
                  : 'Off',
            ),
            value: _reminderEnabled,
            onChanged: _toggleReminder,
          ),
          if (_reminderEnabled)
            ListTile(
              title: const Text('Reminder time'),
              trailing: Text(_reminderTime.format(context)),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: _reminderTime,
                );
                if (picked != null) {
                  setState(() => _reminderTime = picked);
                  _scheduleReminder(); // Reschedule with new time
                }
              },
            ),
        ],
      ),
    );
  }
}
```

---

### Step 4: Add the settings button to the AppBar
In `home_screen.dart`, add an actions button to navigate to the Settings screen:

```dart
appBar: AppBar(
  title: const Text('Memory Cards'),
  actions: [
    IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsScreen()),
        );
      },
    ),
  ],
),
```

Import at the top:
```dart
import 'settings_screen.dart';
```

---

## Optional extensions
- Save the reminder state to `shared_preferences` so it persists after app restart
- Add the ability to set multiple reminders (morning + evening)
- When the notification is tapped, open the app directly to the Create Entry screen
- Show a preview of the next scheduled notification time in the Settings screen

---

## Useful Flutter widgets/functions today

| Widget / concept | What it does |
|---|---|
| `FlutterLocalNotificationsPlugin` | Manages local push notifications |
| `notificationsPlugin.zonedSchedule(...)` | Schedules a notification at a specific time |
| `DateTimeComponents.time` | Makes the notification repeat at the same time every day |
| `notificationsPlugin.cancel(id)` | Cancels a scheduled notification |
| `SwitchListTile` | A `ListTile` with a toggle switch on the right |
| `showTimePicker(...)` | Opens the system time picker dialog |
| `TimeOfDay` | Represents a time of day (hour + minute) |
| `WidgetsFlutterBinding.ensureInitialized()` | Required before any async code in `main()` |
| `tz.TZDateTime` | A DateTime with timezone info (required for scheduling) |
