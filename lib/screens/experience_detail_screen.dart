import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/experience.dart';

class ExperienceDetailScreen extends StatelessWidget {
  const ExperienceDetailScreen({super.key, required this.experience});

  final Experience experience;

  @override
  Widget build(BuildContext context) {
    final title = experience.title.trim();
    final category = experience.category.trim();
    final description = experience.description.trim();
    final imageUrl = experience.thumbnail.trim();

    return Scaffold(
      appBar: AppBar(
        title: Text(title.isNotEmpty ? title : 'Experience details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    final expectedBytes = loadingProgress.expectedTotalBytes;
                    return SizedBox(
                      height: 220,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: expectedBytes == null
                              ? null
                              : loadingProgress.cumulativeBytesLoaded /
                                    expectedBytes,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => const SizedBox(
                    height: 220,
                    child: Center(
                      child: Icon(Icons.broken_image_outlined, size: 40),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
            if (title.isNotEmpty)
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
            if (category.isNotEmpty) _metadataRow('Category', category),
            if (experience.startedAt != null)
              _metadataRow('Started', _formatDate(experience.startedAt!)),
            if (experience.endedAt != null)
              _metadataRow('Ended', _formatDate(experience.endedAt!)),
            if (experience.starCount > 0)
              _metadataRow('Stars', experience.starCount.toString()),
            if (experience.starredByNames.trim().isNotEmpty)
              _metadataRow('Recognized by', experience.starredByNames.trim()),
            const SizedBox(height: 16),
            Text('Description', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              description.isNotEmpty
                  ? description
                  : 'No description available.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _metadataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
