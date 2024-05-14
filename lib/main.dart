import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:musch/controller/drawer_controller.dart';
import 'package:musch/controller/nav_controller.dart';
import 'package:musch/firebase_options.dart';
import 'package:musch/pages/auth/splash_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/event/event_bloc.dart';
import 'blocs/user/user_bloc.dart';
import 'manager/app_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Bloc.observer = AppBlocObserver();
  //  1 - Ensure firebase app is initialized if starting from background/terminated state
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(MyDrawerController());
  Get.put(NavController());
  Get.find<MyDrawerController>().closeDrawer();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc()),
          BlocProvider(create: (context) => UserBloc()),
          BlocProvider(create: (context) => EventBloc()),
        ],
        child: GetMaterialApp(
          navigatorKey: navKey,
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        ),
      );
    });
  }
}

GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
