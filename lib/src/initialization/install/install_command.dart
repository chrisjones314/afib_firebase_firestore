import 'package:afib/afib_command.dart';
import 'package:afib_firebase_firestore/src/command/affs_generate_command.dart';
import 'package:afib_firebase_firestore/src/command/affs_generate_query_command.dart';
import 'package:afib_firebase_firestore/src/command/templates/affs_core/files/write_one.t.dart';
import 'package:afib_firebase_firestore/src/command/templates/project_styles/app-starter-signin-firebase/files/write_one_user.t.dart';

void installCommand(AFCommandLibraryExtensionContext context) {
  context.registerTemplateFile(WriteOneQueryT.core());
  context.registerTemplateFile(WriteOneUserT.example());


  final generate = AFFSGenerateParentCommand();
  generate.addSubcommand(AFFSGenerateQueryCommand());
  
  context.defineCommand(generate);
  // see 'afib generate command' for an easy way to create a new command-line command  
}