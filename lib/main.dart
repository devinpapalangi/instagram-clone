import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/features/auth/screens/login_screen.dart';
import 'package:instagram_clone/features/auth/screens/signup_screen.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/responsive/app_responsive.dart';
import 'package:instagram_clone/responsive/layout/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/layout/web_screen_layout.dart';
import 'package:instagram_clone/router.dart';
import 'package:instagram_clone/utils/app_styles.dart';
import 'package:instagram_clone/widgets/loader.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyCESi8uD0XMk18V93O3yv5ToB6xaDHMJLU',
          appId: '1:694813847139:web:cc0a514db3c5a5c14e1256',
          messagingSenderId: '694813847139',
          projectId: 'instagram-clone-bbfa0',
          storageBucket: 'instagram-clone-bbfa0.appspot.com'),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        onGenerateRoute: (settings) => generateRoute(settings),
        debugShowCheckedModeBanner: false,
        theme: Styles.themeData.copyWith(
          scaffoldBackgroundColor: Styles.mobileBackgroundColor,
        ),
        // home: const ResponsiveLayout(
        //   webScreenLayout: WebScreenLayout(),
        //   mobileScreenLayout: MobileScreenLayout(),
        // ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text('An error occured'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
