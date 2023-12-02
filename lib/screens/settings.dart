import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/providers/dialogBoxProvider.dart';
import 'package:to_do_app/providers/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  //initailzer variables
  List<String> languages = [
    "English",
    "Spanish",
    "French",
    "Japanese",
    "Dutch",
  ];

  bool isNotifications = false;
  bool isLightMode = true;
  String selectedTimeValue = '';
  String firstDayOfTheWeek = '';
  String language = 'Select Language';

  //setter and getter methods
  void updateFirstDayOfTheWeek(String value) {
    ref.read(firstDayOfTheWeekProvider.notifier).setFirstDayOfTheWeek(value);
  }

  void updateSelectedTimeValue(String value) {
    ref.read(timeValueProvider.notifier).setTimeValue(value);
  }

  void changeMode(bool item) {
    ref.read(settingsProvider.notifier).changeLightMode(item);
  }

  void changeListTile(bool item) {
    ref.read(settingsProvider.notifier).changeNotifications(item);
  }

  void showTimeFormatDialogBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Time Format'),
        content: Consumer(
          builder: (context, ref, child) {
            selectedTimeValue = ref.watch(timeValueProvider);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: const Text("12-hour"),
                  value: '12-hour',
                  groupValue: selectedTimeValue,
                  onChanged: (value) {
                    updateSelectedTimeValue(value!);
                  },
                ),
                RadioListTile<String>(
                  title: const Text("24-hour"),
                  value: '24-hour',
                  groupValue: selectedTimeValue,
                  onChanged: (value) {
                    updateSelectedTimeValue(value!);
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void chooseFirstWeekDialogBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Week:'),
        content: Consumer(builder: (context, ref, child) {
          firstDayOfTheWeek = ref.watch(firstDayOfTheWeekProvider);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text("Sunday"),
                value: 'Sunday',
                groupValue: firstDayOfTheWeek,
                onChanged: (value) {
                  updateFirstDayOfTheWeek(value!);
                },
              ),
              RadioListTile<String>(
                title: const Text("Monday"),
                value: 'Monday',
                groupValue: firstDayOfTheWeek,
                onChanged: (value) {
                  updateFirstDayOfTheWeek(value!);
                },
              ),
              RadioListTile<String>(
                title: const Text("Saturday"),
                value: 'Saturday',
                groupValue: firstDayOfTheWeek,
                onChanged: (value) {
                  updateFirstDayOfTheWeek(value!);
                },
              ),
            ],
          );
        }),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //listens to changes in the state of the provider and updates the variables accordingly
    selectedTimeValue = ref.watch(timeValueProvider);
    firstDayOfTheWeek = ref.watch(firstDayOfTheWeekProvider);
    isNotifications = ref.watch(settingsProvider).isNotifications;
    isLightMode = ref.watch(settingsProvider).isLightMode;
    final theme = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10)),
              width: 400,
              height: 60,
              child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 12, bottom: 8),
                child: Row(
                  children: [
                    Text(
                      'Change Mode',
                      style: TextStyle(
                        color: theme.isLightMode == true
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          changeMode(!isLightMode);
                        },
                        icon: Icon(
                            isLightMode ? Icons.brightness_2 : Icons.sunny)),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10)),
              width: 400,
              height: 60,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text(
                      'Notifications',
                      style: TextStyle(
                        color: theme.isLightMode == true
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 160,
                    ),
                    Expanded(
                        child: SwitchListTile(
                            value: isNotifications,
                            onChanged: (value) {
                              changeListTile(value);
                            }))
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10)),
              width: 400,
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(
                      language,
                      style: TextStyle(
                        color: theme.isLightMode == true
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    const Spacer(),
                    DropdownButtonHideUnderline(
                        child: DropdownButton(
                            items: languages
                                .map((item) => DropdownMenuItem<String>(
                                    value: item, child: Text(item)))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                language = value!;
                              });
                            })),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {},
              child: Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10)),
                  width: 400,
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      'Check for Updates',
                      style: TextStyle(
                        color: theme.isLightMode == true
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  )),
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {},
              child: Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10)),
                  width: 400,
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      'Remove  Ads',
                      style: TextStyle(
                        color: theme.isLightMode == true
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: showTimeFormatDialogBox,
              child: Container(
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10)),
                width: 400,
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 12, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Time Format',
                        style: TextStyle(
                          color: theme.isLightMode == true
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                      Text(selectedTimeValue)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
