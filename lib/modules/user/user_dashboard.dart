import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/investment/investment.dart';
import 'widgets/policy/policy.dart';
import 'widgets/insurance/insurance.dart';
import 'widgets/loan/loan.dart';

import '../user/widgets/bottomNavbarUser/bottomNav.dart';
import '/Main_dashboard.dart';

import '/views/notification/notification.dart';
import '/views/drawer/my_drawer.dart';
import '/views/drawer/drawer_sections.dart';
import '/views/settings/settings.dart';
import '/views/drawer/changepassword.dart';
import '/views/drawer/myprofile.dart';
import '/consts/appColors.dart';

import 'package:badges/badges.dart' as badges;
import '/services/notificationServices/notificationApi.dart';
class UserDashboardPage extends StatefulWidget {
  const UserDashboardPage({super.key});

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
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
      debugPrint("Error fetching unread count: $e");
      return 0;
    }
  }

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('KEYTOKEN');

    setState(() {
      userToken = token;
      loadingToken = false;

      _pages.clear();
      _pages.addAll([
        Dashboard(),
        InsurancePage(token: token ?? ''),
        //InsurancePage(),

        InvestmentPage(token: token ?? ''),
        //LoanPage(),
        LoanPage(token: token ?? ''),
        //PolicyPage(),
        PolicyPage(token: token ?? ''),
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
            MaterialPageRoute(builder: (context) => const UserDashboardPage()),
          );
        }
        break;
      case DrawerSections.myprofile:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyProfilePage()),
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
    if (loadingToken) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
