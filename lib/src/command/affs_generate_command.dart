import 'package:afib/afib_command.dart';

class AFFSGenerateParentCommand extends AFCommandGroup {
  @override
  final name = "affs:generate";

  @override
  final description = "Generate code for firestore-related queries";
  

  @override
  Future<void> execute(AFCommandContext context) async {

  }
}

abstract class AFFSGenerateSubcommand extends AFCommand {


}

