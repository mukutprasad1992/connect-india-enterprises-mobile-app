import 'package:flutter/material.dart';
import 'widgets/bottomNavbarAdmin/bottomNav.dart';
//import '/Main_dashboard.dart';
import '/admin_dashboard/adminDashboard.dart';
import '/modules/admin/widgets/customer/customer.dart';
import '/modules/admin/widgets/vendor/vendor.dart';
import '/modules/admin/widgets/voucher/voucher.dart';
import '/modules/admin/widgets/inquiry/inquery.dart';
//import '/modules/admin/widgets/wishlist/wishlist_page.dart';
import '/views//notification/notification.dart';
import '/views/drawer/my_drawer.dart';
import '/views/drawer/drawer_sections.dart';
import '/views/settings/settings.dart';
import '/views/drawer/changepassword.dart';
import '/views/drawer/myprofile.dart';
import '/consts/appColors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:badges/badges.dart' as badges;

import '/services/notificationServices/notificationApi.dart';

class AdminDashboardPage extends StatefulWidget {
  
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  DrawerSections currentPage = DrawerSections.dashboard;
  

  String? userToken;
  bool loadingToken = true;

  Future<int> fetchUnreadCount() async {
    try {
      final list = await NotificationService.getNotifications();
      return list.where((n) => n.isRead == 0).length;
    } catch (e) {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  final List<Widget> _pages = [];

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('KEYTOKEN');
    setState(() {
      userToken = token;
      loadingToken = false;

      _pages.clear();
      _pages.addAll([
        DashboardCardsPage(),
        VendorTablePage(),
        CustomerTablePage(),
        InqueryTablePage(),
        VoucherTablePage(),
      ]);
    });
  }

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
        Navigator.pop(context);
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
          MaterialPageRoute(builder: (context) => ChangePasswordPage()),
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
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  NotificationPage(),
                        ),
                      );
                      // Refresh badge count after returning
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
