import 'package:flutter/material.dart';
import 'faqs.dart';
import '/modules/admin/widgets/settings/terms_conditions.dart';
import '/modules/admin/widgets/settings/share_app.dart';
import '/modules/admin/widgets/settings/helps_support.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color.fromARGB(255, 149, 18, 18),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          _buildOption(
            context,
            title: 'FAQs',
            icon: Icons.question_answer,
            page: const FaqsPage(),
          ),
          _buildOption(
            context,
            title: 'Terms & Conditions',
            icon: Icons.article,
            page: const TermsConditionsPage(),
          ),
          _buildOption(
            context,
            title: 'Share Application',
            icon: Icons.share,
            page: const ShareAppPage(),
          ),
          _buildOption(
            context,
            title: 'Help & Support',
            icon: Icons.support_agent,
            page: const HelpSupportPage(),
          ),
          _buildOption(
            context,
            title: 'Delete Account',
            icon: Icons.delete_forever,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Deletion'),
                  content: const Text('Are you sure you want to delete your account?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Account deletion requested.')),
                        );
                        // Add actual delete logic here if needed
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context,
      {required String title,
      required IconData icon,
      Widget? page,
      VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap ??
          () {
            if (page != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page),
              );
            }
          },
    );
  }
}
