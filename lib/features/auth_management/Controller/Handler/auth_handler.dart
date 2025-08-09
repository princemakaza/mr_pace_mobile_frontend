// import 'package:care453/core/utils/logs.dart';
// import 'package:care453/features/auth/Screens/sign_in_employeee.dart';
// import 'package:care453/features/splash/role_selection.dart';
// import 'package:care453/features/welcome/client_introduction_screen.dart';
// import 'package:care453/features/welcome/employee_introduction_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
// import '../../../core/utils/casched_data.dart';
// import '../../../models/select_user_enum.dart';
// import '../../../models/user_model.dart';
// import '../../../providers/user_provider_class.dart';
// import '../Screens/sign_in.dart';
// import '../../Home/client_main_screen.dart';
// import '../../Home/admin_main_home.dart';

// class AuthHandler extends StatelessWidget {
//   const AuthHandler({super.key});

//   Future<UserModel?> _getUserFromToken() async {
//     final token = await CacheUtils.checkToken();
//     if (token != null && token.isNotEmpty) {
//       if (JwtDecoder.isExpired(token)) {
//         await CacheUtils.clearCachedToken();
//         return null; // Token expired, navigate to Login
//       } else {
//         final decodedToken = JwtDecoder.decode(token);
//         DevLogs.logInfo("memo:  $decodedToken");
//         return UserModel.fromMap(decodedToken);
//       }
//     }
//     return null; // No token found, navigate to Login
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<UserRole?>(
//       future: CacheUtils.checkUserRole(),
//       builder: (context, roleSnapshot) {
//         if (roleSnapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }

//         final userRole = roleSnapshot.data;

//         if (userRole == null) {
//           return const InitialRoleSelectionScreen(); // No role selected, navigate to role selection
//         }

//         return FutureBuilder<bool>(
//           future: CacheUtils.checkOnBoardingStatus(),
//           builder: (context, onboardingSnapshot) {
//             if (onboardingSnapshot.connectionState == ConnectionState.waiting) {
//               return Scaffold(
//                 backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//                 body: const Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               );
//             }

//             final hasSeenOnboarding = onboardingSnapshot.data ?? false;

//             if (!hasSeenOnboarding) {
//               return userRole == UserRole.careProfessioner
//                   ? const EmployeeIntroductionScreen()
//                   : const ClientIntroductionScreen();
//             }

//             return FutureBuilder<UserModel?>(
//               future: _getUserFromToken(),
//               builder: (context, tokenSnapshot) {
//                 if (tokenSnapshot.connectionState == ConnectionState.waiting) {
//                   return const Scaffold(
//                     body: Center(child: CircularProgressIndicator()),
//                   );
//                 }

//                 if (!tokenSnapshot.hasData) {
//                   return userRole == UserRole.client
//                       ? const Login()
//                       : const LoginEmployee();
//                   // No valid token or token expired
//                 }

//                 final user = tokenSnapshot.data!;
//                 DevLogs.logInfo("$user");

//                 // Move this into a builder function
//                 return Builder(
//                   builder: (context) {
//                     final userProvider =
//                         Provider.of<UserProvider>(context, listen: false);
//                     userProvider.setUser(user);

//                     return userRole == UserRole.careProfessioner
//                         ? const EmployeeMainScreen()
//                         : const ClientMainScreen();
//                   },
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }
