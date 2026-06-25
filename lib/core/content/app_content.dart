/// Static institutional content (not sample/mock data) — the inspirational
/// verse shown on the dashboard hero.
class IslamicQuote {
  const IslamicQuote({
    required this.arabic,
    required this.translation,
    required this.source,
  });

  final String arabic;
  final String translation;
  final String source;
}

const IslamicQuote kDashboardQuote = IslamicQuote(
  arabic: 'وَأَعِدُّوا لَهُم مَّا اسْتَطَعْتُم مِّن قُوَّةٍ',
  translation: 'And prepare against them whatever you are able of power.',
  source: 'Surah Al-Anfal — 8:60',
);
