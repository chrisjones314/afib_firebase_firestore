import 'package:afib/afib_command.dart';

class AFFSLibraryID {
  static const id = AFLibraryID(code: "affs", name: "afib_firebase_firestore");
}

class AFFSQueryID extends AFQueryID {


  const AFFSQueryID(String code): super(code, AFFSLibraryID.id);
}

class AFFSThemeID extends AFThemeID {
  static const defaultTheme = AFFSThemeID("defaultTheme");

  const AFFSThemeID(String code): super(code, AFFSLibraryID.id);   
}

class AFFSScreenID extends AFScreenID {


  const AFFSScreenID(String code) : super(code, AFFSLibraryID.id);
}

class AFFSDrawerID extends AFScreenID {


  const AFFSDrawerID(String code) : super(code, AFFSLibraryID.id);
}

class AFFSDialogID extends AFScreenID {


  const AFFSDialogID(String code) : super(code, AFFSLibraryID.id);
}


class AFFSBottomSheetID extends AFScreenID {


  const AFFSBottomSheetID(String code) : super(code, AFFSLibraryID.id);
}

class AFFSWidgetID extends AFWidgetID {  
  static const standardClose = AFFSWidgetID("standardClose");


  const AFFSWidgetID(String code) : super(code, AFFSLibraryID.id);
}

class AFFSLibraryProgrammingInterfaceID extends AFLibraryProgrammingInterfaceID {  


  const AFFSLibraryProgrammingInterfaceID(String code) : super(code, AFFSLibraryID.id);
}

class AFFSTestDataID {
  static const affsStateFullLogin = "affsStateFullLogin";
}

class AFFSUnitTestID extends AFStateTestID {


  const AFFSUnitTestID(String code): super(code, AFFSLibraryID.id); 
}


class AFFSStateTestID extends AFStateTestID {


  const AFFSStateTestID(String code): super(code, AFFSLibraryID.id); 
}

class AFFSScreenTestID extends AFScreenTestID {


  const AFFSScreenTestID(String code): super(code, AFFSLibraryID.id); 
}

class AFFSPrototypeID extends AFPrototypeID {


  const AFFSPrototypeID(String code): super(code, AFFSLibraryID.id); 
}

class AFFSWireframeID extends AFWireframeID {


  const AFFSWireframeID(String code): super(code, AFFSLibraryID.id); 
}

