import 'package:afib/afib_command.dart';
import 'package:afib_firebase_firestore/src/command/templates/affs_core/files/query_listen_many.t.dart';
import 'package:afib_firebase_firestore/src/command/templates/affs_project_paths.dart';

class QueryDeleteOneT {

  static SimpleQueryT core() {
    return QueryDeleteOneT.create(
      templateFileId: "query_delete_one",
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
final coll = FirebaseFirestore.instance.collection(${SimpleQueryT.insertResultTypeSingleInsertion}.tableName);    
deleteOneFromFirebase(
  collection: coll,
  documentId: ${QueryListenManyT.queryMemberVariableIdentifier},
  onSuccess: () => context.onSuccess(null),
  onError: context.onError
);
''',
      insertFinishImpl: insertFinishImpl ?? '''
final response = context.r;
final ${AFSourceTemplate.insertAppNamespaceInsertion}State = context.accessComponentState<${AFSourceTemplate.insertAppNamespaceInsertion.upper}State>();

final revisedRoot = ${AFSourceTemplate.insertAppNamespaceInsertion}State.${SimpleQueryT.insertResultTypeSingleInsertion.camelPluralize}.reviseRemoveItemById(${QueryListenManyT.queryMemberVariableIdentifier});

context.updateComponentRootStateOne<${AFSourceTemplate.insertAppNamespaceInsertion.upper}State>(revisedRoot);
''',
    insertAdditionalMethods: '''
$insertAdditionalMethods
''',
    );
  }

}