import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/widgets/custom_typography/typography.dart';

class CustomDrawer extends StatelessWidget {
  final String? profileImageUrl;
  final String userName;
  final String userEmail;

  const CustomDrawer({
    super.key,
    this.profileImageUrl,
    required this.userName,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final headerHeight = screenHeight * 0.2; // 20% of screen height
    final minHeaderHeight = 200.0; // Minimum height for header
    final effectiveHeaderHeight = headerHeight.clamp(minHeaderHeight, 250.0);

    return Drawer(
      backgroundColor: AppColors.backgroundColor,
      child: Column(
        children: [
          // Drawer Header with profile
          Container(
            height: effectiveHeaderHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryColor,
                  AppColors.primaryColor.withOpacity(0.9),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile Picture with fallback
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: profileImageUrl != null
                          ? ClipOval(
                              child: Image.network(
                                profileImageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildProfileFallback(),
                              ),
                            )
                          : _buildProfileFallback(),
                    ).animate().fadeIn(duration: 300.ms),
                    const SizedBox(height: 12),
                    // User Name with overflow protection
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        userName,
                        style: CustomTypography.nunitoTextTheme.titleLarge
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ).animate().slideX(begin: -0.1).fadeIn(delay: 100.ms),
                    ),
                    SizedBox(height: 4),
                    // User Email with overflow protection
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        userEmail,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ).animate().slideX(begin: -0.1).fadeIn(delay: 200.ms),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Drawer Items with flexible space
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _buildDrawerItem(
                    icon: Icons.store,
                    title: 'Athletics Store',
                    onTap: () => _navigateAndClose(context, '/store'),
                  ).animate().fadeIn(delay: 350.ms),

                  _buildDrawerItem(
                    icon: Icons.directions_run,
                    title: 'Training Program',
                    onTap: () => _navigateAndClose(context, '/training'),
                  ).animate().fadeIn(delay: 400.ms),

                  _buildDrawerItem(
                    icon: Icons.event,
                    title: 'Race Calendar',
                    onTap: () => _navigateAndClose(context, '/calendar'),
                  ).animate().fadeIn(delay: 450.ms),


                  _buildDrawerItem(
                    icon: Icons.event_available,
                    title: 'Book Event',
                    onTap: () => _navigateAndClose(context, '/events'),
                  ).animate().fadeIn(delay: 450.ms),

                  _buildDrawerItem(
                    icon: Icons.timeline,
                    title: 'Race Experiences',
                    onTap: () => _navigateAndClose(context, '/experiences'),
                  ).animate().fadeIn(delay: 500.ms),

                  _buildDrawerItem(
                    icon: Icons.group,
                    title: 'Running Groups',
                    onTap: () => _navigateAndClose(context, '/groups'),
                  ).animate().fadeIn(delay: 550.ms),

                  _buildDrawerItem(
                    icon: Icons.article,
                    title: 'Athletics News',
                    onTap: () => _navigateAndClose(context, '/news'),
                  ).animate().fadeIn(delay: 600.ms),

                  const Divider(height: 32, indent: 20, endIndent: 20),

                  _buildDrawerItem(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () => _navigateAndClose(context, '/help'),
                  ).animate().fadeIn(delay: 650.ms),

                  _buildDrawerItem(
                    icon: Icons.question_answer_outlined,
                    title: 'FAQ',
                    onTap: () => _navigateAndClose(context, '/faq'),
                  ).animate().fadeIn(delay: 700.ms),

                  _buildDrawerItem(
                    icon: Icons.info_outline,
                    title: 'About',
                    onTap: () => _navigateAndClose(context, '/about'),
                  ).animate().fadeIn(delay: 750.ms),

                  // Extra space at bottom to prevent button overlap
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
                ],
              ),
            ),
          ),

          // Logout Button (fixed at bottom)
          _buildLogoutButton(context).animate().fadeIn(delay: 800.ms),
        ],
      ),
    );
  }

  Widget _buildProfileFallback() {
    return const Icon(Icons.person, color: Colors.white, size: 40);
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primaryColor, size: 20),
      ),
      title: Text(
        title,
        style: CustomTypography.nunitoTextTheme.bodyMedium?.copyWith(
          color: AppColors.textColor,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ).copyWith(bottom: MediaQuery.of(context).padding.bottom + 8),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.logout, size: 18),
        label: Text(
          'Logout',
          style: CustomTypography.nunitoTextTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () => _showLogoutDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _navigateAndClose(BuildContext context, String route) {
    Navigator.pop(context);
    // Uncomment when you have your navigation setup
    // Navigator.pushNamed(context, route);
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Logout',
            style: CustomTypography.nunitoTextTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: CustomTypography.nunitoTextTheme.bodyMedium?.copyWith(
              color: AppColors.subtextColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.subtextColor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context); // Close drawer
                // Handle actual logout logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
