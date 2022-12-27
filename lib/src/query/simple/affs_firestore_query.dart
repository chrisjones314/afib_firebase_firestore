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
    return AFFirestoreDocument(documentId: doc.id, data: data);
  }

  /// Converts a [DocumentSnapshot] int an [AFFirestoreDocument]
  static AFFirestoreDocument convertSnapshot(DocumentSnapshot doc) {
    return AFFirestoreDocument(documentId: doc.id, data: _documentData(doc));
  }

  /// Converts a list of [DocumentSnapshot] into a list of [AFFirestoreDocument]
  static List<AFFirestoreDocument> convertSnapshots(List<DocumentSnapshot> docs) {
    return docs.map((doc) { 
      return AFFirestoreDocument(documentId: doc.id, data: _documentData(doc));
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

  /// Writes [doc] to the collection [col], calling [onResponse] with the saved result.
  void writeToFirebase(CollectionReference coll, AFFirestoreDocument doc, Function(AFFirestoreDocument) onResponse, Function(AFQueryError) onError) {
    _fb.runTransaction((tx) async {
      // create a new one.
      DocumentReference result;
      if(doc.isNew) {
        result = await coll.add(doc.data);
      } else {
        // update an existing one.
        result = coll.doc(doc.documentId);
        await result.set(doc.data);
      }
      final updated = convertDocument(result, doc.data);
      onResponse(updated);
    });  
  }

  void deleteFromFirebase(CollectionReference coll, String documentId, Function() onResponse) {
    _fb.runTransaction((tx) async {
      final doc = coll.doc(documentId);
      await doc.delete();
      onResponse();
    });
  }

  void performQuery(Query q, Function(List<AFFirestoreDocument>) onResponse, Function(AFQueryError) onError) {
    q.get().then( (data) {
      AFFSFirestoreQuery.handleSnapshots(data.docs, onResponse);
    });
  }

  void readFromFirebase(DocumentReference ref, Function(AFFirestoreDocument) onResponse, Function(AFQueryError) onError) {
    ref.get().then( (doc) {
      AFFSFirestoreQuery.handleSnapshot(doc, onResponse);
    });
  }  


}
