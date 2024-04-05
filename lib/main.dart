import 'package:assessment_2/Provider/authentication.dart';
import 'package:assessment_2/view/auth/registration.dart';
import 'package:assessment_2/view/auth/signin.dart';
import 'package:assessment_2/view/home/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:assessment_2/firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
        ChangeNotifierProvider(create: (_) => Authentication()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 800),
        builder: (context, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Secondhand Market',
              home: const SignIn(),
              routes: {
                "home": (ctx) => const Home(),
                "Registration": (ctx) => const Registration(),
                "SignIn": (ctx) => const SignIn(),
              });
        },
      ),
    );
  }
}

