import 'package:flutter/material.dart';

class DonatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تبرع لنستمر'),
      ),
      body: Center(
        child: Text(
          'Welcome to Donate Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
