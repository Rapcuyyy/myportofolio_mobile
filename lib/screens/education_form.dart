import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/screens/education_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

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
  bool _isCheckingAuthentication = true;
  bool _isSubmitting = false;

  final List<String> _educationLevels = [
    'High School',
    'Associate',
    'Bachelor',
    'Master',
    'Doctorate',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureAccess());
  }

  Future<void> _ensureAccess() async {
    final allowed = await ensureLoggedIn(context);
    if (!mounted) return;
    if (!allowed) {
      Navigator.of(context).maybePop();
      return;
    }

    setState(() {
      _isCheckingAuthentication = false;
    });
  }

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

  Future<void> _saveEducation() async {
    if (_isSubmitting) return;

    final allowed = await ensureLoggedIn(context);
    if (!mounted || !allowed) return;
    if (!_formKey.currentState!.validate()) return;

    final token = context.read<AuthState>().token;
    if (token == null) {
      _showSnackBar('Please log in to add education.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final education = Education(
        institution: _institution.trim(),
        program: _program.trim(),
        educationLevel: _educationLevel,
        startYear: _startYear!,
        endYear: _endYear,
        description: _description.trim(),
      );
      final createdEducation = await context.read<ApiClient>().createEducation(
        education,
        token: token,
      );
      if (!mounted) return;

      final viewEducationList = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Education added'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Institution: ${createdEducation.institution}'),
                Text('Program: ${createdEducation.program}'),
                Text('Level: ${createdEducation.educationLevel}'),
                Text(
                  'Years: ${createdEducation.startYear} - '
                  '${createdEducation.endYear}',
                ),
                Text('Description: ${createdEducation.description}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Add another'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('View education'),
            ),
          ],
        ),
      );

      if (!mounted) return;
      if (viewEducationList == true) {
        Navigator.of(context).pushReplacement<void, void>(
          MaterialPageRoute<void>(
            builder: (context) => const EducationListScreen(),
          ),
        );
        return;
      }

      if (viewEducationList == null) return;
      _formKey.currentState!.reset();
      setState(() {
        _institution = '';
        _program = '';
        _startYear = null;
        _endYear = null;
        _description = '';
        _educationLevel = 'Bachelor';
      });
    } on ApiException catch (error) {
      if (!mounted) return;

      if (error.statusCode == 401) {
        var message = 'Session expired. Please log in again.';
        try {
          await context.read<AuthState>().logout();
        } on ApiException catch (logoutError) {
          message =
              'Session expired (logout error ${logoutError.statusCode}). '
              'Please log in again.';
        }
        if (!mounted) return;

        await ensureLoggedIn(context);
        if (!mounted) return;
        _showSnackBar(message);
      } else {
        _showSnackBar('Could not add education (HTTP ${error.statusCode}).');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Add Education'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: _isCheckingAuthentication
          ? const Center(child: CircularProgressIndicator())
          : Form(
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
                    validator: (value) =>
                        _validateRequiredText(value, 'Institution'),
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
                          (level) => DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          ),
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
                    validator: (value) => _validateYear(
                      value,
                      otherYear: _endYear,
                      isStart: true,
                    ),
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
                    validator: (value) =>
                        _validateYear(value, otherYear: _startYear),
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
                    validator: (value) => _validateRequiredText(
                      value,
                      'Description',
                      maxLength: null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _saveEducation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: _isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
