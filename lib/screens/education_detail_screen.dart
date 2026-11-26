import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/education.dart';

class EducationDetailScreen extends StatelessWidget {
  const EducationDetailScreen({super.key, required this.education});

  final Education education;

  @override
  Widget build(BuildContext context) {
    final title = education.institution.trim();
    final description = education.description.trim();

    return Scaffold(
      appBar: AppBar(
        title: Text(title.isNotEmpty ? title : 'Education details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Education details',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            _detailRow('ID', education.id ?? 'Not available'),
            _detailRow(
              'Institution',
              title.isNotEmpty ? title : 'Not provided',
            ),
            _detailRow('Program', education.program),
            _detailRow('Education level', education.educationLevel),
            _detailRow('Start year', education.startYear.toString()),
            _detailRow('End year', education.endYear?.toString() ?? 'Present'),
            _detailRow(
              'Description',
              description.isNotEmpty ? description : 'No description provided.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }
}
