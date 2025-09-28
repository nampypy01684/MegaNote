import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:note_app/core/constants.dart';
import 'package:note_app/pages/registration_page.dart';
import 'package:note_app/services/auth_service.dart';
import 'package:provider/provider.dart';

import 'change_notifiers/notes_provider.dart';
import 'change_notifiers/registration_controller.dart';
import 'change_notifiers/theme_provider.dart'; // ⭐ import
import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotesProvider()),
        ChangeNotifierProvider(create: (_) => RegistrationController()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // ⭐ chỉ 1 lần
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Mega Notes',

            // ⭐ Dark/Light Mode
            themeMode: themeProvider.themeMode,

            // Light Theme
            theme: ThemeData(
              brightness: Brightness.light,
              colorScheme: ColorScheme.fromSeed(seedColor: primary),
              fontFamily: 'Poppins',
              scaffoldBackgroundColor: background,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: const IconThemeData(color: primary),
                titleTextStyle: const TextStyle(
                  color: primary,
                  fontSize: 32,
                  fontFamily: 'Fredoka',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Dark Theme
            darkTheme: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: primary,
                brightness: Brightness.dark,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.white),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontFamily: 'Fredoka',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Ngôn ngữ
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              FlutterQuillLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('vi', 'VN'),
            ],

            // Trang chủ hoặc đăng ký
            home: StreamBuilder<User?>(
              stream: AuthService.userStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(body: Center(child: CircularProgressIndicator()));
                }

                final user = snapshot.data;
                if (user != null) {
                  return const HomePage(); // chỉ cần user != null → HomePage
                } else {
                  return const RegistrationPage();
                }
              },
            ),

            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
