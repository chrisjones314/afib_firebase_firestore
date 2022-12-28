
import 'package:afib/afib_command.dart';
import 'package:afib_firebase_firestore/src/command/templates/affs_core/files/query_write_one.t.dart';
import 'package:afib_firebase_firestore/src/command/templates/affs_project_paths.dart';

class QueryWriteOneUserT {

    static SimpleQueryT example() {
    return QueryWriteOneT.create(
      templateFileId: "query_write_one_user", 
      templateFolder: AFFSProjectPaths.pathGenerateSigninFirebaseFiles, 
      extraImports: '''
import 'package:${AFSourceTemplate.insertPackagePathInsertion}/query/listener/read_one_user_listener_query.dart';
''',
      insertFinishImpl: '''
ReadOneUserListenerQuery.updateUser(context);
'''
    );
  }

}