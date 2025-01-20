import 'package:firebase_database/firebase_database.dart';

final DatabaseReference _database = FirebaseDatabase.instance
    .refFromURL('https://workout-planner-shashi-default-rtdb.firebaseio.com/');

Future<void> makeNewUser(String name, String password) async {
  try {
    await _database
        .child("users")
        .push()
        .set({"name": name, "password": password});
  } catch (e) {
    // print("error $e");
  }
}

Future<bool> verifyUser(String name, String password) async {
  bool verifiedUser = false;
  try {
    DataSnapshot dataSnapshot = await _database.child("users").get();

    if (dataSnapshot.exists) {
      // Loop through each child node under "users"
      final users = dataSnapshot.value as Map<dynamic, dynamic>;
      users.forEach((key, value) {
        if (value['name'] == name) {
          if (value['password'] == password) {
            verifiedUser = true;
          }
        }
      });
    }
  } catch (e) {
    // print("error $e");
  }

  return verifiedUser;
}
