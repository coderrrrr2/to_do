import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/providers/time_dialog_box_provider.dart';
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
  String language = 'Select Language';

  //setter and getter methods
  void updateTimeFormatProvierValue(String selectedTimeValue) {
    ref.read(timeFormatProvider.notifier).setTimeValue(selectedTimeValue);
    updateSettingsProviderWithSelectedTimeFormat(selectedTimeValue);
  }

  void updateSettingsProviderWithSelectedTimeFormat(String selectedTimeFormat) {
    ref.read(settingsProvider.notifier).changeTimeFormat(selectedTimeFormat);
  }

  void changeMode(bool item) {
    ref.read(settingsProvider.notifier).changeLightMode(item);
  }

  void changeListTile(bool item) {
    ref.read(settingsProvider.notifier).changeNotifications(item);
  }

  void changeLanguage(String item) {
    ref.read(settingsProvider.notifier).changeLanguage(item);
  }

  void showTimeFormatDialogBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Time Format'),
        content: Consumer(
          builder: (context, ref, child) {
            selectedTimeValue = ref.watch(timeFormatProvider);
            return Column(mainAxisSize: MainAxisSize.min, children: [
              RadioListTile<String>(
                title: const Text("12-hour"),
                value: '12-hour',
                groupValue: selectedTimeValue,
                onChanged: (value) {
                  updateTimeFormatProvierValue(value!);
                },
              ),
              RadioListTile<String>(
                title: const Text("24-hour"),
                value: '24-hour',
                groupValue: selectedTimeValue,
                onChanged: (value) {
                  updateTimeFormatProvierValue(value!);
                },
              ),
            ]);
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

  @override
  Widget build(BuildContext context) {
    //listens to changes in the state of the provider and updates the variables accordingly
    selectedTimeValue = ref.watch(timeFormatProvider);
    isNotifications = ref.watch(settingsProvider).isNotifications;
    isLightMode = ref.watch(settingsProvider).isLightMode;
    language = ref.watch(settingsProvider).chosenLanguage;
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
                        color: Colors.white,
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
                      width: 225,
                    ),
                    Expanded(
                        child: Switch.adaptive(
                            activeColor: Theme.of(context).colorScheme.primary,
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
                    Container(
                      margin: const EdgeInsets.all(6),
                      child: Text(
                        language,
                        style: TextStyle(
                          color: theme.isLightMode == true
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    DropdownButtonHideUnderline(
                        child: DropdownButton(
                            iconEnabledColor: Colors.white,
                            dropdownColor: theme.isLightMode == true
                                ? Colors.white
                                : Colors.black,
                            items: languages
                                .map((item) => DropdownMenuItem<String>(
                                    value: item, child: Text(item)))
                                .toList(),
                            onChanged: (value) {
                              changeLanguage(value!);
                              setState(() {
                                language = value;
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
                  child: Container(
                    margin: const EdgeInsets.only(left: 6, right: 6),
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
                        Text(
                          selectedTimeValue,
                          style: TextStyle(
                            color: theme.isLightMode == true
                                ? Colors.black
                                : Colors.white,
                          ),
                        )
                      ],
                    ),
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
