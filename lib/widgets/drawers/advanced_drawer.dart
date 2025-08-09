// import 'package:fleet_cbz/widgets/drawers/admin_drawer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
//
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final _advancedDrawerController = AdvancedDrawerController();
//
//   @override
//   Widget build(BuildContext context) {
//     return AdvancedDrawer(
//         backdrop: Container(
//           width: double.infinity,
//           height: double.infinity,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [Colors.blueGrey, Colors.blueGrey.withOpacity(0.2)],
//             ),
//           ),
//         ),
//         controller: _advancedDrawerController,
//         animationCurve: Curves.easeInOut,
//         animationDuration: const Duration(milliseconds: 300),
//         animateChildDecoration: true,
//         rtlOpening: false,
//         openScale: 1.0,
//         disabledGestures: false,
//         childDecoration: const BoxDecoration(
//           // NOTICE: Uncomment if you want to add shadow behind the page.
//           // Keep in mind that it may cause animation jerks.
//           boxShadow: <BoxShadow>[
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 0.0,
//             ),
//           ],
//           borderRadius: const BorderRadius.all(Radius.circular(16)),
//         ),
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('Advanced Drawer Example'),
//             leading: IconButton(
//               onPressed: _handleMenuButtonPressed,
//               icon: ValueListenableBuilder<AdvancedDrawerValue>(
//                 valueListenable: _advancedDrawerController,
//                 builder: (_, value, __) {
//                   return AnimatedSwitcher(
//                     duration: Duration(milliseconds: 250),
//                     child: Icon(
//                       value.visible ? Icons.clear : Icons.menu,
//                       key: ValueKey<bool>(value.visible),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//           body: Container(),
//         ),
//         drawer: AdminDrawer()
//     );
//   }
//
//   void _handleMenuButtonPressed() {
//     // NOTICE: Manage Advanced Drawer state through the Controller.
//     // _advancedDrawerController.value = AdvancedDrawerValue.visible();
//     _advancedDrawerController.showDrawer();
//   }
// }