import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:media_kit/media_kit.dart';
import 'package:movi_mobile/core/constants/theme/app_theme.dart';
import 'package:movi_mobile/core/service_locator.dart';
import 'package:movi_mobile/presentation/bloc/splash_bloc.dart';
import 'package:movi_mobile/presentation/navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await initializeApp();

  try {
    await dotenv.load(fileName: ".env");
    print(".env file loaded.");
  } catch (e) {
    print("Error loading .env file: $e");
  }

  await init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashBloc>(
          create: (_) {
            try {
              return sl<SplashBloc>();
            } catch (e) {
              print("Error creating SplahBloc: $e");
              rethrow;
            }
          },
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: AppTheme.defaultTheme,
      ),
    );
  }
}

