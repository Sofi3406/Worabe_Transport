import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worabe_transport/core/localization/locale_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final selected = locale?.languageCode ?? 'en';

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const ListTile(
            title: Text('Language'),
            subtitle: Text('English and Amharic are supported.'),
          ),
          RadioListTile<String>(
            title: const Text('English'),
            value: 'en',
            groupValue: selected,
            onChanged: (v) {
              if (v != null) ref.read(localeProvider.notifier).setLocale(v);
            },
          ),
          RadioListTile<String>(
            title: const Text('Amharic (አማርኛ)'),
            value: 'am',
            groupValue: selected,
            onChanged: (v) {
              if (v != null) ref.read(localeProvider.notifier).setLocale(v);
            },
          ),
        ],
      ),
    );
  }
}
