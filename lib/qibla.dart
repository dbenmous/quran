import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class QiblaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Qibla Page'),
      ),
      body: Center(
        child: IconButton(
          icon: Icon(Icons.privacy_tip, size: 50, color: Colors.blue),
          onPressed: () async {
            const url = 'https://thedigits.co/quran/privacy-policy/';
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
        ),
      ),
    );
  }
}
