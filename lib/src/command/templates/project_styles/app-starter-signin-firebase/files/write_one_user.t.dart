
import 'package:afib/afib_command.dart';
import 'package:afib_firebase_firestore/src/command/templates/affs_core/files/write_one.t.dart';
import 'package:afib_firebase_firestore/src/command/templates/affs_project_paths.dart';

class WriteOneUserT {

    static SimpleQueryT example() {
    return WriteOneQueryT.create(
      templateFileId: "write_one_user", 
      templateFolder: AFFSProjectPaths.pathGenerateSigninFirebaseFiles, 
      extraImports: '''
import 'package:${AFSourceTemplate.insertPackageNameInsertion}/state/root/user_credential_root.dart';
''',
      insertFinishImpl: '''
final user = context.r;
final ${AFSourceTemplate.insertAppNamespaceInsertion}State = context.accessComponentState<${AFSourceTemplate.insertAppNamespaceInsertion.upper}State>();

// TODO, revise should be from ${AFSourceTemplate.insertAppNamespaceInsertion}State.someRoot.revise...(response)
final users = ${AFSourceTemplate.insertAppNamespaceInsertion}State.referencedUsers;
final revised = users.reviseUser(user);

context.updateComponentRootStateOne<${AFSourceTemplate.insertAppNamespaceInsertion.upper}State>(revised);
'''
    );
  }

}