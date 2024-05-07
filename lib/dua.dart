import 'package:flutter/material.dart';

class DuaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('دعاء الختم'),
      ),
      body: Center(
        child: Text(
          'Welcome to Dua Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
