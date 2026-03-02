# Stage 5 — Track C: Daily Reminder

## Today's goal
Add a Settings screen with a toggle that enables a daily local notification reminding the user to write a memory. The reminder state is persisted so it survives app restarts.

## What the app will look like at the end
A settings icon in the AppBar opens a Settings screen. There, a switch turns the daily reminder on/off. When enabled, the device sends a notification at the selected time every day — even when the app is closed. Reopening the app shows the correct toggle state.

## Minimum required outcome (checkpoint)
- [ ] A Settings screen is accessible from the AppBar
- [ ] The screen has a toggle (switch) for enabling/disabling the reminder
- [ ] Toggling on schedules a daily notification
- [ ] The reminder state persists after closing and reopening the app
- [ ] The notification arrives at the configured time (test on a device or emulator)

---

## Step-by-step guide

### Step 1: Platform setup

**Android** — open `starter/android/app/src/main/AndroidManifest.xml` and add inside `<manifest>` (before `<application>`):
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

**iOS** — open `starter/ios/Runner/Info.plist` and add inside `<dict>`:
```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

> **Note:** On iOS, you need **iOS 16 Simulator or newer** (Xcode 14+) for local notifications to work. Android emulator works regardless of version.

> **Note:** On Android 14+ physical devices, the `USE_EXACT_ALARM` permission may require the user to grant it manually in system settings. On emulators it's auto-granted.

---

### Step 2: Create the notification service
Instead of putting notification logic directly in `main.dart`, we'll create a clean singleton service. Create a new file: `lib/utils/notification_service.dart`

```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // Singleton: only one instance of this class will ever exist.
  // Access it anywhere with NotificationService.instance
  static final NotificationService instance = NotificationService._();
  NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();

  // SharedPreferences keys
  static const _enabledKey = 'reminder_enabled';
  static const _hourKey = 'reminder_hour';
  static const _minuteKey = 'reminder_minute';

  /// Call this once when the app starts (in main.dart)
  Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );
  }

  /// Read the saved reminder state from storage
  Future<bool> isReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_enabledKey) ?? false;
  }

  /// Read the saved reminder time from storage
  Future<({int hour, int minute})> getReminderTime() async {
    final prefs = await SharedPreferences.getInstance();
    return (
      hour: prefs.getInt(_hourKey) ?? 20,
      minute: prefs.getInt(_minuteKey) ?? 0,
    );
  }

  /// Schedule a daily reminder and save the state
  Future<void> scheduleReminder(int hour, int minute) async {
    // Save to storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, true);
    await prefs.setInt(_hourKey, hour);
    await prefs.setInt(_minuteKey, minute);

    // Calculate the next occurrence of this time
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    // If the time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      0, // notification ID
      'Memory Cards',
      'Time to write today\'s memory!',
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
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
    );
  }

  /// Cancel the reminder and save the state
  Future<void> cancelReminder() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, false);
    await _plugin.cancel(0);
  }
}
```

> **What is a Singleton?** A singleton is a class that only has one instance. We use `NotificationService.instance` to access it from anywhere — no need to pass it around or import `main.dart`.

---

### Step 3: Initialize the service in main.dart
Update `main()` to initialize the notification service before the app starts. Replace your existing `main()` function with:

```dart
import 'package:flutter/material.dart';
import 'utils/notification_service.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required before async setup
  await NotificationService.instance.init();
  runApp(const MemoryCardsApp());
}
```

> **Important:** `WidgetsFlutterBinding.ensureInitialized()` must be the first line inside `main()`. It tells Flutter "I need to do async work before running the app."

---

### Step 4: Create the settings screen
Create `lib/screens/settings_screen.dart`:

```dart
import 'package:flutter/material.dart';
import '../utils/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _reminderEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final service = NotificationService.instance;
    final enabled = await service.isReminderEnabled();
    final time = await service.getReminderTime();
    setState(() {
      _reminderEnabled = enabled;
      _reminderTime = TimeOfDay(hour: time.hour, minute: time.minute);
    });
  }

  void _toggleReminder(bool enabled) {
    setState(() => _reminderEnabled = enabled);
    if (enabled) {
      NotificationService.instance.scheduleReminder(
        _reminderTime.hour,
        _reminderTime.minute,
      );
    } else {
      NotificationService.instance.cancelReminder();
    }
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
                  NotificationService.instance.scheduleReminder(
                    picked.hour,
                    picked.minute,
                  );
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

### Step 5: Add the settings button to the AppBar
In `home_screen.dart`, add an import at the top:
```dart
import 'settings_screen.dart';
```

Then add an `actions` button to the `AppBar`:
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

---

### Step 6: Test the notification
1. Run the app and open Settings
2. Toggle the reminder on — set the time to 1–2 minutes from now
3. Close the app (stop it in the terminal)
4. Wait for the notification to arrive on the emulator/device
5. Reopen the app → the toggle should still be on and show the correct time

---

## Optional extensions
- Add the ability to set multiple reminders (morning + evening) — use different notification IDs
- When the notification is tapped, open the app directly to the Create Entry screen
- Show a preview of the next scheduled notification time ("Next reminder: today at 8:00 PM")
- Add a "Test notification" button that fires a notification immediately (great for debugging)

---

## Useful Flutter widgets/functions today

| Widget / concept | What it does |
|---|---|
| `NotificationService.instance` | Singleton — one shared instance of the notification service |
| `FlutterLocalNotificationsPlugin` | Manages local push notifications |
| `zonedSchedule(...)` | Schedules a notification at a specific time with timezone support |
| `DateTimeComponents.time` | Makes the notification repeat at the same time every day |
| `cancel(id)` | Cancels a scheduled notification |
| `SwitchListTile` | A `ListTile` with a toggle switch on the right |
| `showTimePicker(...)` | Opens the system time picker dialog |
| `TimeOfDay` | Represents a time of day (hour + minute) |
| `WidgetsFlutterBinding.ensureInitialized()` | Required before any async code in `main()` |
| `tz.TZDateTime` | A DateTime with timezone info (required for scheduling) |
| `SharedPreferences` | Persists the reminder on/off state and time across app restarts |
