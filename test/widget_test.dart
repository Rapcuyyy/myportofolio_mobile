import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
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
}
