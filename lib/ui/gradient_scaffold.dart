import 'dart:ui';
import 'package:flutter/material.dart';

class GradientScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  final List<Color> gradientColors;
  final double watermarkOpacity;
  final double blurSigma;
  final double watermarkWidthFactor;
  final String watermarkAsset;

  const GradientScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.gradientColors = const [ Color(0xFF0E6FFF), Color(0xFF6EC8FF) ],
    this.watermarkOpacity = 0.06,
    this.blurSigma = 12,
    this.watermarkWidthFactor = 0.75,
    this.watermarkAsset = 'assets/images/logo.png',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Fondo en gradiente
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
          ),
        ),
        // Logo difuminado (no bloquea toques)
        IgnorePointer(
          ignoring: true,
          child: Center(
            child: Opacity(
              opacity: watermarkOpacity,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
                child: LayoutBuilder(
                  builder: (context, c) => Image.asset(
                    watermarkAsset,
                    width: c.maxWidth * watermarkWidthFactor,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
        // Contenido real
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: appBar,
          body: body,
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomNavigationBar,
        ),
      ],
    );
  }
}
