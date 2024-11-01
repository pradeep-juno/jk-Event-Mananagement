import 'package:flutter/material.dart';

class MonthEndClosingPage extends StatefulWidget {
  const MonthEndClosingPage({super.key});

  @override
  State<MonthEndClosingPage> createState() => _MonthEndClosingPageState();
}

class _MonthEndClosingPageState extends State<MonthEndClosingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('month end closing Details'),
      ),
      body: const Center(
        child: Text('Details about month end closing'),
      ),
    );
  }
}
