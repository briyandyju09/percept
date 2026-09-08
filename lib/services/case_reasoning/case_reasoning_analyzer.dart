import '../../models/case_file.dart';
import '../../models/case_progress.dart';
import '../../models/cognitive_bias_flag.dart';

/// Analyzes how a player reasoned through a [CaseFile] — which questions
/// they asked, which evidence they viewed, and who they ultimately
/// accused — and returns a debrief. `RuleBasedCaseReasoningAnalyzer` reads
/// authored tags on questions/evidence; a real LLM-backed analyzer could
/// later implement this same interface over the full interview transcript.
abstract class CaseReasoningAnalyzer {
  CaseDebriefResult analyze(CaseFile caseFile, CaseProgress progress);
}
