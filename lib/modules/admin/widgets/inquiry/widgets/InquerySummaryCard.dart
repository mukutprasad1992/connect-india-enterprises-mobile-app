import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'inquiryIconbuttons.dart';
import '/models/inquiryModel.dart';
//import 'user_prefs.dart';

class InquirySummaryCard extends StatelessWidget {
  final InquiryModel row;
  final VoidCallback onStatusChanged;
  final Function(bool isLoading)? setLoading;

  const InquirySummaryCard({
    super.key,
    required this.setLoading,
    required this.row,
    required this.onStatusChanged,
  });

  /// Combined future to fetch profile image and first name from SharedPreferences
  static Future<Map<String, String?>> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'profileImg': prefs.getString('profileImg'),
      'firstName': prefs.getString('firstName'),
    };
  }

  /// Status icon mapping
  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Icons.hourglass_empty;
      case "in progress":
        return Icons.autorenew;
      case "approved":
        return Icons.check_circle;
      case "rejected":
        return Icons.cancel;
      case "blocked":
        return Icons.block;
      case "active":
        return Icons.check_circle_outline;
      default:
        return Icons.help_outline;
    }
  }

  /// Status color mapping
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Colors.blue;
      case "in progress":
        return Colors.orange;
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      case "blocked":
        return Colors.redAccent;
      case "active":
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final statusColor = _getStatusColor(row.status ?? '');
    final statusIcon = _getStatusIcon(row.status ?? '');

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Use FutureBuilder to load SharedPreferences values as fallback
            FutureBuilder<Map<String, String?>>(
              future: _loadProfileData(),
              builder: (context, snapshot) {
                String? prefImg;
                String? prefName;

                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  prefImg = snapshot.data?['profileImg'];
                  prefName = snapshot.data?['firstName'];
                }

                // priority: row.profileImgUrl -> prefs.profileImg -> asset fallback
                final rowImgUrl =
                    row.profileImgUrl; // model getter (may be null)
                final chosenImg = (rowImgUrl != null && rowImgUrl.isNotEmpty)
                    ? rowImgUrl
                    : (prefImg != null && prefImg.isNotEmpty ? prefImg : null);

                ImageProvider avatarProvider;
                if (chosenImg != null && chosenImg.isNotEmpty) {
                  avatarProvider = NetworkImage(chosenImg);
                } else {
                  avatarProvider =
                      const AssetImage('assets/images/profileimg.jpg');
                }

                // name priority: row.displayName -> prefs.firstName -> Guest Name
                final displayName = (row.displayName.isNotEmpty)
                    ? row.displayName
                    : (prefName != null && prefName.isNotEmpty
                        ? prefName
                        : 'Guest Name');

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: avatarProvider,
                    ),

                    // Gap between image and name
                    const SizedBox(width: 10),

                    // Name (use Expanded so action buttons align right)
                    Expanded(
                      child: Text(
                        displayName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Action buttons (kept at end)
                    InquiryActionButtons(
                      row: row,
                      onStatusChanged: onStatusChanged,
                      setLoading: setLoading,
                    ),
                  ],
                );
              },
            ),

            // import user_prefs
//import 'user_prefs.dart';

// inside the build() where top row is rendered, replace the FutureBuilder with:
// ValueListenableBuilder<String?>(
//   valueListenable: UserPrefs.instance.profileImg,
//   builder: (context, prefImg, _) {
//     // priority: row.profileImgUrl -> prefImg -> asset fallback
//     final rowImgUrl = row.profileImgUrl;
//     final chosenImg = (rowImgUrl != null && rowImgUrl.isNotEmpty) ? rowImgUrl : (prefImg != null && prefImg.isNotEmpty ? prefImg : null);

//     final ImageProvider avatarProvider = (chosenImg != null && chosenImg.isNotEmpty)
//         ? NetworkImage(chosenImg)
//         : const AssetImage('assets/images/profileimg.jpg');

//     // name priority: row.displayName -> UserPrefs.firstName (ValueNotifier)
//     return ValueListenableBuilder<String?>(
//       valueListenable: UserPrefs.instance.firstName,
//       builder: (context, prefName, __) {
//         final displayName = (row.displayName.isNotEmpty)
//             ? row.displayName
//             : (prefName != null && prefName.isNotEmpty ? prefName : 'Guest Name');

//         return Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: 18,
//               backgroundColor: Colors.grey.shade200,
//               backgroundImage: avatarProvider,
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Text(
//                 displayName,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                   fontSize: 14,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             InquiryActionButtons(
//               row: row,
//               onStatusChanged: onStatusChanged,
//               setLoading: setLoading,
//             ),
//           ],
//         );
//       },
//     );
//   },
// ),

            const SizedBox(height: 6),

            _buildLabelValueText(
                "Aadhaar Number", row.aadharNumber ?? '', Colors.teal),
            const SizedBox(height: 4),
            _buildLabelValueText(
                "PAN Number", row.panNumber ?? '', Colors.blue),
            const SizedBox(height: 4),
            _buildLabelValueText("Email", row.email ?? '', Colors.blue),
            const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(statusIcon, size: 14, color: statusColor),
                  const SizedBox(width: 6),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Status: ",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: row.status ?? 'N/A',
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Label-value builder
  Widget _buildLabelValueText(String label, String value, Color valueColor) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$label: ",
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          TextSpan(
            text: value.isEmpty ? 'N/A' : value,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
