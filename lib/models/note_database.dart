import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:minimal_notes/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;

// 👇 Initialize the database
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [NoteSchema],
      directory: dir.path,
    );
  }

// 👇 List of notes
  final List<Note> currentNotes = [];

// 👇 Add a note
  Future<void> addNote(String text) async {
    final note = Note()..text = text;
    await isar.writeTxn(() => isar.notes.put(note));
    fetchNotes();
  }

// 👇 Read
  Future<void> fetchNotes() async {
    List<Note> fetchedNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);

    notifyListeners();
  }

// 👇 Update
  Future<void> updateNote(int id, String text) async {
    final note = await isar.notes.get(id);
    if (note != null) {
      note.text = text;
      await isar.writeTxn(() => isar.notes.put(note));
      fetchNotes();
    }
  }

// 👇 Delete
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    fetchNotes();
  }
}
