import '../models/leadership_style.dart';
import '../services/feedback_engine.dart';
import 'msq_scoring.dart';

FeedbackResult msqToFeedback(MsqScores s) {
  int pts(String k) => ((s.factorMeans[k] ?? 0) * 10).round();

  final scores = {
    LeadershipStyle.transformational : pts('transformational'),
    LeadershipStyle.democratic       : pts('democratic'),
    LeadershipStyle.autocratic       : pts('autocratic'),
    LeadershipStyle.laissezFaire     : pts('laissez_faire'),
    LeadershipStyle.coaching         : pts('coaching'),
  };

  return generateFeedback(scores);
}
