import 'package:afib/afib_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// An asynchronous firestore query that does retrieves data and completes.
/// 
/// It does not listen for updates on an ongoing basis.
abstract class AFFSFirestoreQuery<TResponse> extends AFAsyncQuery<TResponse> {

  AFFSFirestoreQuery({
    AFID? id, 
    AFPreExecuteResponseDelegate<TResponse>? onPreExecuteResponse,
    AFOnResponseDelegate<TResponse>? onSuccess, 
    AFOnErrorDelegate? onError
  }): super(id: id, onSuccess: onSuccess, onError: onError, onPreExecuteResponse: onPreExecuteResponse);

  /// The firestore instance.
  static final _fb = FirebaseFirestore.instance;

  /// Converts a [DocumentReference] into an [AFFirestoreDocument]
  static AFFirestoreDocument convertDocument(DocumentReference doc, Map<String, dynamic> data) {
    return AFFirestoreDocument(documentId: doc.id, data: data, exists: true);
  }

  /// Converts a [DocumentSnapshot] int an [AFFirestoreDocument]
  static AFFirestoreDocument convertSnapshot(DocumentSnapshot doc) {
    return AFFirestoreDocument(documentId: doc.id, data: _documentData(doc), exists: true);
  }

  /// Converts a list of [DocumentSnapshot] into a list of [AFFirestoreDocument]
  static List<AFFirestoreDocument> convertSnapshots(List<DocumentSnapshot> docs) {
    return docs.map((doc) { 
      return AFFirestoreDocument(documentId: doc.id, data: _documentData(doc), exists: true);
    }).toList();
  }

  static Map<String, dynamic> _documentData(DocumentSnapshot doc) {
    final data = doc.data();
    if(data is Map<String, dynamic>) {
      return data;
    }
    return <String, dynamic>{};
  }

  /// Converts [DocumentSnapshot to an [AFFirestoreDocumenet] and calls [onResponse]
  static void handleSnapshot(DocumentSnapshot doc, Function(AFFirestoreDocument) onResponse) {
    final df = convertSnapshot(doc);
    onResponse(df);
  }

  /// Converts the list of [DocumentSnapshot] to a list of [AFFirestoreDocument] and calls [onResponse]
  static void handleSnapshots(List<DocumentSnapshot> docs, Function(List<AFFirestoreDocument>) onResponse) {
    final dfDocs = convertSnapshots(docs);
    onResponse(dfDocs);
  }

  static void handleError(dynamic err, void Function(AFQueryError) onError) {
    onError(AFQueryError(message: err.toString()));
  }

  static List<TResult> buildResultsList<TResult>({
    required List<AFFirestoreDocument> docs,
    required TResult Function(Map<String, dynamic>) create
  }) {
    final result = <TResult>[];
    for(final doc in docs) {
      final data = doc.data;
      data[AFDocumentIDGenerator.columnId] = doc.documentId;
      result.add(create(data));
    }
    return result;
  }

  /// Writes [doc] to the collection [col], calling [onResponse] with the saved result.
  void writeOneToFirebase({ 
    required CollectionReference collection, 
    required AFFirestoreDocument doc, 
    required Function(AFFirestoreDocument) onSuccess, 
    required Function(AFQueryError) onError
  }) {
    _fb.runTransaction((tx) async {
      // create a new one.
      DocumentReference result;
      if(doc.isNew) {
        result = await collection.add(doc.data);
      } else {
        // update an existing one.
        result = collection.doc(doc.documentId);
        await result.set(doc.data);
      }
      final updated = convertDocument(result, doc.data);
      onSuccess(updated);
    });  
  }

  void deleteOneFromFirebase({
    required CollectionReference collection, 
    required String documentId, 
    required void Function() onSuccess,
    required void Function(AFQueryError) onError
  }) {
    _fb.runTransaction((tx) async {
      final doc = collection.doc(documentId);
      doc.delete().then(
        (value) =>  onSuccess(),
        onError: (err) => handleError(err, onError)
      );
    });
  }

  void readManyFromFirebase({
    required Query query, 
    required void Function(List<AFFirestoreDocument>) onSuccess, 
    required void Function(AFQueryError) onError
  }) {
    query.get().then( (data) {
      AFFSFirestoreQuery.handleSnapshots(data.docs, onSuccess);
    }, onError: (err) {
      AFFSFirestoreQuery.handleError(err, onError);
    });
  }

  void readOneFromFirebase({
    required DocumentReference documentRef, 
    required void Function(AFFirestoreDocument) onSuccess, 
    required void Function(AFQueryError) onError
  }) {
    documentRef.get().then( (doc) {
      AFFSFirestoreQuery.handleSnapshot(doc, onSuccess);
    }, onError: (err) => handleError(err, onError));
  }  


}
