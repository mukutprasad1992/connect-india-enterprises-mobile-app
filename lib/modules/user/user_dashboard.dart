import 'package:flutter/material.dart';
import 'widgets/investment/investment.dart';
import 'widgets/policy/policy.dart';
import 'widgets/insurance/insurance.dart';
import 'widgets/loan/loan.dart';
import 'widgets/userdrawer.dart'; 
import 'widgets/dashoard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Panel',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: Color(0xFF751919),
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const AdminPanel(),
    );
  }
}

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  int currentIndex = 0;

  Widget getCurrentScreen() {
    switch (currentIndex) {
      case 0:
        return DashboardPage();
      case 1:
        return InvestmentPage();
      case 2:
        return PolicyPage();
      case 3:
        return InsurancePage();
      case 4:
        return LoanPage();
      default:
        return DashboardPage();
    }
  }

  Widget buildDrawer() {
    return AdminDrawer(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
        Navigator.pop(context); 
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isLargeScreen = constraints.maxWidth >= 800;

        return Scaffold(
          drawer: isLargeScreen ? null : buildDrawer(),
          body: Row(
            children: [
              if (isLargeScreen)
                SizedBox(
                  width: 250,
                  child: buildDrawer(),
                ),
              Expanded(
                child: Column(
                  children: [
                    // Top AppBar
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFA52A2A),
                            Color(0xFFB35B4A),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (!isLargeScreen)
                            Builder(
                              builder: (context) => IconButton(
                                icon: const Icon(Icons.menu, size: 30, color: Colors.white),
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                              ),
                            ),
                          Row(
                            children: [
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.notifications, color: Colors.white),
                                onSelected: (value) {
                                  
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(value: "1", child: Text("New policy available")),
                                  const PopupMenuItem(value: "2", child: Text("Loan update pending")),
                                  const PopupMenuItem(value: "3", child: Text("Insurance expiring soon")),
                                ],
                              ),

                              PopupMenuButton<String>(
                                icon: const Icon(Icons.account_circle, color: Colors.white),
                                onSelected: (value) {
                                  switch (value) {
                                    case 'admin':
                                      
                                      break;
                                    case 'profile':
                                      
                                      break;
                                    case 'password':
                                      
                                      break;
                                    case 'logout':
                                      
                                      break;
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(value: 'admin', child: Text("Admin User")),
                                  const PopupMenuItem(value: 'profile', child: Text("My Profile")),
                                  const PopupMenuItem(value: 'password', child: Text("Change Password")),
                                  const PopupMenuItem(value: 'logout', child: Text("Logout")),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: getCurrentScreen(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
