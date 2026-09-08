import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'routing/app_router.dart';
import 'state/profile_providers.dart';
import 'state/settings_providers.dart';
import 'theme/percept_theme.dart';

class PerceptApp extends ConsumerStatefulWidget {
  const PerceptApp({super.key});

  @override
  ConsumerState<PerceptApp> createState() => _PerceptAppState();
}

class _PerceptAppState extends ConsumerState<PerceptApp> {
  late final router = buildRouter(
    onboardingCompleted: ref.read(profileProvider).onboardingCompleted,
  );

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final brightness = switch (settings.themeMode) {
      'light' => Brightness.light,
      'dark' => Brightness.dark,
      _ => MediaQuery.platformBrightnessOf(context),
    };
    final theme = brightness == Brightness.dark
        ? PerceptTheme.dark
        : PerceptTheme.light;

    return CupertinoApp.router(
      title: 'Percept',
      debugShowCheckedModeBanner: false,
      theme: theme,
      routerConfig: router,
      builder: (context, child) {
        // Force the chosen brightness down through the tree regardless of
        // system setting, since CupertinoApp.router's `theme` alone doesn't
        // override MediaQuery's platformBrightness for descendants that
        // read it directly.
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(platformBrightness: brightness),
          child: child!,
        );
      },
    );
  }
}
