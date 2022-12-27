

import 'package:afib/afib_command.dart';
import 'package:afib_firebase_firestore/src/command/templates/affs_project_paths.dart';

class WriteOneQueryT {

  static SimpleQueryT core() {
    return WriteOneQueryT.create(
      templateFileId: "write_one",
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
  documentId: user.id, 
  data: ${SimpleQueryT.insertResultTypeInsertion}.serializeToMap(user)
);

// write the document to firebase.
writeToFirebase(coll, doc, (doc) {
  // then parse it back in.
  final data = doc.data;
  final id = doc.documentId;
  data[${SimpleQueryT.insertResultTypeInsertion}.colId] = id;
  final response = ${SimpleQueryT.insertResultTypeInsertion}.serializeFromMap(data);
  // and, let finishAsync integrate it into our state
  context.onSuccess(response);
}, (err) {
  context.onError(AFQueryError(message: err.message));
});    
''',
      insertFinishImpl: insertFinishImpl ?? '''
final response = context.r;
final ${AFSourceTemplate.insertAppNamespaceInsertion}State = context.accessComponentState<${AFSourceTemplate.insertAppNamespaceInsertion.upper}State>();

// TODO, revise should be from ${AFSourceTemplate.insertAppNamespaceInsertion}State.someRoot.revise...(response)
final revisedRoot = Object();

context.updateComponentRootStateOne<${AFSourceTemplate.insertAppNamespaceInsertion.upper}State>(revisedRoot);
''',
    );
  }

}