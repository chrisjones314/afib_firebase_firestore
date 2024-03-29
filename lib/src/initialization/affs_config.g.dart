import 'package:afib/afib_command.dart';

void configureAfib(AFConfig config) {
  // --environment                       
  //       [debug]                       For debugging
  //       [production]                  For production
  //       [prototype]                   Interact with prototype screens, and run tests against them on the simulator
  //       [startupInScreenPrototype]    Startup in a specific screen prototype specified by AFConfig.setStartupScreenPrototype (specified in initialization/environments/prototype.dart)
  //       [startupInWireframe]          Startup in a wireframe specified by AFConfig.setStartupWireframe (specified in initialization/environments/prototype.dart)
  //       [test]                        Used internally when command-line tests are executing, not usually explicitly used by developers
  //       [workflowPrototype]           Startup in the terminal state of a state test, specified by AFConfig.setStartupStateTest (specified in initialization/environments/prototype.dart)
  config.setValue("environment", AFEnvironment.debug);
  
  // --app-namespace    A short identifier which is unique to your app, many files and classes are prefixed with these characters, so changing it later is not advised
  config.setValue("app-namespace", "affs");
  
  // --package-name    The name of your application package
  config.setValue("package-name", "afib_firebase_firestore");
  
  
  config.setValue("tests-recent", []);
  
  // --logs-enabled       
  //       [//]           Disable all items after this in the logs-enabled array
  //       [af:config]    Logging on any non-test definition/initialization context, and of afib.g.dart/startup configuration values
  //       [af:query]     Internal AFib logging for queries
  //       [af:route]     Internal AFib logging related to routes and navigation
  //       [af:state]     Internal AFib logging related to app state
  //       [af:test]      Internal AFib logging for testing
  //       [af:theme]     Internal AFib logging related to theming
  //       [af:ui]        Internal AFib logging for UI build
  //       [all]          Turn on all logging
  //       [query]        App/third-party logging on AFStartQueryContext.log, AFFinishQuerySuccessContext.log or AFFinishQueryErrorContext.log
  //       [standard]     Logging for app/third-party query and ui, plus afib route and state
  //       [test]         App/third-party logging on test contexts: AFUIPrototypeDefinitionContext.log, AFStateTestDefinitionContext.log, AFDefineTestDataContext.log, AFDefineTestDataContext.log, AFWireframeDefinitionContext.log
  //       [ui]           App/third-party logging for any AFStateProgrammingInterface.log (e.g ...SPI.log) or AFBuildContext.log.
  config.setValue("logs-enabled", ["query", "ui", "test", "//", "af:route", "af:state"]);
  
  // --force-dark-mode    Set to true if you'd like to run the app in dark mode, regardless of the device setting
  //                      [true, false]
  config.setValue("force-dark-mode", false);
  
  // --generate-beginner-comments    Set to false if you do not want generated files to contain comments intended to help beginners
  //                                 [true, false]
  config.setValue("generate-beginner-comments", true);
  
  // --generate-ui-prototypes    Set to false if you do not want a ui prototype to be automatically added when you create a new ui element
  //                             [true, false]
  config.setValue("generate-ui-prototypes", true);
  
  // --generated-file-header    A comment to place at the top of generated dart files.
  config.setValue("generated-file-header", "");
  
  // --absolute-base-year    The earliest year which your app will have reason to reference, generally good to set it 1-2 years before you started creating the app
  config.setValue("absolute-base-year", 2019);
  
  // --tests-enabled        
  //       [*]              Or, the full identifier of any prototype, test name, or tag
  //       [all]            All tests, not including i18n and regression
  //       [bottomsheet]    
  //       [dialog]         
  //       [drawer]         
  //       [i18n]           
  //       [screen]         
  //       [state]          State tests
  //       [unit]           
  //       [widget]         
  //       [workflow]       
  config.setValue("tests-enabled", "all");
  
  // --test-size                The size used for command line tests, often used in conjunction with test-orientation
  // 
  //       [*]                  Or, [width]x[height], e.g. 1000x2000
  //       [phone-large]        1284.0 w x 2778.0 h
  //       [phone-standard]     1170.0 w x 2532.0 h
  //       [tablet-large]       2048.0 w x 2732.0 h
  //       [tablet-small]       1536.0 w x 2048.0 h
  //       [tablet-standard]    1640.0 w x 2360.0 h
  config.setValue("test-size", "phone-standard");
  
  // --test-orientation    The orientation used in command line tests
  // 
  //       [landscape]     Landscape, width larger than height
  //       [portrait]      Portrait, height larger than width
  config.setValue("test-orientation", "portrait");
  
  // --widgetTesterContext    Internal value set to true when we are doing widget tests
  //                          [true, false]
  config.setValue("widgetTesterContext", false);
  
}
