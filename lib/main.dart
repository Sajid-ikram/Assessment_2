import 'package:assessment_2/Provider/authentication.dart';
import 'package:assessment_2/provider/post_provider.dart';
import 'package:assessment_2/provider/pro_provider.dart';
import 'package:assessment_2/view/auth/registration.dart';
import 'package:assessment_2/view/auth/signin.dart';
import 'package:assessment_2/view/home/home.dart';
import 'package:assessment_2/view/home/productDetailPage.dart';
import 'package:assessment_2/view/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:assessment_2/firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'holding_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => Authentication()),
        ChangeNotifierProvider(create: (_) => PostProvider()),

      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 800),
        builder: (context, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Secondhand Market',
              theme: _buildTheme(Brightness.light),
              home: const HoldingPage(),
              routes: {
                "home": (ctx) => const Home(),
                "Registration": (ctx) => const Registration(),
                "productDetailPage": (ctx) => const ProductDetailPage(),
                "SignIn": (ctx) => const SignIn(),
                "HoldingPage": (ctx) => const HoldingPage(),
              });
        },
      ),
    );
  }
}

ThemeData _buildTheme(brightness) {
  var baseTheme = ThemeData(
    brightness: brightness,
    primarySwatch: greenSwatch,
  );

  return baseTheme.copyWith(
    textTheme: GoogleFonts.montserratTextTheme(baseTheme.textTheme),
    primaryColor: const Color(0xff425C5A),
    scaffoldBackgroundColor: Colors.white,
  );
}