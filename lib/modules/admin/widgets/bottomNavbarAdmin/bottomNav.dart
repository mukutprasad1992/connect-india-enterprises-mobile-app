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
      items: const [
        BottomNavigationBarItem(
          icon: Tooltip(message: 'Dashboard', child: Icon(Icons.dashboard_rounded)),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Tooltip(message: 'Vendor', child: Icon(Icons.store_rounded)),
          label: 'Vendor',
        ),
        BottomNavigationBarItem(
          icon: Tooltip(message: 'Customer', child: Icon(Icons.support_agent_rounded)),
          label: 'Customer',
        ),
        BottomNavigationBarItem(
          icon: Tooltip(message: 'Inquiry', child: Icon(Icons.people_alt_rounded)),
          label: 'Inquiry',
        ),
        BottomNavigationBarItem(
          icon: Tooltip(message: 'Voucher', child: Icon(Icons.receipt_long_rounded)),
          label: 'Voucher',
        ),
      ],
    );
  }
}
