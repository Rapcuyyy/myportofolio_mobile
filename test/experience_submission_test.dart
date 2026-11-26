import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/education.dart';
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
  const education = Education(
    institution: 'Example University',
    program: 'Computer Science',
    educationLevel: 'Bachelor',
    startYear: 2020,
    endYear: 2024,
    description: 'Studied software engineering.',
  );

  test('getEducations requests and decodes the education list', () async {
    final apiClient = ApiClient(
      baseUrl: 'https://example.test',
      client: MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/education/');
        return http.Response(
          jsonEncode([
            {
              'id': 'education-1',
              'institution': education.institution,
              'program': education.program,
              'education_level': education.educationLevel,
              'start_year': education.startYear,
              'end_year': education.endYear,
              'description': education.description,
            },
          ]),
          200,
        );
      }),
    );

    final educations = await apiClient.getEducations();

    expect(educations, hasLength(1));
    expect(educations.single.id, 'education-1');
    expect(educations.single.institution, education.institution);
  });

  test(
    'createEducation sends serializer fields and Token authorization',
    () async {
      final apiClient = ApiClient(
        baseUrl: 'https://example.test',
        client: MockClient((request) async {
          expect(request.method, 'POST');
          expect(request.url.path, '/api/v1/education/');
          expect(request.headers['Authorization'], 'Token test-token');
          expect(jsonDecode(request.body), {
            'institution': education.institution,
            'program': education.program,
            'education_level': education.educationLevel,
            'start_year': education.startYear,
            'end_year': education.endYear,
            'description': education.description,
          });
          return http.Response(
            jsonEncode({
              'id': 'education-1',
              'institution': education.institution,
              'program': education.program,
              'education_level': education.educationLevel,
              'start_year': education.startYear,
              'end_year': education.endYear,
              'description': education.description,
            }),
            201,
          );
        }),
      );

      final created = await apiClient.createEducation(
        education,
        token: 'test-token',
      );

      expect(created.id, 'education-1');
      expect(created.institution, education.institution);
    },
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
