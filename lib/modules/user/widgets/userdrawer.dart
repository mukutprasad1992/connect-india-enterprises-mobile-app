import 'package:flutter/material.dart';

class AdminDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AdminDrawer({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Image.asset(
              'assets/images/logo-transparent-png.png',
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            Positioned(
              top: 8,right: 8,child: 
              IconButton(
                icon: Icon(Icons.arrow_back, color: Color(0xFFA52A2A)),
                onPressed: () {
                  Navigator.pop(context); 
                },
              ),
            ),
            buildDrawerItem(Icons.dashboard, 'Dashboard', 0),
            buildSectionTitle('Utilities'),
            buildDrawerItem(Icons.attach_money, 'Investment', 1),
            buildDrawerItem(Icons.assignment, 'Policy', 2),
            buildDrawerItem(Icons.health_and_safety, 'Insurance', 3),
            buildDrawerItem(Icons.account_balance, 'Loan', 4),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF751919),),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      selected: currentIndex == index,
      selectedTileColor: Colors.teal[50],
      onTap: () => onTap(index),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
