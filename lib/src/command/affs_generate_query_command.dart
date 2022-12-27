import 'package:afib/afib_command.dart';
import 'package:afib_firebase_firestore/src/command/affs_generate_command.dart';
import 'package:afib_firebase_firestore/src/command/templates/affs_core/files/write_one.t.dart';

class AFFSGenerateQueryCommand extends AFFSGenerateSubcommand {
  static const prefixReadOne = "ReadOne";
  static const prefixReadMany = "ReadMany";
  static const prefixWriteOne = "WriteOne";
  static const prefixDeleteOne = "DeleteOne";

  @override
  final name = "query";

  @override
  final description = "Generates queries that read/write/listen to cloud firestore";

  @override 
  String get usage {
    return '''
$usageHeader
  $nameOfExecutable generate $name Prefix...Suffix [options]

$descriptionHeader
  You configure the query by naming it with a supported prefix and suffix:

    $prefixReadOne...${AFGenerateQuerySubcommand.suffixQuery} -- e.g. ReadOneUserQuery, reads a single value from a collection, then terminates.
    $prefixReadMany...${AFGenerateQuerySubcommand.suffixQuery} -- reads one or more values from a collection, selected by a firestore query.
    $prefixReadOne...${AFGenerateQuerySubcommand.suffixListenerQuery} -- reads one value from a collection, then continues listening for updates to that value.
    $prefixReadMany...${AFGenerateQuerySubcommand.suffixListenerQuery} -- reads many values from a collection, selected by a firestore query, then continues listening for updates.
    $prefixWriteOne...${AFGenerateQuerySubcommand.suffixQuery} - writes a single value to a collection
    $prefixDeleteOne...${AFGenerateQuerySubcommand.suffixQuery} - deletes a single value from a collection

$optionsHeader
    ${AFGenerateQuerySubcommand.argResultModelType} -- the type of the result (not applicable for $prefixDeleteOne)

''';
  }

  @override
  Future<void> execute(AFCommandContext context) async {

    final generator = context.generator;
    // parse arguments with default values as follows
    final args = context.parseArguments(
      command: this,
      unnamedCount: 1,
      named: {
        AFGenerateQuerySubcommand.argResultModelType: "",
        AFGenerateQuerySubcommand.argRootStateType: generator.nameRootState,
        AFGenerateSubcommand.argExportTemplatesFlag: "false",
        AFGenerateSubcommand.argOverrideTemplatesFlag: "",
        AFGenerateSubcommand.argMemberVariables: "",
      }
    );

    final mainType = args.accessUnnamedFirst;

    var querySuffix = AFGenerateQuerySubcommand.suffixQuery;
    if(mainType.endsWith(AFGenerateQuerySubcommand.suffixListenerQuery)) {
      querySuffix = AFGenerateQuerySubcommand.suffixListenerQuery;
    }

    final memberVariables = context.memberVariables(args);
    AFSourceTemplate? overrideTemplate;
    String? overrideSuperclass = "AFFSFirestoreQuery";
    if(mainType.startsWith(prefixWriteOne)) {
      overrideTemplate = WriteOneQueryT.core();
    } else {
      throwUsageError("$mainType does not start with a known prefix");
    }

    AFGenerateQuerySubcommand.createQuery(
      context: context, 
      querySuffix: querySuffix, 
      queryType: mainType, 
      args: args, 
      usage: usage,
      overrideParentType: overrideSuperclass,
      overrideTemplate: overrideTemplate,
    );

    context.generator.finalizeAndWriteFiles(context);
  }
}