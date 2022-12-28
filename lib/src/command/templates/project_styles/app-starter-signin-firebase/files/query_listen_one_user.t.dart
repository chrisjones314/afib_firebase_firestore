
import 'package:afib/afib_command.dart';
import 'package:afib_firebase_firestore/src/command/templates/affs_core/files/query_listen_one.t.dart';
import 'package:afib_firebase_firestore/src/command/templates/affs_core/files/query_write_one.t.dart';
import 'package:afib_firebase_firestore/src/command/templates/affs_project_paths.dart';

class QueryListenOneUserT {

    static SimpleQueryT example() {
    return QueryListenOneT.create(
      templateFileId: "query_listen_one_user", 
      templateFolder: AFFSProjectPaths.pathGenerateSigninFirebaseFiles, 
      documentIdReference: "credential.userId",
      insertFinishImpl: '''
updateUser(context);
''',
      insertAdditionalMethods: '''
static void updateUser(AFFinishQuerySuccessContext<${SimpleQueryT.insertResultTypeInsertion}> context) {
  final response = context.r;
  final ${AFSourceTemplate.insertAppNamespaceInsertion}State = context.accessComponentState<${AFSourceTemplate.insertAppNamespaceInsertion.upper}State>();
  
  final users = ${AFSourceTemplate.insertAppNamespaceInsertion}State.referencedUsers;
  final revised = users.reviseUser(response);
  
  context.updateComponentRootStateOne<${AFSourceTemplate.insertAppNamespaceInsertion.upper}State>(revised);
}
''',
    );
  }

}