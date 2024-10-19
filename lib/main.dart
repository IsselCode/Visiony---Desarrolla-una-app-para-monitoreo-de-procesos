import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vision_app/features/auth/presentation/providers/auth_app_provider.dart';
import 'package:vision_app/features/auth/presentation/screens/login/screen.dart';
import 'package:vision_app/features/production/controller/line_state.dart';
import 'package:vision_app/features/production/view/line_production_screen.dart';
import 'package:vision_app/inject_dependencies/inject_container.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await injectContainer();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => FirebaseFirestore.instance,),
        ChangeNotifierProvider(create: (context) => AuthAppProvider(authRepository: locator()),),
        ChangeNotifierProvider(create: (context) => LineState(firestore: context.read())..getAllLines(),)
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: LoginScreen()
      ),
    );
  }
}
