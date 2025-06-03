import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference inboxCollection =
      FirebaseFirestore.instance.collection("inboxes");
  final CollectionReference contactCollection =
      FirebaseFirestore.instance.collection("contacts"); // Add this line

  // Update user data (already exists)
  Future updateUser(String fullname, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullname,
      "email": email,
      "profilePic": "",
      "uid": uid,
      "isBanned": false, // Add isBanned field for admin functionality
    });
  }

  // Get user data by email (already exists)
  Future getuserdata(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // Create a new temporary inbox
  Future<String> createInbox() async {
    String emailAddress =
        "temp${DateTime.now().millisecondsSinceEpoch}@zoidmail.com";
    Timestamp expiryTime =
        Timestamp.fromDate(DateTime.now().add(Duration(hours: 1)));

    await inboxCollection.doc(emailAddress).set({
      "userId": uid,
      "emailAddress": emailAddress,
      "createdAt": Timestamp.now(),
      "expiresAt": expiryTime,
      "isActive": true,
    });

    // Simulate an email (for demo purposes)
    await inboxCollection.doc(emailAddress).collection("emails").add({
      "subject": "Welcome to ZoidMail!",
      "sender": "system@zoidmail.com",
      "body": "This is your temporary inbox. It will expire in 1 hour.",
      "receivedAt": Timestamp.now(),
    });

    return emailAddress;
  }

  // Get user's active inboxes
  Future<List<Map<String, dynamic>>> getUserInboxes() async {
    QuerySnapshot snapshot = await inboxCollection
        .where("userId", isEqualTo: uid)
        .where("isActive", isEqualTo: true)
        .get();

    List<Map<String, dynamic>> inboxes = [];
    for (var doc in snapshot.docs) {
      Timestamp expiresAt = doc["expiresAt"];
      if (expiresAt.toDate().isBefore(DateTime.now())) {
        await doc.reference.update({"isActive": false});
      } else {
        inboxes.add({
          "emailAddress": doc["emailAddress"],
          "expiresAt": expiresAt.toDate(),
        });
      }
    }
    return inboxes;
  }

  // Get emails for an inbox
  Future<List<Map<String, dynamic>>> getEmails(String emailAddress) async {
    QuerySnapshot snapshot = await inboxCollection
        .doc(emailAddress)
        .collection("emails")
        .orderBy("receivedAt", descending: true)
        .get();

    return snapshot.docs
        .map((doc) => {
              "id": doc.id,
              "subject": doc["subject"],
              "sender": doc["sender"],
              "body": doc["body"],
              "receivedAt": doc["receivedAt"].toDate(),
            })
        .toList();
  }

  // Delete an email
  Future<void> deleteEmail(String emailAddress, String emailId) async {
    await inboxCollection
        .doc(emailAddress)
        .collection("emails")
        .doc(emailId)
        .delete();
  }

  // Delete an inbox
  Future<void> deleteInbox(String emailAddress) async {
    await inboxCollection.doc(emailAddress).update({"isActive": false});
    QuerySnapshot emailSnapshot =
        await inboxCollection.doc(emailAddress).collection("emails").get();
    for (var doc in emailSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  // --- Contact Form Functions ---

  // Submit contact form
  Future<bool> submitContactForm({
    required String subject,
    required String email,
    required String message,
  }) async {
    try {
      await contactCollection.add({
        "userId": uid, // Will be null if user is not logged in
        "subject": subject,
        "email": email,
        "message": message,
        "submittedAt": Timestamp.now(),
        "isResolved": false, // Track if admin has resolved the issue
        "adminResponse": "", // For admin to add response
      });
      return true; // Success
    } catch (e) {
      print("Error submitting contact form: $e");
      return false; // Failed
    }
  }

  // Get all contact submissions (for admin)
  Future<List<Map<String, dynamic>>> getAllContactSubmissions() async {
    QuerySnapshot snapshot =
        await contactCollection.orderBy("submittedAt", descending: true).get();

    return snapshot.docs
        .map((doc) => {
              "id": doc.id,
              "userId": doc["userId"],
              "subject": doc["subject"],
              "email": doc["email"],
              "message": doc["message"],
              "submittedAt": doc["submittedAt"].toDate(),
              "isResolved": doc["isResolved"] ?? false,
              "adminResponse": doc["adminResponse"] ?? "",
            })
        .toList();
  }

  // Mark contact submission as resolved (for admin)
  Future<void> resolveContactSubmission(
      String contactId, String adminResponse) async {
    await contactCollection.doc(contactId).update({
      "isResolved": true,
      "adminResponse": adminResponse,
      "resolvedAt": Timestamp.now(),
    });
  }

  // --- Admin Functions ---

  // Get all users
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    QuerySnapshot snapshot = await userCollection.get();
    return snapshot.docs
        .map((doc) => {
              "uid": doc.id,
              "email": doc["email"],
              "fullName": doc["fullName"],
              "isBanned": doc["isBanned"] ?? false,
            })
        .toList();
  }

  // Ban/unban a user
  Future<void> setUserBanStatus(String userId, bool isBanned) async {
    await userCollection.doc(userId).update({"isBanned": isBanned});
  }

  // Get all inboxes
  Future<List<Map<String, dynamic>>> getAllInboxes() async {
    QuerySnapshot snapshot = await inboxCollection.get();
    return snapshot.docs
        .map((doc) => {
              "emailAddress": doc["emailAddress"],
              "userId": doc["userId"],
              "isActive": doc["isActive"],
              "expiresAt": doc["expiresAt"].toDate(),
            })
        .toList();
  }
}
