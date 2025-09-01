import 'operators.dart';

class QueryCondition {
  String field;
  QueryOperator operator;
  dynamic value;

  QueryCondition({
    required this.field,
    required this.operator,
    required this.value,
  });

  QueryCondition.equals({
    required this.field,
    this.operator = QueryOperator.equals,
    required this.value,
  });
}
