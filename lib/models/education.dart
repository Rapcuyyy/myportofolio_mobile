import 'package:json_annotation/json_annotation.dart';

part 'education.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Education {
  const Education({
    this.id,
    required this.institution,
    required this.program,
    this.educationLevel = 'Bachelor',
    required this.startYear,
    this.endYear,
    this.description = '',
  });

  @JsonKey(includeToJson: false)
  final String? id;

  final String institution;
  final String program;

  @JsonKey(defaultValue: 'Bachelor')
  final String educationLevel;

  final int startYear;
  final int? endYear;

  @JsonKey(defaultValue: '')
  final String description;

  factory Education.fromJson(Map<String, dynamic> json) =>
      _$EducationFromJson(json);

  Map<String, dynamic> toJson() => _$EducationToJson(this);
}
