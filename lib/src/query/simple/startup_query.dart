import 'package:afib/afib_flutter.dart';

class StartupQuery extends AFAsyncQuery<AFUnused> {
  
  
  StartupQuery({
    AFID? id,
    
    AFOnResponseDelegate<AFUnused>? onSuccess,
    AFOnErrorDelegate? onError,
    AFPreExecuteResponseDelegate<AFUnused>? onPreExecuteResponse
  }): super(
    id: id,
    onSuccess: onSuccess,
    
    onError: onError,
    onPreExecuteResponse: onPreExecuteResponse,
  );
  
  @override
  void startAsync(AFStartQueryContext<AFUnused> context) async {
    throwUnimplemented();
    
  }

  @override
  void finishAsyncWithResponse(AFFinishQuerySuccessContext<AFUnused> context) {
    
  }

  
}