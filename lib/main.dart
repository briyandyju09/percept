import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/hive/hive_setup.dart';
import 'data/repositories/content_repository.dart';
import 'state/repository_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setUpHive();

  final content = ContentRepository();
  await content.load();

  runApp(
    ProviderScope(
      overrides: [contentRepositoryProvider.overrideWithValue(content)],
      child: const PerceptApp(),
    ),
  );
}
