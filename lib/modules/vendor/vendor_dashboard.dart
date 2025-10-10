import 'package:flutter/material.dart';
import '../vendor/bottomNavbarVendor/bottomNav.dart';
import '../../Main_dashboard.dart';

import '/views/notification/notification.dart';
import '/views/drawer/my_drawer.dart';
import '/views/drawer/drawer_sections.dart';
import '/views/settings/settings.dart';
import '/views/drawer/changepassword.dart';
import '/views/drawer/myprofile.dart';
import '/consts/appColors.dart';

import '/modules/vendor/customer/vendorCustomer.dart';
import '/modules/vendor/voucher/vendorVoucher.dart';

import 'package:badges/badges.dart' as badges;
import '/services/notificationServices/notificationApi.dart';

class VendorDashboardPage extends StatefulWidget {
  const VendorDashboardPage({super.key});

  @override
  State<VendorDashboardPage> createState() => _VendorDashboardPageState();
}

class _VendorDashboardPageState extends State<VendorDashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  DrawerSections currentPage = DrawerSections.dashboard;

  Future<int> fetchUnreadCount() async {
    try {
      final list = await NotificationService.getNotifications();
      return list.where((n) => n.isRead == 0).length;
    } catch (e) {
      debugPrint("Error fetching unread count: $e");
      return 0;
    }
  }

  final List<Widget> _pages = [
    Dashboard(),
    VendorCustomerPage(),
    VendorVoucherpage(),
  ];

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void handleDrawerNavigation(DrawerSections section) {
    setState(() {
      currentPage = section;
    });

    switch (section) {
      case DrawerSections.dashboard:
        if (_selectedIndex != 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const VendorVoucherpage()),
          );
        }
        break;
      case DrawerSections.myprofile:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyProfilePage(),
          ),
        );
        break;
      case DrawerSections.changepassword:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
        );
        break;
      case DrawerSections.settings:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        );
        break;
      case DrawerSections.logout:
        // Logout handled inside drawer
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MyDrawer(
        currentPage: currentPage,
        onItemSelected: handleDrawerNavigation,
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => _scaffoldKey.currentState?.openDrawer(),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'CONNECT INDIA ENTERPRISES',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FutureBuilder<int>(
              future: fetchUnreadCount(),
              builder: (context, snapshot) {
                final count = snapshot.data ?? 0;

                return badges.Badge(
                  showBadge: count > 0,
                  badgeContent: Text(
                    count.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.white),
                    onPressed: () async {
                      // NotificationPage kholne par
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationPage()),
                      );
                      setState(() {});
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}
