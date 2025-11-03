import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed, 
      backgroundColor: Colors.white,

      selectedItemColor: Colors.red[800],
      unselectedItemColor: Colors.grey,

      iconSize: 20, 
      selectedFontSize: 11, 
      unselectedFontSize: 10, 
      
      items: const [
        BottomNavigationBarItem(
          icon: Tooltip(message: 'Dashboard', child: Icon(Icons.dashboard_rounded)),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Tooltip(message: 'Insurance', child: Icon(Icons.security_rounded)),
          label: 'Insurance',
        ),
        BottomNavigationBarItem(
          icon: Tooltip(message: 'Investment', child: Icon(Icons.stacked_line_chart_rounded)),
          label: 'Investment',
        ),
        BottomNavigationBarItem(
          icon: Tooltip(message: 'Loan', child: Icon(Icons.account_balance_rounded)),
          label: 'Loan',
        ),
        BottomNavigationBarItem(
          icon: Tooltip(message: 'Policy', child: Icon(Icons.article_outlined)),
          label: 'Policy',
        ),
      ],
    );
  }
}
