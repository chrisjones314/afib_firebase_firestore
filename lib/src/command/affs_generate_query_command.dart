import 'package:afib/afib_command.dart';
import 'package:afib_firebase_firestore/src/command/affs_generate_command.dart';
import 'package:afib_firebase_firestore/src/command/templates/affs_core/files/query_listen_many.t.dart';
import 'package:afib_firebase_firestore/src/command/templates/affs_core/files/query_listen_one.t.dart';
import 'package:afib_firebase_firestore/src/command/templates/affs_core/files/query_read_one.t.dart';
import 'package:afib_firebase_firestore/src/command/templates/affs_core/files/query_write_one.t.dart';

import 'templates/affs_core/files/query_delete_one.t.dart';
import 'templates/affs_core/files/query_read_many.t.dart';

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
    ${AFGenerateSubcommand.argMemberVariables} -- specify at least one member variable for the query.  This member variable will be used in your query, and will usually be: 
      for single-item queries: "String id"
      for many-item queries: "String yourForeignKey", where yourForeignKey is a foreign key value on your result type.
      for write queries "YourResultType yourresulttype", the object to be written
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
        AFGenerateSubcommand.argResolveVariables: "",
      }
    );

    final mainType = args.accessUnnamedFirst;
    var resultType = args.accessNamed(AFGenerateQuerySubcommand.argResultModelType);

    var memberVariables = args.accessNamed(AFGenerateSubcommand.argMemberVariables);
    if(memberVariables.isEmpty) {
      throwUsageError("Please specify at least one member variable using --${AFGenerateSubcommand.argMemberVariables}, it will typically be the value(s) you want to use in the query");
    }


    var querySuffix = AFGenerateQuerySubcommand.suffixQuery;
    if(mainType.endsWith(AFGenerateQuerySubcommand.suffixListenerQuery)) {
      querySuffix = AFGenerateQuerySubcommand.suffixListenerQuery;
    }

    final isListenerQuery = mainType.endsWith(AFGenerateQuerySubcommand.suffixListenerQuery);
    final isStandardQuery = mainType.endsWith(AFGenerateQuerySubcommand.suffixQuery);

    AFSourceTemplate? overrideTemplate;
    String? overrideParentType = "AFFSFirestoreQuery";
    if(mainType.startsWith(prefixWriteOne)) {
      overrideTemplate = QueryWriteOneT.core();
    } else if(mainType.startsWith(prefixReadOne)) {
      if(isListenerQuery) {
        overrideTemplate = QueryListenOneT.core();
        overrideParentType = "AFFSFirestoreSnapshotListenerQuery";
      } else if(isStandardQuery) {
        overrideTemplate = QueryReadOneT.core();
      } else {
        throwUsageError("The query name $mainType did not end in a valid suffix.");
      }
    } else if(mainType.startsWith(prefixReadMany)) {
      if(!resultType.startsWith("List<")) {
        throwUsageError("When creating a $prefixReadMany query, your result-type should be a List<OfSomething>");
      }
      if(isListenerQuery) {
        overrideTemplate = QueryListenManyT.core();
        overrideParentType = "AFFSFirestoreListenerQuery";
      } else if(isStandardQuery) {
        overrideTemplate = QueryReadManyT.core();
      } else {
        throwUsageError("The query name $mainType did not end in a valid suffix.");
      }
    } else if(mainType.startsWith(prefixDeleteOne)) {
      if(!isStandardQuery) {
        throwUsageError("The query name $mainType did not end in a valid suffix.");
      }
      if(resultType.isEmpty) {
        throwUsageError("The result type of a deletion query is the type of object you are deleting.");
      }
      if(!resultType.endsWith("?")) {
        throwUsageError("The result type for a deletion query should be nullable (e.g. $resultType?)");
      }
      overrideTemplate = QueryDeleteOneT.core();
    } else {
      throwUsageError("$mainType does not start with a known prefix");
    }

    final memberVariableId = _parseOneFrom(memberVariables);

    context = context.reviseAddCoreInsertions({
      QueryListenManyT.queryMemberVariableIdentifier: memberVariableId
    });

    AFGenerateQuerySubcommand.createQuery(
      context: context, 
      querySuffix: querySuffix, 
      queryType: mainType, 
      args: args, 
      usage: usage,
      resultType: resultType,
      overrideParentType: overrideParentType,
      overrideTemplate: overrideTemplate,
    );

    context.generator.finalizeAndWriteFiles(context);
  }

  String _parseOneFrom(String memberVariables) {
    final vars = memberVariables.split(";");
    if(vars.isEmpty) {
      throwUsageError("--${AFGenerateSubcommand.argMemberVariables} is missing or has bad format");
    }
    final firstVar = vars[0];
    final decl = firstVar.split(" ");
    if(decl.length < 2) {
      throwUsageError("expected --${AFGenerateSubcommand.argMemberVariables} to have the form 'Type identifier'");
    }
    final result = decl[1];
    if(result == "id") {
      throwUsageError("--${AFGenerateSubcommand.argMemberVariables} cannot contain 'String id', please using something more specific, like 'String userId'");
    }

    return result;
  }

}