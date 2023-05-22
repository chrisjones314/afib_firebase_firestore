import 'package:afib/afib_flutter.dart';
import 'package:afib_firebase_firestore/src/state/affs_state.dart';

void defineCore(AFCoreDefinitionContext context) {
  defineEventHandlers(context);
  defineInitialState(context);
  defineLibraryProgrammingInterfaces(context);

  
}


void defineEventHandlers(AFCoreDefinitionContext context) {
  context.addDefaultQueryErrorHandler(afDefaultQueryErrorHandler);

  // you can add queries to run at startup.
  // context.addPluginStartupQuery(createMessagingListener);

  // you can add queries which respond to app lifecycle events
  // context.addLifecycleQueryAction((state) => UpdateLifecycleStateQuery(state: state));
  
  // you can add a callback which gets notified anytime a query successfully finishes.
  // context.addQuerySuccessListener(querySuccessListenerDelegate);

}


void defineInitialState(AFCoreDefinitionContext context) {
  context.defineComponentStateInitializer(() => AFFSState.initial());
}

void defineLibraryProgrammingInterfaces(AFCoreDefinitionContext context) {

}


