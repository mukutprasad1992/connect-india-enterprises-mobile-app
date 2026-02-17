import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/views/login/login_page.dart';
import 'drawer_sections.dart';
import 'my_header_drawer.dart';
import '/consts/appColors.dart';

class MyDrawer extends StatelessWidget {
  final DrawerSections currentPage;
  final Function(DrawerSections) onItemSelected;

  const MyDrawer({
    super.key,
    required this.currentPage,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const MyHeaderDrawer(),
            _MyDrawerList(
              currentPage: currentPage,
              onItemSelected: onItemSelected,
            ),
          ],
        ),
      ),
    );
  }
}

class _MyDrawerList extends StatelessWidget {
  final DrawerSections currentPage;
  final Function(DrawerSections) onItemSelected;

  const _MyDrawerList({
    required this.currentPage,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(context, DrawerSections.dashboard, "Dashboard", Icons.dashboard),
        _buildMenuItem(context, DrawerSections.myprofile, "My Profile", Icons.account_circle),
        _buildMenuItem(context, DrawerSections.changepassword, "Change Password", Icons.lock_outline),
        _buildMenuItem(context, DrawerSections.settings, "Settings", Icons.settings),
        _buildMenuItem(context, DrawerSections.logout, "Logout", Icons.logout),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    DrawerSections section,
    String title,
    IconData icon,
  ) {
    final bool isSelected = section == currentPage;

    return Material(
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? AppColors.background : Colors.black87,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColors.background : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () async {
          if (section == DrawerSections.logout) {
            final confirmLogout = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      child: const Text('No',style: TextStyle(color:Colors.white),),
                       style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    ElevatedButton(
                      child: const Text('Yes',style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:AppColors.background
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                );
              },
            );

            if (confirmLogout == true) {
              //final sharedPref = await SharedPreferences.getInstance();
              //await sharedPref.setBool('KEYLOGIN', false);

              final sharedPref = await SharedPreferences.getInstance();
              await sharedPref.remove('KEYLOGIN');   // remove login flag
              await sharedPref.remove('KEYTOKEN');   // remove saved token
              await sharedPref.remove('KEYROLEID');  // remove role ID


              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Center(child: Text('Logged out successfully.')),
                  backgroundColor: Colors.green,
                ),
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            }
          } else {
            onItemSelected(section);
          }
        },
      ),
    );
  }
}