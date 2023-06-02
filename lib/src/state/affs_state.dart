import 'package:afib/afib_flutter.dart';
import 'package:afib_firebase_firestore/src/state/affs_state_model_access.dart';
import 'package:meta/meta.dart';

@immutable
class AFFSState extends AFComponentState with AFFSStateModelAccess {

  AFFSState(Map<String, Object> models): super(models: models, create: AFFSState.create);

  factory AFFSState.create(Map<String, Object> models) {
      return AFFSState(models);
  }

  factory AFFSState.fromList(List<Object> toIntegrate) {
    final models = AFComponentState.integrate(AFComponentState.empty(), toIntegrate);
    return AFFSState(models);
  }

  @override
  AFComponentState createWith(Map<String, Object> models) {
    return AFFSState(models);
  }

  factory AFFSState.initial() {
    return AFFSState.fromList(const [
    ]);
  }
}