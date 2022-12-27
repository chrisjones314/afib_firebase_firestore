import 'package:afib/afib_command.dart';

class AFFSGenerateParentCommand extends AFCommandGroup {
  @override
  final name = "affs:generate";

  @override
  final description = "Generate AFib source code for screens, queries, models, and more";
  

  @override
  Future<void> execute(AFCommandContext ctx) async {

  }
}

abstract class AFFSGenerateSubcommand extends AFCommand {


}

