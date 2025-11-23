import 'leadership_style.dart';

class AnswerOption {
  final String text;
  final Map<LeadershipStyle, int> weights;
  AnswerOption({required this.text, required this.weights});
}

class Question {
  final String id;
  final String text;
  final List<AnswerOption> options;
  Question({required this.id, required this.text, required this.options});
}

