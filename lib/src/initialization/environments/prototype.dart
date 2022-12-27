import 'package:afib/afib_command.dart';

void configurePrototype(AFConfig config) {   
     // use this, plus AFEnvironment.wireframe to start up directly into a wireframe.
     // config.setStartupWireframe(AFFSWireframeID.initial);
   
     // use this, plus AFEnvironment.stateTest to startup directly into the terminal state of a state test.
     // config.setStartupStateTest(AFFSStateTestID.yourStateTest);
   
     // use this, plus AFEnvironment.screenPrototype to startup directly into a screen prototype.
     // config.setStartupScreenPrototype(AFFSPrototypeID.searchScreenInitial);
   
     // use this to configure your favorite tests on the prototype home screen
     config.setFavoriteTests([
       // AFFSStateTestID.yourTestId,
     ]);
}