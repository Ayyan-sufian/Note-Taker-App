import 'package:hive/hive.dart';

part 'notes_model.g.dart';
/// Create a model for notes
@HiveType(typeId: 0)
class NotesModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String content;

  NotesModel({required this.id, required this.title, required this.content});
}
