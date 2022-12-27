import 'package:afib/afib_command.dart';
import 'package:afib_firebase_firestore/affs_id.dart';

void installBase(AFBaseExtensionContext context) {
  // the earliest/most basic hook for extending afib, both the command and the app
  // can be used to create custom configuration entries.
  context.registerLibrary(AFFSLibraryID.id);
}