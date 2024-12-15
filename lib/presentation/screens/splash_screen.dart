import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movi_mobile/presentation/bloc/splash_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Dispatch de l'événement pour charger les données de l'application
    context.read<SplashBloc>().add(LoadAppDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) async {
          if (state is SplashDataLoadedState) {
            // Introduire un délai avant de naviguer
            await Future.delayed(const Duration(seconds: 3));
            if (!mounted) return; // Vérification si le widget est toujours monté
            if (state.hasUsers) {
              context.go('/profiles_screen');
            } else {
              context.go('/add_user_screen');
            }
          } else if (state is SplashErrorState) {
            // Afficher un message d'erreur si le chargement échoue
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Image.asset(
                  'assets/icons/logo.png',
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: BlocBuilder<SplashBloc, SplashState>(
                    builder: (context, state) {
                      if (state is SplashLoadingState) {
                        return const CircularProgressIndicator();
                      }
                      return const SizedBox(); // Placeholder si pas en chargement
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
