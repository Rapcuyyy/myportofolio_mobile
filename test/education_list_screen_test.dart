import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/education_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('shows loading then the empty state', (tester) async {
    final response = Completer<http.Response>();
    final apiClient = ApiClient(client: MockClient((_) => response.future));

    await tester.pumpWidget(_app(apiClient));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    response.complete(http.Response('[]', 200));
    await tester.pumpAndSettle();

    expect(find.text('No education records found.'), findsOneWidget);
  });

  testWidgets('shows an error and retries the request', (tester) async {
    var requestCount = 0;
    final apiClient = ApiClient(
      client: MockClient((_) async {
        requestCount++;
        if (requestCount == 1) {
          return http.Response('server error', 500);
        }
        return http.Response(
          jsonEncode([
            {
              'id': 'education-1',
              'institution': 'Example University',
              'program': 'Computer Science',
              'education_level': 'Bachelor',
              'start_year': 2020,
              'end_year': 2024,
              'description': 'Software engineering.',
            },
          ]),
          200,
        );
      }),
    );

    await tester.pumpWidget(_app(apiClient));
    await tester.pumpAndSettle();

    expect(find.textContaining('Failed to load education:'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(requestCount, 2);
    expect(find.text('Example University'), findsOneWidget);
    expect(find.textContaining('Computer Science'), findsOneWidget);

    await tester.tap(find.text('Example University'));
    await tester.pumpAndSettle();

    expect(find.text('Education details'), findsOneWidget);
    expect(find.text('ID'), findsOneWidget);
    expect(find.text('education-1'), findsOneWidget);
    expect(find.text('Institution'), findsOneWidget);
    expect(find.text('Example University'), findsNWidgets(2));
    expect(find.text('Program'), findsOneWidget);
    expect(find.text('Computer Science'), findsOneWidget);
    expect(find.text('Education level'), findsOneWidget);
    expect(find.text('Bachelor'), findsOneWidget);
    expect(find.text('Start year'), findsOneWidget);
    expect(find.text('2020'), findsOneWidget);
    expect(find.text('End year'), findsOneWidget);
    expect(find.text('2024'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Software engineering.'), findsOneWidget);
  });
}

Widget _app(ApiClient apiClient) {
  return MultiProvider(
    providers: [Provider.value(value: apiClient)],
    child: const MaterialApp(home: EducationListScreen()),
  );
}
