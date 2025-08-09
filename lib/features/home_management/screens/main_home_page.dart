import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mrpace/core/utils/pallete.dart';
import 'package:mrpace/features/home_management/screens/home_screen.dart';
import 'package:mrpace/widgets/custom_typography/typography.dart';
import 'package:mrpace/widgets/drawers/customer_drawer.dart';
// Import your other pages here
// import 'package:mrpace/pages/training_page.dart';
// import 'package:mrpace/pages/events_page.dart';
// import 'package:mrpace/pages/shop_page.dart';
// import 'package:mrpace/pages/profile_page.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // List of pages for bottom navigation
  final List<Widget> _pages = [
    const HomePage(),
    // Replace these with your actual pages
    const TrainingPage(),
    const EventsPage(),
    const ShopPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(
        userName: 'Clinpride',
        userEmail: 'zpmakaza@gmail.com',
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages.map((page) {
          if (page is HomePage) {
            return HomePage(onMenuPressed: _openDrawer);
          }
          return page;
        }).toList(),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Container(
          height: 65,
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.borderColor.withOpacity(0.5),
                offset: const Offset(5, 5),
                blurRadius: 5,
              ),
              BoxShadow(
                color: AppColors.backgroundColor,
                offset: const Offset(3, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              buildBottomNavItem(0, Icons.home_rounded, context),
              buildBottomNavItem(1, Icons.directions_run, context),
              buildBottomNavItem(2, Icons.calendar_today, context),
              buildBottomNavItem(3, Icons.shopping_cart, context),
              buildBottomNavItem(4, Icons.person, context),
            ],
          ).animate().fadeIn(delay: 1800.ms),
        ),
      ),
    );
  }

  Widget buildBottomNavItem(int index, IconData icon, BuildContext context) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: _selectedIndex == index
          ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderColor, width: 1),
              ),
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.borderColor.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(-3, -3),
                    ),
                    BoxShadow(
                      color: AppColors.backgroundColor,
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(3, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.primaryColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(icon, size: 20, color: Colors.white)],
                ),
              ),
            )
          : Icon(icon, size: 25, color: AppColors.subtextColor),
    );
  }
}

// Placeholder pages - Replace these with your actual page implementations
class TrainingPage extends StatelessWidget {
  const TrainingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: const Center(
        child: Text(
          'Training Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: const Center(
        child: Text(
          'Events Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: const Center(
        child: Text(
          'Shop Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: const Center(
        child: Text(
          'Profile Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
