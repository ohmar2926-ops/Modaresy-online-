
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<String> createClass({
    required String teacherId,
    required String title,
    required String subject,
    required String date,
    required String time,
  }) async {
    final ref = await _db.collection('classes').add({
      'teacherId': teacherId,
      'title': title,
      'subject': subject,
      'date': date,
      'time': time,
      'studentIds': <String>[],
      'createdAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> teacherClasses(String teacherId) =>
      _db.collection('classes')
        .where('teacherId', isEqualTo: teacherId)
        .orderBy('createdAt', descending: true)
        .snapshots();

  Future<void> addStudentToClass(String classId, String studentId) =>
      _db.collection('classes').doc(classId).update({
        'studentIds': FieldValue.arrayUnion([studentId])
      });

  Stream<QuerySnapshot<Map<String, dynamic>>> studentClasses(String studentId) =>
      _db.collection('classes')
        .where('studentIds', arrayContains: studentId)
        .snapshots();

  Future<String> createAssignment({
    required String teacherId,
    required String classId,
    required String title,
    required String description,
    required DateTime dueDate,
  }) async {
    final ref = await _db.collection('assignments').add({
      'teacherId': teacherId,
      'classId': classId,
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'createdAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }
}
