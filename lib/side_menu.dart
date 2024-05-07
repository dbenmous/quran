import 'package:flutter/material.dart';

class SideMenuItem {
  final IconData icon;
  final String text;
  final String route;

  SideMenuItem({
    required this.icon,
    required this.text,
    required this.route,
  });
}

class SideMenu extends StatelessWidget {
  final List<SideMenuItem> items;
  final Function(String) onItemTap;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final String fontFamily;
  final double width;

  SideMenu({
    required this.items,
    required this.onItemTap,
    this.backgroundColor = const Color(0xFF6F6F6F),
    this.iconColor = Colors.white,
    this.textColor = Colors.white,
    this.fontFamily = 'arabic_roman',
    this.width = 220, // Updated width to 220 for more space
  });

  @override
  Widget build(BuildContext context) {
    final itemHeight = MediaQuery.of(context).size.height / items.length;

    return Container(
      width: width, // Use the width parameter
      height: MediaQuery.of(context).size.height,
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: items
            .expand((item) => [
          _buildMenuItem(context, item, itemHeight),
          const Divider(height: 3, color: Colors.white), // White line between items
        ])
            .toList(),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, SideMenuItem item, double itemHeight) {
    return GestureDetector(
      onTap: () => onItemTap(item.route),
      child: Container(
        height: itemHeight - 3, // Reduce item height by 3 to account for spacing
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                item.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontFamily: fontFamily,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(width: 20),
            Icon(
              item.icon,
              color: iconColor,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
