

import 'package:afib/afib_command.dart';
import 'package:afib_firebase_firestore/src/command/templates/affs_core/files/query_listen_many.t.dart';
import 'package:afib_firebase_firestore/src/command/templates/affs_project_paths.dart';

class QueryWriteOneT {

  static SimpleQueryT core() {
    return QueryWriteOneT.create(
      templateFileId: "query_write_one",
      templateFolder: AFFSProjectPaths.pathGenerateAFFSCoreFiles
    );
  }

  static SimpleQueryT create({
    required String templateFileId,
    required List<String> templateFolder,
    Object? insertStartImpl,
    Object? insertFinishImpl,
    Object? extraImports = "",
  }) {
    return SimpleQueryT(
      templateFileId: templateFileId, 
      templateFolder: templateFolder, 
      insertExtraImports: '''
import 'package:afib_firebase_firestore/affs_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
$extraImports
''',
      insertStartImpl: insertStartImpl ?? '''
// access the collection
final coll = FirebaseFirestore.instance.collection(${SimpleQueryT.insertResultTypeInsertion}.tableName);

// create a document, not that if user.id is a AFDocumentIDGenerate.createNewId value, then this
// object will be created, otherwise it will be updated.
final doc = AFFirestoreDocument(
  documentId: ${QueryListenManyT.queryMemberVariableIdentifier}.id,
  data: ${SimpleQueryT.insertResultTypeInsertion}.serializeToMap(${QueryListenManyT.queryMemberVariableIdentifier}),
  exists: true,
);

// write the document to firebase.
writeOneToFirebase(
  collection: coll, 
  doc: doc, 
  onSuccess: (doc) {
    // then parse it back in.
    final data = doc.data;
    final id = doc.documentId;
    data[${SimpleQueryT.insertResultTypeInsertion}.colId] = id;
    final response = ${SimpleQueryT.insertResultTypeInsertion}.serializeFromMap(data);
    // and, let finishAsync integrate it into our state
    context.onSuccess(response);
  }, 
  onError: (err) {
    context.onError(AFQueryError(message: err.message));
  }
);    
''',
      insertFinishImpl: insertFinishImpl ?? '''
final response = context.r;
final ${AFSourceTemplate.insertAppNamespaceInsertion}State = context.accessComponentState<${AFSourceTemplate.insertAppNamespaceInsertion.upper}State>();

final revisedRoot = ${AFSourceTemplate.insertAppNamespaceInsertion}State.${SimpleQueryT.insertResultTypeSingleInsertion.camelPluralize}.reviseSetItem(response);


context.updateComponentRootStateOne<${AFSourceTemplate.insertAppNamespaceInsertion.upper}State>(revisedRoot);
''',
    );
  }

}