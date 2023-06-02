

import 'dart:async';

import 'package:afib/afib_command.dart';
import 'package:afib/afib_flutter.dart';
import 'package:afib_firebase_firestore/src/query/simple/affs_firestore_query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AFFSFirestoreListenerQuery<TResponse> extends AFAsyncListenerQuery<TResponse> {
  StreamSubscription<QuerySnapshot>? subscription;

  AFFSFirestoreListenerQuery({
    AFID? id,
    AFPreExecuteResponseDelegate<TResponse>? onPreExecuteResponse,
    AFOnResponseDelegate<TResponse>? onSuccess, 
    AFOnErrorDelegate? onError
  }): 
    super(id: id, onSuccess: onSuccess, onError: onError, onPreExecuteResponse: onPreExecuteResponse);

  //--------------------------------------------------------------------------------------
  @override
  void shutdown() {
    cancelSubscription();
  }

  //--------------------------------------------------------------------------------------
  void cancelSubscription() {
    subscription?.cancel();
    subscription = null;
  }

  //--------------------------------------------------------------------------------------
  void listenManyDocuments({
    required Query query, 
    required void Function(List<AFFirestoreDocument>) onSuccess, 
    required void Function(AFQueryError) onError
  }) {
    cancelSubscription();
    subscription = query.snapshots().listen((data) {
      AFFSFirestoreQuery.handleSnapshots(data.docs, onSuccess);
    }, onError: (err) {
      onError(AFQueryError.createMessage(err.toString()));
    });
  }
}
