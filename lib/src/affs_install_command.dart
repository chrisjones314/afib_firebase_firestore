import 'package:afib/afib_command.dart';
import 'package:afib_firebase_firestore/affs_id.dart';
import 'package:afib_firebase_firestore/src/initialization/install/install_base.dart';
import 'package:afib_firebase_firestore/src/initialization/install/install_command.dart';

void affsInstallCommand(AFCommandLibraryExtensionContext context) {
  installCommand(context);
}

void affsInstallBase(AFBaseExtensionContext context) {
  context.registerLibrary(AFFSLibraryID.id);
  installBase(context);
}