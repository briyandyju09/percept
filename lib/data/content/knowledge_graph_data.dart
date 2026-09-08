/// Hand-curated "Knowledge Graph" reference material per discipline —
/// real, well-known books and a couple of researchers/thinkers worth
/// knowing, presented as a browsable reference shelf rather than
/// something to "complete." Deliberately not attributed with fabricated
/// study citations; these are just widely known works/names in each
/// area.
class KnowledgeGraphEntry {
  const KnowledgeGraphEntry({
    required this.books,
    required this.experts,
    required this.researchAreas,
  });

  final List<String> books;
  final List<String> experts;
  final List<String> researchAreas;
}

const Map<String, KnowledgeGraphEntry> kKnowledgeGraph = {
  'observation': KnowledgeGraphEntry(
    books: [
      'The Invisible Gorilla — Christopher Chabris & Daniel Simons',
      'Sherlock Holmes: The Complete Novels and Stories — Arthur Conan Doyle (as a study in fictional method, not fact)',
    ],
    experts: ['Christopher Chabris', 'Daniel Simons'],
    researchAreas: ['Inattentional blindness', 'Visual working memory', 'Change blindness'],
  ),
  'psychology': KnowledgeGraphEntry(
    books: [
      'Thinking, Fast and Slow — Daniel Kahneman',
      'Influence — Robert Cialdini',
      'Predictably Irrational — Dan Ariely',
    ],
    experts: ['Daniel Kahneman', 'Amos Tversky', 'Robert Cialdini'],
    researchAreas: ['Heuristics and biases', 'Prospect theory', 'Social influence'],
  ),
  'reading_people': KnowledgeGraphEntry(
    books: [
      'Emotions Revealed — Paul Ekman',
      'What Every BODY is Saying — Joe Navarro (read critically — treat single cues skeptically)',
    ],
    experts: ['Paul Ekman'],
    researchAreas: ['Facial expression research', 'Baseline behavior analysis'],
  ),
  'conversation': KnowledgeGraphEntry(
    books: [
      'Nonviolent Communication — Marshall Rosenberg',
      'Difficult Conversations — Douglas Stone, Bruce Patton & Sheila Heen',
      'How to Win Friends and Influence People — Dale Carnegie',
    ],
    experts: ['Marshall Rosenberg'],
    researchAreas: ['Active listening', 'Negotiation theory', 'Rapport building'],
  ),
  'mentalism': KnowledgeGraphEntry(
    books: [
      '13 Steps to Mentalism — Tony Corinda',
      'Fool Us — various performance-magic essays on misdirection and framing',
    ],
    experts: ['Tony Corinda', 'Derren Brown (performance psychology, not real telepathy)'],
    researchAreas: ['Misdirection & attention', 'Forcing techniques', 'Cold-reading structure'],
  ),
  'composure': KnowledgeGraphEntry(
    books: [
      'Why Zebras Don\'t Get Ulcers — Robert Sapolsky',
      'The Body Keeps the Score — Bessel van der Kolk (read as general context, not clinical advice)',
    ],
    experts: ['Robert Sapolsky'],
    researchAreas: ['Stress physiology', 'Breathing & the vagus nerve', 'Emotional regulation'],
  ),
  'character': KnowledgeGraphEntry(
    books: [
      'Man\'s Search for Meaning — Viktor Frankl',
      'The Road to Character — David Brooks',
      'Meditations — Marcus Aurelius',
    ],
    experts: ['Viktor Frankl'],
    researchAreas: ['Post-traumatic growth', 'Virtue ethics', 'Habit formation'],
  ),
};
