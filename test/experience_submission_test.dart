import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

void main() {
  const experience = Experience(
    title: 'Research assistant',
    description: 'Supported a university research project.',
    category: 'research',
    thumbnail: 'https://example.test/thumbnail.png',
  );

  test(
    'createExperience sends serializer fields and accepts 201 Created',
    () async {
      final apiClient = ApiClient(
        baseUrl: 'https://example.test',
        client: MockClient((request) async {
          expect(request.method, 'POST');
          expect(request.url.path, '/api/v1/experience/');
          expect(request.headers['Authorization'], 'Token test-token');
          expect(jsonDecode(request.body), {
            'title': experience.title,
            'description': experience.description,
            'category': experience.category,
            'thumbnail': experience.thumbnail,
          });
          return http.Response(
            jsonEncode({
              'id': 'experience-1',
              'title': experience.title,
              'description': experience.description,
              'category': experience.category,
              'thumbnail': experience.thumbnail,
            }),
            201,
          );
        }),
      );

      final created = await apiClient.createExperience(
        experience,
        token: 'test-token',
      );

      expect(created.id, 'experience-1');
      expect(created.title, experience.title);
    },
  );

  test('createExperience rejects a success response other than 201', () async {
    final apiClient = ApiClient(
      client: MockClient((_) async => http.Response('{}', 200)),
    );

    await expectLater(
      apiClient.createExperience(experience, token: 'test-token'),
      throwsA(
        isA<ApiException>().having(
          (error) => error.statusCode,
          'statusCode',
          200,
        ),
      ),
    );
  });

  test('logout clears local auth state even when the API call fails', () async {
    final authState = AuthState(
      ApiClient(
        client: MockClient((_) async => http.Response('unauthorized', 401)),
      ),
      initialToken: 'expired-token',
    );

    await expectLater(authState.logout(), throwsA(isA<ApiException>()));

    expect(authState.isLoggedIn, isFalse);
  });
}
