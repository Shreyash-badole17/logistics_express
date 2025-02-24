import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logistics_express/src/models/agent_model.dart';
import 'package:logistics_express/src/models/publish_ride_model.dart';
import 'package:logistics_express/src/models/requested_delivery_model.dart';
import 'package:logistics_express/src/models/user_auth_model.dart';
import '../models/user_model.dart';

class UserServices {
  final _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> createUser(UserModel user) async {
    User? currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      await _fireStore.collection("users").doc(currentUser.uid).set(
            user.toMap(),
          );
    } else {
      throw Exception("No authenticated user found.");
    }
  }

  Future<void> createAgent(AgentModel agent) async {
    User? currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      await _fireStore.collection("agents").doc(currentUser.uid).set(
            agent.toMap(),
          );
    } else {
      throw Exception("No authenticated user found.");
    }
  }

  Future<void> createAuthUser(UserAuthModel user) async {
    User? currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      await _fireStore.collection("user_auth").doc(currentUser.uid).set(
            user.toMap(),
          );
    } else {
      throw Exception("No authenticated user found.");
    }
  }

  Future<void> publishRide(PublishRideModel ride) async {
    User? currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      await _fireStore.collection("published-rides").doc(currentUser.uid).set(
            ride.toMap(),
          );
    } else {
      throw Exception("No authenticated user found.");
    }
  }

  Future<void> requestedDelivery(RequestedDeliveryModel delivery) async {
    User? currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      await _fireStore
          .collection("requested-deliveries")
          .doc(currentUser.uid)
          .set(
            delivery.toMap(),
          );
    } else {
      throw Exception("No authenticated user found.");
    }
  }
}
