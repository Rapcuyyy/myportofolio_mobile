import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('saving valid education opens the updated education list', (
    tester,
  ) async {
    final apiClient = ApiClient(
      baseUrl: 'https://example.test',
      client: MockClient((request) async {
        if (request.method == 'POST') {
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
          return http.Response(jsonEncode(_educationJson), 201);
        }

        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/education/');
        return http.Response(jsonEncode([_educationJson]), 200);
      }),
    );
    final authState = AuthState(apiClient, initialToken: 'test-token');

    await _pumpForm(tester, apiClient, authState);
    await _fillAndSave(tester);

    expect(find.text('Education added'), findsOneWidget);
    await tester.tap(find.text('View education'));
    await tester.pumpAndSettle();

    expect(find.text('Pendidikan'), findsOneWidget);
    expect(find.text('Example University'), findsOneWidget);
  });

  testWidgets('API errors are shown in a SnackBar', (tester) async {
    final apiClient = ApiClient(
      client: MockClient((_) async => http.Response('bad request', 400)),
    );
    final authState = AuthState(apiClient, initialToken: 'test-token');

    await _pumpForm(tester, apiClient, authState);
    await _fillAndSave(tester);

    expect(find.text('Could not add education (HTTP 400).'), findsOneWidget);
  });

  testWidgets('401 clears the session and prompts for login', (tester) async {
    final apiClient = ApiClient(
      client: MockClient((request) async {
        if (request.url.path == '/api/v1/education/') {
          return http.Response('unauthorized', 401);
        }
        expect(request.url.path, '/api/v1/auth/logout/');
        return http.Response('', 204);
      }),
    );
    final authState = AuthState(apiClient, initialToken: 'expired-token');

    await _pumpForm(tester, apiClient, authState);
    await _fillAndSave(tester);
    await tester.pump(const Duration(milliseconds: 100));

    expect(authState.isLoggedIn, isFalse);
    expect(find.byType(LoginScreen), findsOneWidget);

    Navigator.of(tester.element(find.byType(LoginScreen))).pop(false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Session expired. Please log in again.'), findsOneWidget);
  });
}

const _educationJson = {
  'id': 'education-1',
  'institution': 'Example University',
  'program': 'Computer Science',
  'education_level': 'Bachelor',
  'start_year': 2020,
  'end_year': 2024,
  'description': 'Studied software engineering.',
};

Future<void> _pumpForm(
  WidgetTester tester,
  ApiClient apiClient,
  AuthState authState,
) async {
  await tester.binding.setSurfaceSize(const Size(800, 1200));
  addTearDown(() => tester.binding.setSurfaceSize(null));

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
}

Future<void> _fillAndSave(WidgetTester tester) async {
  await tester.enterText(
    find.byType(TextFormField).at(0),
    'Example University',
  );
  await tester.enterText(find.byType(TextFormField).at(1), 'Computer Science');
  await tester.enterText(find.byType(TextFormField).at(2), '2020');
  await tester.enterText(find.byType(TextFormField).at(3), '2024');
  await tester.enterText(
    find.byType(TextFormField).at(4),
    'Studied software engineering.',
  );
  await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}
