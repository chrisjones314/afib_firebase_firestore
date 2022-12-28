import 'package:afib/afib_command.dart';
import 'package:afib_firebase_firestore/src/command/affs_generate_command.dart';
import 'package:afib_firebase_firestore/src/command/affs_generate_query_command.dart';
import 'package:afib_firebase_firestore/src/command/templates/affs_core/files/query_delete_one.t.dart';
import 'package:afib_firebase_firestore/src/command/templates/affs_core/files/query_listen_many.t.dart';
import 'package:afib_firebase_firestore/src/command/templates/affs_core/files/query_listen_one.t.dart';
import 'package:afib_firebase_firestore/src/command/templates/affs_core/files/query_read_many.t.dart';
import 'package:afib_firebase_firestore/src/command/templates/affs_core/files/query_read_one.t.dart';
import 'package:afib_firebase_firestore/src/command/templates/affs_core/files/query_write_one.t.dart';
import 'package:afib_firebase_firestore/src/command/templates/project_styles/app-starter-signin-firebase/files/query_listen_one_user.t.dart';
import 'package:afib_firebase_firestore/src/command/templates/project_styles/app-starter-signin-firebase/files/query_write_one_user.t.dart';

void installCommand(AFCommandLibraryExtensionContext context) {
  context.registerTemplateFile(QueryWriteOneT.core());
  context.registerTemplateFile(QueryListenOneT.core());
  context.registerTemplateFile(QueryReadOneT.core());
  context.registerTemplateFile(QueryReadManyT.core());
  context.registerTemplateFile(QueryListenManyT.core());
  context.registerTemplateFile(QueryDeleteOneT.core());


  context.registerTemplateFile(QueryWriteOneUserT.example());
  context.registerTemplateFile(QueryListenOneUserT.example());

  final generate = AFFSGenerateParentCommand();
  generate.addSubcommand(AFFSGenerateQueryCommand());
  
  context.defineCommand(generate);
  // see 'afib generate command' for an easy way to create a new command-line command  
}