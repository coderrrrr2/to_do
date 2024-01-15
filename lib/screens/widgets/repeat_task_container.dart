import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/providers/settings_provider.dart';

class TaskContainer extends ConsumerStatefulWidget {
  const TaskContainer({super.key, required this.leadingText});

  final String leadingText;

  @override
  ConsumerState<TaskContainer> createState() => _TaskContainerState();
}

class _TaskContainerState extends ConsumerState<TaskContainer> {
  @override
  Widget build(BuildContext context) {
    String selectedDays;
    bool isPressed = false;

    final theme = ref.watch(settingsProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: InkWell(
          onTap: () {
            setState(() {
              isPressed = !isPressed;
            });
          },
          child: ListTile(
              leadingAndTrailingTextStyle: const TextStyle(fontSize: 17),
              dense: true,
              textColor: theme.isLightMode ? Colors.black : Colors.white,
              leading: Text(widget.leadingText),
              trailing: isPressed == true
                  ? Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30,
                      grade: BorderSide.strokeAlignOutside,
                      fill: 20,
                    )
                  : null)),
    );
  }
}
