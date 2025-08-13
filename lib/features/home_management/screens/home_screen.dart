import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:mrpace/config/routers/router.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/widgets/custom_typography/typography.dart';

class HomePage extends StatefulWidget {
  final VoidCallback? onMenuPressed;

  const HomePage({super.key, this.onMenuPressed});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _athleticsCategories = [
    "Running",
    "Marathon",
    "Track",
    "Field",
    "Triathlon",
    "Training",
    "Nutrition",
    "Equipment",
    "Coaching",
    "Events",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryColor,
                AppColors.primaryColor.withOpacity(0.9),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.3),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  // Top row with logo and actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Menu button and logo
                      Row(
                        children: [
                          // Menu Button
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.menu,
                                color: Colors.white,
                                size: 18,
                              ),
                              onPressed: widget.onMenuPressed,
                            ),
                          ).animate().fadeIn(duration: 300.ms),
                          // Logo and title
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mr Pace AC Hub',
                                style: CustomTypography
                                    .nunitoTextTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                              ).animate().slideX(begin: -0.1).fadeIn(),
                              Text(
                                    'Your Running & Athletics Companion',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 10,
                                    ),
                                  )
                                  .animate()
                                  .slideX(begin: -0.1, delay: 100.ms)
                                  .fadeIn(),
                            ],
                          ),
                        ],
                      ),
                      // Action buttons
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.notifications_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                              onPressed: () {},
                            ),
                          ).animate().fadeIn(delay: 200.ms),
                          const SizedBox(width: 8),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.person_outline,
                                color: Colors.white,
                                size: 18,
                              ),
                              onPressed: () {},
                            ),
                          ).animate().fadeIn(delay: 300.ms),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Search bar
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search races, events, products...',
                        hintStyle: TextStyle(
                          color: AppColors.subtextColor,
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.primaryColor,
                          size: 20,
                        ),
                        suffixIcon: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.tune,
                              color: Colors.white,
                              size: 18,
                            ),
                            onPressed: () {},
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ).animate().slideY(begin: 0.5).fadeIn(delay: 400.ms),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upcoming Races Banner
            Container(
              margin: const EdgeInsets.all(16),
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.borderColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: PageView(
                children: [
                  _buildImageCard(
                    'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    'City Marathon 2024',
                    'Register now for the biggest race of the year',
                  ).animate().fadeIn(delay: 500.ms),
                  _buildImageCard(
                    'https://images.unsplash.com/photo-1543351611-58f69d7c1781?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    'Trail Running Series',
                    '5 challenging races through scenic routes',
                  ).animate().fadeIn(delay: 500.ms),
                  _buildImageCard(
                    'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    'Charity 10K Run',
                    'Run for a cause and make a difference',
                  ).animate().fadeIn(delay: 500.ms),
                ],
              ),
            ),

            // Athletics Services
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Athletics Services',
                style: CustomTypography.nunitoTextTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.1),
            ),
            const SizedBox(height: 12),

            // Services Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildServiceCard(
                    'Race Registration',
                    Icons.flag,
                    AppColors.primaryColor,
                    onTap: () {
                     Get.toNamed(RoutesHelper.all_races_page);
                    }
                  ).animate().fadeIn(delay: 650.ms),
                  _buildServiceCard(
                    'Sports Shop',
                    Icons.shopping_bag,
                    AppColors.secondaryColor,
                    onTap: () {
                      Get.toNamed(RoutesHelper.allProductsScreen);
                    },
                  ).animate().fadeIn(delay: 700.ms),
                  _buildServiceCard(
                    'Event Hosting',
                    Icons.event,
                    AppColors.accentColor,
                    onTap: () {
                      // Get.toNamed(RoutesHelper.allProductsScreen);
                    },
                  ).animate().fadeIn(delay: 750.ms),
                  _buildServiceCard(
                    'Training Plans',
                    Icons.fitness_center,
                    AppColors.primaryColor.withOpacity(0.8),
                  ).animate().fadeIn(delay: 800.ms),
                  _buildServiceCard(
                    'Coaching',
                    Icons.school,
                    AppColors.secondaryColor.withOpacity(0.8),
                  ).animate().fadeIn(delay: 850.ms),
                  _buildServiceCard(
                    'My Race Entries',
                    Icons.directions_run,
                    AppColors.accentColor.withOpacity(0.8),
                    onTap: () {
                      Get.toNamed(RoutesHelper.allRegistrationsPage);
                    }
                  ).animate().fadeIn(delay: 900.ms),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Featured Races
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Featured Races',
                style: CustomTypography.nunitoTextTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ).animate().fadeIn(delay: 950.ms).slideX(begin: 0.1),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 260,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildRaceCard(
                    'Mountain Ultra Trail',
                    'July 20, 2024 • 6:00 AM',
                    'Rocky Mountains, CO',
                    'https://images.unsplash.com/photo-1571008887538-b36bb32f4571?w=300&h=300&fit=crop',
                  ).animate().fadeIn(delay: 1100.ms),
                  _buildRaceCard(
                    'City Night Run 5K',
                    'August 5, 2024 • 8:00 PM',
                    'Downtown Chicago',
                    'https://images.unsplash.com/photo-1517649763962-0c623066013b?w=300&h=300&fit=crop',
                  ).animate().fadeIn(delay: 1200.ms),
                  _buildRaceCard(
                    'Autumn Half Marathon',
                    'September 12, 2024 • 7:30 AM',
                    'Boston, MA',
                    'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=300&h=300&fit=crop',
                  ).animate().fadeIn(delay: 1300.ms),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Training Programs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Training Programs',
                style: CustomTypography.nunitoTextTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ).animate().fadeIn(delay: 1400.ms).slideX(begin: 0.1),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildTrainingCard(
                    'Beginner 5K Plan',
                    '8-week program to run your first 5K',
                    '\$29.99',
                  ).animate().fadeIn(delay: 1500.ms),
                  const SizedBox(height: 12),
                  _buildTrainingCard(
                    'Marathon Training',
                    '16-week program for marathon success',
                    '\$49.99',
                  ).animate().fadeIn(delay: 1600.ms),
                  const SizedBox(height: 12),
                  _buildTrainingCard(
                    'Speed Development',
                    'Improve your race times with interval training',
                    '\$39.99',
                  ).animate().fadeIn(delay: 1700.ms),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(String imageUrl, String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor.withOpacity(0.6),
              AppColors.primaryColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: CustomTypography.nunitoTextTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
Widget _buildServiceCard(
  String title,
  IconData icon,
  Color color, {
  VoidCallback? onTap,
}) {
  Widget cardContent = Container(
    decoration: BoxDecoration(
      color: AppColors.surfaceColor,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: AppColors.borderColor.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: CustomTypography.nunitoTextTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  return onTap != null
      ? GestureDetector(
          onTap: onTap,
          child: cardContent,
        )
      : cardContent;
}


  Widget _buildRaceCard(
    String title,
    String date,
    String location,
    String imageUrl,
  ) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.borderColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: CustomTypography.nunitoTextTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: CustomTypography.nunitoTextTheme.bodySmall?.copyWith(
                    color: AppColors.subtextColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  location,
                  style: CustomTypography.nunitoTextTheme.bodySmall?.copyWith(
                    color: AppColors.subtextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingCard(String title, String description, String price) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.borderColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.fitness_center,
                color: AppColors.primaryColor,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: CustomTypography.nunitoTextTheme.titleSmall
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: CustomTypography.nunitoTextTheme.bodySmall?.copyWith(
                      color: AppColors.subtextColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                price,
                style: CustomTypography.nunitoTextTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
