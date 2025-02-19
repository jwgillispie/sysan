import 'package:flutter/material.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
 
  @override

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // leading:
          title: Text("LeaderboardPage",
              style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: const Text("LeaderboardPage"),
      ),
    );

  }
}