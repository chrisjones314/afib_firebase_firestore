import 'package:afib/afib_command.dart';
import 'package:afib_firebase_firestore/src/command/templates/affs_project_paths.dart';

class QueryReadOneT {

  static SimpleQueryT core() {
    return QueryReadOneT.create(
      templateFileId: "query_read_one",
      templateFolder: AFFSProjectPaths.pathGenerateAFFSCoreFiles
    );
  }

  static SimpleQueryT create({
    required String templateFileId,
    required List<String> templateFolder,
    Object? insertStartImpl,
    Object? insertFinishImpl,
    Object? extraImports = "",
    Object? documentIdReference = "sourceId",
    Object? insertAdditionalMethods = "",
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
final coll = FirebaseFirestore.instance.collection(${SimpleQueryT.insertResultTypeInsertion}.tableName);    
final ref = coll.doc(documentId);
readOneFromFirebase(documentRef: ref, onSuccess: (doc) {
  final data = doc.data;
  final id = doc.documentId;
    data[${SimpleQueryT.insertResultTypeInsertion}.colId] = id;
    final response = ${SimpleQueryT.insertResultTypeInsertion}.serializeFromMap(data);
    // and, let finishAsync integrate it into our state
    context.onSuccess(response);      
  }, onError: (err) {
    context.onError(AFQueryError(message: err.message));      
  }
);
''',
      insertFinishImpl: insertFinishImpl ?? '''
final response = context.r;
final ${AFSourceTemplate.insertAppNamespaceInsertion}State = context.accessComponentState<${AFSourceTemplate.insertAppNamespaceInsertion.upper}State>();

// TODO, revise should be from ${AFSourceTemplate.insertAppNamespaceInsertion}State.someRoot.revise...(response)
final revisedRoot = Object();

context.updateComponentRootStateOne<${AFSourceTemplate.insertAppNamespaceInsertion.upper}State>(revisedRoot);
''',
    insertAdditionalMethods: '''
String get documentId {
  // if this doesn't compile, then you need to change it to return the id of the collection entry that you are 
  // looking up from one of your member variables.
  return $documentIdReference;
}

$insertAdditionalMethods
''',
    );
  }

}