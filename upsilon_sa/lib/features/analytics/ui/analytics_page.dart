import 'package:flutter/material.dart';


class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});
  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Analytics", style: TextStyle(color: Colors.lightGreenAccent)),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      body: Container(
        child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Column(
          children: [
            Card(
              color: Colors.black87,
              child: Text(
                  "My Recent Systems",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.lightGreenAccent,
                      fontWeight: FontWeight.bold
                  )
              ),
            )
          ],
        ),]
    ),
      ),
    );

  }

}