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

  String? _validateRequiredText(
    String? value,
    String fieldName, {
    int? maxLength = 50,
  }) {
    final trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) {
      return '$fieldName is required.';
    }
    if (maxLength != null && trimmedValue.length > maxLength) {
      return '$fieldName must be $maxLength characters or fewer.';
    }
    return null;
  }

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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Center(child: Text('Add Education Form')),
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
              maxLength: 50,
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
              validator: (value) => _validateRequiredText(value, 'Institution'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLength: 50,
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
              validator: (value) =>
                  _validateRequiredText(value, 'Degree or program'),
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
              validator: (value) =>
                  value == null ? 'Education level is required.' : null,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _educationLevel = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
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
              validator: (value) =>
                  _validateYear(value, otherYear: _endYear, isStart: true),
            ),
            const SizedBox(height: 16),
            TextFormField(
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
              validator: (value) => _validateYear(value, otherYear: _startYear),
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
              validator: (value) =>
                  _validateRequiredText(value, 'Description', maxLength: null),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _saveEducation,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.indigo),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
