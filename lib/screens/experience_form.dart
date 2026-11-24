import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _description = '';
  String _category = 'full-time';
  String _thumbnail = '';
  bool _isSubmitting = false;

  final List<String> _categories = [
    'internship',
    'research',
    'volunteer',
    'part-time',
    'full-time',
    'freelance',
  ];

  Future<void> _submit() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final isLoggedIn = await ensureLoggedIn(context);
      if (!mounted || !isLoggedIn) return;

      final authState = context.read<AuthState>();
      final token = authState.token;
      if (token == null) {
        _showSnackBar('Please log in to add an experience.');
        return;
      }

      final newProject = Experience(
        title: _title.trim(),
        description: _description.trim(),
        category: _category,
        thumbnail: _thumbnail.trim(),
      );
      final createdProject = await context.read<ApiClient>().createExperience(
        newProject,
        token: token,
      );
      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Experience added'),
          content: Text('“${createdProject.title}” was created successfully.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      if (!mounted) return;
      _formKey.currentState!.reset();
      setState(() {
        _title = '';
        _description = '';
        _category = 'full-time';
        _thumbnail = '';
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

        _showSnackBar(message);
        await ensureLoggedIn(context);
      } else {
        _showSnackBar('Could not add experience (HTTP ${error.statusCode}).');
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
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Experience Form')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Experience Name ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Nama Pengalaman",
                    labelText: "Nama Pengalaman",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) => _title = value,
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Experience title cannot be empty.';
                    }
                    return null;
                  },
                ),
              ),

              // === Description ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Deskripsi Pengalaman",
                    labelText: "Deskripsi Pengalaman",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) => _description = value,
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Experience description cannot be empty.';
                    }
                    return null;
                  },
                ),
              ),

              // === Category ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Kategori Pengalaman",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialValue: _category,
                  items: _categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(
                            category
                                .split('-')
                                .map(
                                  (part) =>
                                      '${part[0].toUpperCase()}${part.substring(1)}',
                                )
                                .join('-'),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) _category = value;
                  },
                ),
              ),

              // === Sertif Link ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "URL Sertifikat (opsional)",
                    labelText: "Tautan Sertifikat",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) => _thumbnail = value,
                ),
              ),

              // Tombol Simpan
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
