
import 'dart:async';

import 'package:afib/afib_command.dart';
import 'package:afib/afib_flutter.dart';
import 'package:afib_firebase_firestore/src/query/simple/affs_firestore_query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AFFSFirestoreSnapshotListenerQuery<TResponse> extends AFAsyncListenerQuery<TResponse> {
  
  StreamSubscription<DocumentSnapshot>? subscription;

  AFFSFirestoreSnapshotListenerQuery({
    AFID? id, 
    AFPreExecuteResponseDelegate<TResponse>? onPreExecuteResponse,
    AFOnResponseDelegate<TResponse>? onSuccess, 
    AFOnErrorDelegate? onError
  }): 
    super(id: id, onSuccess: onSuccess, onError: onError, onPreExecuteResponse: onPreExecuteResponse);

  @override
  void shutdown() {
    cancelSubscription();
  }

  void cancelSubscription() {
    subscription?.cancel();
    subscription = null;
  }

  void listenOneDocument({
    required DocumentReference documentRef, 
    required void Function(AFFirestoreDocument) onSuccess, 
    required void Function(AFQueryError) onError,
    void Function()? onShutdown
  }) {
    cancelSubscription();
    subscription = documentRef.snapshots().listen((doc) {
      AFFSFirestoreQuery.handleSnapshot(doc, onSuccess);
    }, onError: (err) {
      onError(AFQueryError.createMessage(err.message));
    }, onDone: onShutdown ?? () {
      
    });
  }
}
