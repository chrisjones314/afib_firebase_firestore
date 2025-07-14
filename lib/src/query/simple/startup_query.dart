import 'package:afib/afib_flutter.dart';

class StartupQuery extends AFAsyncQuery<AFUnused> {
  
  
  StartupQuery({
    super.id,
    
    super.onSuccess,
    super.onError,
    super.onPreExecuteResponse
  });
  
  @override
  void startAsync(AFStartQueryContext<AFUnused> context) async {
    throwUnimplemented();
    
  }

  @override
  void finishAsyncWithResponse(AFFinishQuerySuccessContext<AFUnused> context) {
    
  }

  
}