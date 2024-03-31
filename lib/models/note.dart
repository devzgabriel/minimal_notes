import 'package:isar/isar.dart';

// This line is needed to generate the file
// The run: dart run build_runner build
part 'note.g.dart';

@Collection()
class Note {
  Id id = Isar.autoIncrement;
  late String text;
}
