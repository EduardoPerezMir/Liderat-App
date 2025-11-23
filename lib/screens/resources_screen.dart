import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final resources = [
      ("TED: Leadership", Uri.parse("https://www.ted.com/topics/leadership")),
      ("Matriz de estilos de liderazgo", Uri.parse("https://www.mindtools.com/a57iqp7/leadership-style-matrix/")),
      ("The Five Dysfunctions of a Team (Resumen)", Uri.parse("https://www.tablegroup.com/topics-and-resources/teamwork-5-dysfunctions/")),
      ("Harvard: Leadership", Uri.parse("https://hbr.org/topic/leadership")),
      ("Forbes: Leadership", Uri.parse("https://www.forbes.com/leadership/")),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Recursos adicionales")),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: resources.length,
        separatorBuilder: (_, _) => const Divider(),
        itemBuilder: (context, i) {
          final (title, uri) = resources[i];
          return ListTile(
            title: Text(title),
            trailing: const Icon(Icons.open_in_new),
            onTap: () async {
              if (await canLaunchUrl(uri)) { await launchUrl(uri, mode: LaunchMode.externalApplication); }
            },
          );
        },
      ),
    );
  }
}

