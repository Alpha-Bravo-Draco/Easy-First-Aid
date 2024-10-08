import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_first_aid/model/inventoryModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseServices {
  User? user = FirebaseAuth.instance.currentUser;

  // Get reference to the user's todos subcollection
  CollectionReference get todoCollection {
    return FirebaseFirestore.instance
        .collection("users") // Parent collection "users"
        .doc(user!.uid) // Document with user's uid
        .collection("todos"); // Subcollection "todos"
  }

  // Add a new todo task to the user's subcollection
  Future<DocumentReference> addTodoTask(
      String title, String description) async {
    return await todoCollection.add({
      'title': title,
      'description': description,
      'completed': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Update a todo item in the user's subcollection
  Future<void> updateTodo(String id, String title, String description) async {
    final todoDoc = todoCollection.doc(id);
    return await todoDoc.update({
      'title': title,
      'description': description,
    });
  }

  // Update the completion status of a todo task
  Future<void> updateTodoStatus(String id, bool completed) async {
    return await todoCollection.doc(id).update({'completed': completed});
  }

  // Delete a todo task from the user's subcollection
  Future<void> deleteTodoTask(String id) async {
    return await todoCollection.doc(id).delete();
  }

  // Get the pending tasks for the current user
  Stream<List<Todo>> get todos {
    return todoCollection
        .where('completed', isEqualTo: false)
        .snapshots()
        .map(_todoListFromSnapshot);
  }

  // Get the completed tasks for the current user
  Stream<List<Todo>> get completedTodos {
    return todoCollection
        .where('completed', isEqualTo: true)
        .snapshots()
        .map(_todoListFromSnapshot);
  }

  // Convert the Firestore snapshot to a list of Todo objects
  List<Todo> _todoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Todo(
        id: doc.id,
        timestamp: doc['createdAt'] ?? "",
        title: doc['title'] ?? "",
        description: doc['description'] ?? "",
        completed: doc['completed'] ?? false,
      );
    }).toList();
  }
}
