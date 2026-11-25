import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/screens/experience_detail_screen.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('app renders the portfolio home screen', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(MyApp(apiClient: ApiClient()));

    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('Selamat datang di MyPortfolio Mobile!'), findsOneWidget);
    expect(find.text('Lihat Pengalaman'), findsOneWidget);
  });

  testWidgets('Lihat Pengalaman opens the experience list', (tester) async {
    final apiClient = ApiClient(
      client: MockClient((request) async {
        expect(request.url.path, '/api/v1/experience/');
        return http.Response('[]', 200);
      }),
    );

    await tester.pumpWidget(MyApp(apiClient: apiClient));
    await tester.tap(find.text('Lihat Pengalaman'));
    await tester.pumpAndSettle();

    expect(find.text('Pengalaman'), findsOneWidget);
    expect(find.text('No experiences found.'), findsOneWidget);
  });

  testWidgets('login screen validates empty fields', (tester) async {
    final apiClient = ApiClient();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(value: apiClient),
          ChangeNotifierProvider(create: (_) => AuthState(apiClient)),
        ],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    expect(find.widgetWithText(AppBar, 'Login'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();

    expect(find.text('Username cannot be empty!'), findsOneWidget);
    expect(find.text('Password cannot be empty!'), findsOneWidget);
  });

  testWidgets('experience details handle empty optional fields', (
    tester,
  ) async {
    const experience = Experience(
      title: '',
      description: '',
      category: '',
      thumbnail: '',
    );

    await tester.pumpWidget(
      const MaterialApp(home: ExperienceDetailScreen(experience: experience)),
    );

    expect(find.text('Experience details'), findsOneWidget);
    expect(find.text('No description available.'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });
}
