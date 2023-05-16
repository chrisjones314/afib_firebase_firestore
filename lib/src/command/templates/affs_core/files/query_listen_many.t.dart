import 'package:afib/afib_command.dart';
import 'package:afib_firebase_firestore/src/command/templates/affs_project_paths.dart';

class QueryListenManyT {
  static const queryMemberVariableIdentifier = AFSourceTemplateInsertion("query_member_variable_identifier");
  
  static SimpleQueryT core() {
    return QueryListenManyT.create(
      templateFileId: "query_listen_many",
      templateFolder: AFFSProjectPaths.pathGenerateAFFSCoreFiles
    );
  }

  static SimpleQueryT create({
    required String templateFileId,
    required List<String> templateFolder,
    Object? insertStartImpl,
    Object? insertFinishImpl,
    Object? extraImports = "",
    Object? insertAdditionalMethods = "",
    Object? documentIdReference = "sourceId",
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

// AFIB_TODO: You will need to replace this query, and perhaps the member variable(s) to
// be sensible for your applications logic.  This query will work only in simple cases.
final query = coll.where(${SimpleQueryT.insertResultTypeSingleInsertion}.col${QueryListenManyT.queryMemberVariableIdentifier.upperFirst}, isEqualTo: ${QueryListenManyT.queryMemberVariableIdentifier});

listenManyDocuments(query: query, 
  onSuccess: (docs) {
    final results = AFFSFirestoreQuery.buildResultsList<${SimpleQueryT.insertResultTypeSingleInsertion}>(
      docs: docs, 
      create: (serial) => ${SimpleQueryT.insertResultTypeSingleInsertion}.serializeFromMap(serial)
    );
    context.onSuccess(results);      
  }, onError: (err) {
    context.onError(AFQueryError(message: err.message));      
  }
);
''',
      insertFinishImpl: insertFinishImpl ?? '''
final response = context.r;
final ${AFSourceTemplate.insertAppNamespaceInsertion}State = context.accessComponentState<${AFSourceTemplate.insertAppNamespaceInsertion.upper}State>();

final revisedRoot = ${AFSourceTemplate.insertAppNamespaceInsertion}State.${SimpleQueryT.insertResultTypeSingleInsertion.camelPluralize}.reviseSetItems(response);

context.updateComponentRootStateOne<${AFSourceTemplate.insertAppNamespaceInsertion.upper}State>(revisedRoot);
''',
    );
  }

}