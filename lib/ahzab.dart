import 'package:flutter/material.dart';

class AhzabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الأحزاب'),
      ),
      body: Center(
        child: Text(
          'Welcome to Ahzab Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
