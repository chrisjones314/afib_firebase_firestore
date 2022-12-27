import 'package:afib/afib_command.dart';
import 'package:afib_firebase_firestore/src/command/generate_command.dart';

void installCommand(AFCommandLibraryExtensionContext context) {
    context.defineCommand(GenerateCommand());
  // see 'afib generate command' for an easy way to create a new command-line command  
}