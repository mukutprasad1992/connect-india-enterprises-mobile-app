import 'package:flutter/material.dart';
import '/modules/admin/widgets/bottomNavbar/bottomNav.dart';
import '/modules/admin/dashboard_home.dart';
import '/modules/admin/widgets/customer/customer.dart';

import '/modules/admin/widgets/vendor/vendor.dart';

import '/modules/admin/widgets/voucher/voucher.dart';

import '/modules/admin/widgets/inquiry/inquery.dart';

//import '/modules/admin/widgets/wishlist/wishlist_page.dart';
import '/modules/admin/widgets/notification/notification.dart';
import '/modules/admin/widgets/drawer/my_drawer.dart';
import '/modules/admin/widgets/drawer/drawer_sections.dart';
import '/modules/admin/widgets/settings/settings.dart';
import '/modules/admin/widgets/drawer/changepassword.dart';
import '/modules/admin/widgets/drawer/myprofile.dart';
import '/consts/appColors.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  DrawerSections currentPage = DrawerSections.dashboard;

  final List<Widget> _pages = [
    DashboardOverview(),
    VendorTablePage(),
    CustomerTablePage(),
    InqueryTablePage(),
    VoucherTablePage(),
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
            MaterialPageRoute(builder: (context) => const DashboardPage()),
          );
        }
        break;
      case DrawerSections.myprofile:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyProfilePage(
            
          ),),
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
                radius: 22,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 18,
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
            child: IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationPage()),
                );
              },
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(right: 16),
          //   child: IconButton(
          //     icon: const Icon(Icons.favorite_border, color: Colors.white),
          //     tooltip: 'Wishlist',
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => const WishlistPage(),
          //         ),
          //       );
          //     },
          //   ),
          // ),
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
