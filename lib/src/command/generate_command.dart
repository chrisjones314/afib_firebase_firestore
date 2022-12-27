import 'package:afib/afib_command.dart';

class GenerateCommand extends AFCommand {
  static const argExample = "example";

  @override
  final name = "affs:generate";

  @override
  final description = "TODO: describe your command";

  @override 
  String get usage {
    return '''
  $nameOfExecutable $name YourValue [options]

$usageHeader

$descriptionHeader
  $description

$optionsHeader
  --$argExample ExampleArgValue
''';
  }

  @override
  Future<void> execute(AFCommandContext context) async {

    // parse arguments with default values as follows
    final args = context.parseArguments(
      command: this,
      unnamedCount: 1,
      named: {
        argExample: "yourdefaultvalue"
      }
    );

    // see superclass verify... methods for useful verifications,
    // see throwUsageError for reporting errors.

    final output = context.output;
    final unnamed = args.accessUnnamedFirst;
    final example = args.accessNamed(argExample);

    output.writeTwoColumns(
      col1: "unnamed ",
      col2: unnamed,
    );

    output.writeTwoColumns(
      col1: "named ",
      col2: "$argExample -> $example"
    );
  }
}