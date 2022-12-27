import 'package:afib/afib_flutter.dart';
import 'package:afib_firebase_firestore/src/initialization/affs_define_core.dart';

void installCoreLibrary(AFCoreLibraryExtensionContext context) {
    context.installCoreLibrary(
      defineCore: defineCore,
      
    );
}