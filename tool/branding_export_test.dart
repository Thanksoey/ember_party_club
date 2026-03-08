import 'dart:io';
import 'dart:ui' as ui;

import 'package:ember_party_club/app/theme/app_theme.dart';
import 'package:ember_party_club/app/widgets/brand_mark.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('export branding assets', (tester) async {
    final iconTargets = <_SquareTarget>[
      const _SquareTarget('assets/branding/ember_app_icon.png', 1024),
      const _SquareTarget('assets/branding/ember_app_icon_512.png', 512),
      const _SquareTarget('assets/branding/ember_app_icon_256.png', 256),
      const _SquareTarget('assets/branding/ember_app_icon_192.png', 192),
      const _SquareTarget('assets/branding/ember_app_icon_128.png', 128),
      const _SquareTarget(
        'android/app/src/main/res/mipmap-mdpi/ic_launcher.png',
        48,
      ),
      const _SquareTarget(
        'android/app/src/main/res/mipmap-hdpi/ic_launcher.png',
        72,
      ),
      const _SquareTarget(
        'android/app/src/main/res/mipmap-xhdpi/ic_launcher.png',
        96,
      ),
      const _SquareTarget(
        'android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png',
        144,
      ),
      const _SquareTarget(
        'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png',
        192,
      ),
      const _SquareTarget(
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png',
        20,
      ),
      const _SquareTarget(
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png',
        40,
      ),
      const _SquareTarget(
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png',
        60,
      ),
      const _SquareTarget(
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png',
        29,
      ),
      const _SquareTarget(
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png',
        58,
      ),
      const _SquareTarget(
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png',
        87,
      ),
      const _SquareTarget(
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png',
        40,
      ),
      const _SquareTarget(
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png',
        80,
      ),
      const _SquareTarget(
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png',
        120,
      ),
      const _SquareTarget(
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png',
        120,
      ),
      const _SquareTarget(
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png',
        180,
      ),
      const _SquareTarget(
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png',
        76,
      ),
      const _SquareTarget(
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png',
        152,
      ),
      const _SquareTarget(
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png',
        167,
      ),
      const _SquareTarget(
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png',
        1024,
      ),
    ];

    for (final target in iconTargets) {
      await _renderPng(
        tester,
        width: target.size,
        height: target.size,
        outputPath: target.path,
        child: const _IconArtwork(),
      );
    }

    await _renderPng(
      tester,
      width: 1800,
      height: 720,
      outputPath: 'assets/branding/ember_logo.png',
      child: const _HorizontalLogoArtwork(),
    );

    await _renderPng(
      tester,
      width: 720,
      height: 720,
      outputPath: 'assets/branding/ember_splash_mark.png',
      child: const _SplashMarkArtwork(),
    );

    await _renderPng(
      tester,
      width: 168,
      height: 185,
      outputPath:
          'ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage.png',
      child: const _LaunchArtwork(),
    );

    await _renderPng(
      tester,
      width: 336,
      height: 370,
      outputPath:
          'ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@2x.png',
      child: const _LaunchArtwork(),
    );

    await _renderPng(
      tester,
      width: 504,
      height: 555,
      outputPath:
          'ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@3x.png',
      child: const _LaunchArtwork(),
    );
  });
}

final class _SquareTarget {
  const _SquareTarget(this.path, this.size);

  final String path;
  final int size;
}

Future<void> _renderPng(
  WidgetTester tester, {
  required int width,
  required int height,
  required String outputPath,
  required Widget child,
}) async {
  final boundaryKey = GlobalKey();
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = Size(width.toDouble(), height.toDouble());

  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: RepaintBoundary(
        key: boundaryKey,
        child: SizedBox(
          width: width.toDouble(),
          height: height.toDouble(),
          child: Theme(
            data: AppTheme.dark(),
            child: Material(child: child),
          ),
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();

  final boundary =
      boundaryKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  final image = await boundary.toImage(pixelRatio: 1.0);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  if (byteData == null) {
    throw StateError('Failed to encode image for $outputPath');
  }

  final file = File(outputPath);
  file.parent.createSync(recursive: true);
  file.writeAsBytesSync(byteData.buffer.asUint8List(), flush: true);
}

class _IconArtwork extends StatelessWidget {
  const _IconArtwork();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            const Color(0xFF130C0A),
            scheme.primary.withValues(alpha: 0.95),
            const Color(0xFF2B1711),
          ],
          begin: const Alignment(-0.9, -1),
          end: const Alignment(0.9, 1),
        ),
      ),
      child: const Center(
        child: FractionallySizedBox(
          widthFactor: 0.74,
          heightFactor: 0.74,
          child: FittedBox(child: BrandMark(size: 700, showWordmark: false)),
        ),
      ),
    );
  }
}

class _HorizontalLogoArtwork extends StatelessWidget {
  const _HorizontalLogoArtwork();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            const Color(0xFF130C0A),
            scheme.primary.withValues(alpha: 0.55),
            const Color(0xFF0F1917),
          ],
          begin: const Alignment(-1, -0.2),
          end: const Alignment(1, 0.2),
        ),
      ),
      child: const Center(child: BrandMark(size: 320, showWordmark: true)),
    );
  }
}

class _SplashMarkArtwork extends StatelessWidget {
  const _SplashMarkArtwork();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(-0.2, -0.3),
          radius: 1.15,
          colors: <Color>[
            scheme.primary.withValues(alpha: 0.26),
            const Color(0xFF130C0A),
          ],
        ),
      ),
      child: const Center(child: BrandMark(size: 280, showWordmark: true)),
    );
  }
}

class _LaunchArtwork extends StatelessWidget {
  const _LaunchArtwork();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: FittedBox(child: BrandMark(size: 126, showWordmark: false)),
    );
  }
}
