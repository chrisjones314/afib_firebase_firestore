import 'package:afib/afib_flutter.dart';
import 'package:afib_firebase_firestore/affs_id.dart';
import 'package:afib_firebase_firestore/src/initialization/install/install_core_library.dart';

void affsInstallCore(AFAppLibraryExtensionContext context) {
  final libContext = context.register(
    AFFSLibraryID.id
  );
  if(libContext != null) {
    installCoreLibrary(libContext);
    
  }
}