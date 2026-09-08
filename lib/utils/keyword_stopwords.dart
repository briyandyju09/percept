/// A fixed stopword list used to strip filler words before comparing a
/// user's free-text reply against a scenario's authored `keyTerms` /
/// `expectedAnswerTerms`. Deliberately small and deterministic — this is
/// not NLP, it's a simple, auditable heuristic.
const Set<String> kStopwords = {
  'a', 'an', 'the', 'and', 'or', 'but', 'if', 'then', 'so', 'because',
  'as', 'of', 'at', 'by', 'for', 'with', 'about', 'against', 'between',
  'into', 'through', 'during', 'before', 'after', 'above', 'below', 'to',
  'from', 'up', 'down', 'in', 'out', 'on', 'off', 'over', 'under', 'again',
  'further', 'once', 'here', 'there', 'when', 'where', 'why', 'how', 'all',
  'any', 'both', 'each', 'few', 'more', 'most', 'other', 'some', 'such',
  'no', 'nor', 'not', 'only', 'own', 'same', 'than', 'too', 'very', 's',
  't', 'can', 'will', 'just', 'don', 'should', 'now', 'i', 'me', 'my',
  'myself', 'we', 'our', 'ours', 'ourselves', 'you', 'your', 'yours',
  'yourself', 'yourselves', 'he', 'him', 'his', 'himself', 'she', 'her',
  'hers', 'herself', 'it', 'its', 'itself', 'they', 'them', 'their',
  'theirs', 'themselves', 'what', 'which', 'who', 'whom', 'this', 'that',
  'these', 'those', 'am', 'is', 'are', 'was', 'were', 'be', 'been',
  'being', 'have', 'has', 'had', 'having', 'do', 'does', 'did', 'doing',
  "i'm", "you're", "it's", "don't", "didn't", "isn't", "wasn't",
  'really', 'like', 'well', 'yeah', 'okay', 'ok',
};

/// Lowercases, strips punctuation, and removes stopwords — the single
/// normalization path every rule-based scorer runs user text through.
Set<String> extractKeyTokens(String text) {
  final lowered = text.toLowerCase();
  final cleaned = lowered.replaceAll(RegExp(r"[^a-z0-9'\s]"), ' ');
  final words = cleaned.split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
  return words.where((w) => !kStopwords.contains(w)).toSet();
}
