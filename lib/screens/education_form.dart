import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _institution = '';
  String _program = '';
  int? _startYear;
  int? _endYear;
  String _description = '';
  String _educationLevel = 'Bachelor';

  final List<String> _educationLevels = [
    'High School',
    'Associate',
    'Bachelor',
    'Master',
    'Doctorate',
    'Other',
  ];

  String? _validateYear(
    String? value, {
    required int? otherYear,
    bool isStart = false,
  }) {
    final year = int.tryParse(value?.trim() ?? '');
    if (year == null || year < 1900 || year > 9999) {
      return 'Enter a valid year (for example, 2024).';
    }
    if (otherYear != null && (isStart ? year > otherYear : year < otherYear)) {
      return isStart
          ? 'Start year must not be after end year.'
          : 'End year must not be before start year.';
    }
    return null;
  }

  void _saveEducation() {
    if (!_formKey.currentState!.validate()) return;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Education added'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Institution: ${_institution.trim()}'),
              Text('Program: ${_program.trim()}'),
              Text('Level: $_educationLevel'),
              Text('Years: $_startYear - $_endYear'),
              Text('Description: ${_description.trim()}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _institution = '';
                _program = '';
                _startYear = null;
                _endYear = null;
                _description = '';
                _educationLevel = 'Bachelor';
              });
              _formKey.currentState!.reset();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Education'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Institution',
                hintText: 'Enter your school or university',
                border: OutlineInputBorder(),
              ),
              onChanged: (String? value) {
                setState(() {
                  _institution = value ?? '';
                });
              },
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Institution is required.'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Degree or program',
                hintText: 'Enter your degree or field of study',
                border: OutlineInputBorder(),
              ),
              onChanged: (String? value) {
                setState(() {
                  _program = value ?? '';
                });
              },
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Degree or program is required.'
                  : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: 'Bachelor',
              decoration: const InputDecoration(
                labelText: 'Education level',
                border: OutlineInputBorder(),
              ),
              items: _educationLevels
                  .map(
                    (level) =>
                        DropdownMenuItem(value: level, child: Text(level)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _educationLevel = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Start year',
                      hintText: '2020',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _startYear = int.tryParse(value ?? '');
                      });
                    },
                    validator: (value) => _validateYear(
                      value,
                      otherYear: _endYear,
                      isStart: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'End year',
                      hintText: '2024',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _endYear = int.tryParse(value ?? '');
                      });
                    },
                    validator: (value) =>
                        _validateYear(value, otherYear: _startYear),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Add details about your studies',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              onChanged: (String? value) {
                setState(() {
                  _description = value ?? '';
                });
              },
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Description is required.'
                  : null,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveEducation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Save Education'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
