import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('saving valid education posts it with the auth token', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final apiClient = ApiClient(
      baseUrl: 'https://example.test',
      client: MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/v1/education/');
        expect(request.headers['Authorization'], 'Token test-token');
        expect(jsonDecode(request.body), {
          'institution': 'Example University',
          'program': 'Computer Science',
          'education_level': 'Bachelor',
          'start_year': 2020,
          'end_year': 2024,
          'description': 'Studied software engineering.',
        });
        return http.Response(
          jsonEncode({
            'id': 'education-1',
            'institution': 'Example University',
            'program': 'Computer Science',
            'education_level': 'Bachelor',
            'start_year': 2020,
            'end_year': 2024,
            'description': 'Studied software engineering.',
          }),
          201,
        );
      }),
    );
    final authState = AuthState(apiClient, initialToken: 'test-token');

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(value: apiClient),
          ChangeNotifierProvider.value(value: authState),
        ],
        child: const MaterialApp(home: EducationFormPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Example University',
    );
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Computer Science',
    );
    await tester.enterText(find.byType(TextFormField).at(2), '2020');
    await tester.enterText(find.byType(TextFormField).at(3), '2024');
    await tester.enterText(
      find.byType(TextFormField).at(4),
      'Studied software engineering.',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Education added'), findsOneWidget);
    expect(find.text('Institution: Example University'), findsOneWidget);
  });
}
