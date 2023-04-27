import 'package:bloodpoint/model/user_model.dart';
import 'package:bloodpoint/resources/firebase_auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> addUser(UserModel user) async {
    
    final ref = _firestore.collection("users");
    final DocumentReference docRef = ref.doc();
    user.id = docRef.id;
    // final DocumentReference docRef = 
    
    print(user);
    await ref.add(user.toMap());
    // final newUser = ref.copyWith(id: docRef.id);
    // await ref.set(user.toMap());
    await docRef.set(user.toMap());
    return user;
  }

  Future<void> deleteUser() async {
    final user = await FirebaseAuthProvider().getCurrentUser();
    await _firestore.collection('users').doc(user!.uid).delete();
  }
 


  Future<List<UserModel>> getUsers({String? bloodGroup}) async {
    late QuerySnapshot<Map<String, dynamic>> docs;
    if (bloodGroup != "All") {
      docs = await _firestore
          .collection('users')
          .where("blood", isEqualTo: bloodGroup)
          .get();
    } else {
      docs = await _firestore.collection('users').get();
    }
    return docs.docs
        .map<UserModel>((d) => UserModel.fromMap(d.data()))
        .toList();
  }

Future<UserModel?> getUser() async {
    final user = await FirebaseAuthProvider().getCurrentUser();
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!);
}


  Future<void> updateUser(UserModel user) async {
    final userr = await FirebaseAuthProvider().getCurrentUser();
    await _firestore
        .collection('users')
        .doc(userr!.uid)
        .update(user.toMap());
  }
}


