import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/providers/isSearchingProvider.dart';
import 'package:to_do_app/screens/new_items.dart';
import 'package:to_do_app/widgets/app_bar_content.dart';
import 'package:to_do_app/widgets/home_body.dart';

// enum for the settings value

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool isSearching = false;
  bool isEdited = false;
  bool isChecked = false;
  Widget body = const HomeBody();
  Widget appBarContent = const AppBarContent();

  void updateSearchingValue(bool value) {
    ref.watch(searchingProvider.notifier).setSearching(value);
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = ref.watch(searchingProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            actions: [appBarContent],
            leading: isSearching
                ? IconButton(
                    onPressed: () {
                      updateSearchingValue(!isSearching);
                    },
                    icon: const Icon(Icons.arrow_back_sharp))
                : IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.calendar_month,
                      size: 35,
                    )),
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const TasksScreen(),
                ));
              },
              child: const Icon(Icons.add)),
          body: SafeArea(child: body)),
    );
  }
}
