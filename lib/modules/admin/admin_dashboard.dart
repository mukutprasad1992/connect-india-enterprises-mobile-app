import 'package:flutter/material.dart';
import 'widgets/bottomNavbarAdmin/bottomNav.dart';
import '../vendor_Dashboard.dart';
import '/modules/admin/widgets/customer/customer.dart';
import '/modules/admin/widgets/vendor/vendor.dart';
import '/modules/admin/widgets/voucher/voucher.dart';
import '/modules/admin/widgets/inquiry/inquery.dart';
//import '/modules/admin/widgets/wishlist/wishlist_page.dart';
import '/modules//notification/notification.dart';
import '/modules/drawer/my_drawer.dart';
import '/modules/drawer/drawer_sections.dart';
import '/modules/settings/settings.dart';
import '/modules/drawer/changepassword.dart';
import '/modules/drawer/myprofile.dart';
import '/consts/appColors.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  DrawerSections currentPage = DrawerSections.dashboard;

  final List<Widget> _pages = [
    Dashboard(),
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
            MaterialPageRoute(builder: (context) => const AdminDashboardPage()),
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
