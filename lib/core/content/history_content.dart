/// Default institutional history content used to **seed** the editable History
/// page on first launch / upgrade. After seeding, the live content lives in the
/// database (`history_contents`, `history_milestones`) and is editable by
/// executives — these constants are only the starting point.
library;

/// Founding statement shown on the History hero (a concise lead).
const String kFoundingEn =
    'Founded in 1978 by young Filipino Muslim students abroad and formally '
    'registered in 1983, Markazosshabab Al-Muslim Fil-Filibbin Foundation, Inc. has grown into one of the '
    'largest Islamic youth organizations in the Philippines, with 64 branches '
    'nationwide.';

/// The full founding narrative, paragraph by paragraph.
const List<String> kHistoryNarrative = [
  'The roots of the organization trace back to 1978, when a group of '
      'young Filipino Muslim (Moro) students studying abroad — particularly '
      'in the State of Kuwait — were moved by the social conditions facing '
      'their people back home, especially in Lanao del Sur. Anchored in the '
      'Qur’anic principle that “Indeed, Allah will not change the '
      'condition of a people until they change what is in themselves” '
      '(13:11), they believed authentic reform had to spring from within the '
      'people before it could transform the wider community.',
  'Led by the late Muhammad Qasim Tarusan, these young idealists '
      'organized a group guided by Islamic creed and ideology, first known '
      'as “Shababul Muslim.” Their clear mission and tireless devotion to '
      'spreading the Islamic message attracted people from all walks of '
      'life, especially youth, even while still abroad.',
  'Five years later, in 1983, after more Filipino students returned home '
      'from Middle Eastern universities, the group was formally reorganized '
      'and registered with the Securities and Exchange Commission in Manila '
      'under its present name: Markazosshabab Al-Muslim Fil-Filibbin Foundation, Inc. '
      '(Philippine Muslim Youth Center).',
  'In the decades since, the brotherhood has survived and strengthened, '
      'with its founders’ original goals remaining its driving force. '
      'It grew into one of the largest non-profit, non-government Islamic '
      'organizations in the Philippines, establishing 64 branches across '
      'various cities and provinces nationwide.',
];

/// Mission statement.
const String kMission =
    'To educate the generation and serve the community in a comprehensive '
    'way for peace and prosperity.';

/// Vision statement.
const String kVision =
    'A firm Islamic-centered organization leading the ranks to strengthen '
    'religiosity, serve the people, and develop the community.';

/// A seed stat card for the History hero (value + label + icon/accent).
typedef FactSeed = ({
  String value,
  String en,
  String iconKey,
  int accent,
});

/// Default stat cards.
const List<FactSeed> kDefaultFacts = [
  (value: '1978', en: 'Founded', iconKey: 'flag', accent: 0xFF0B5D3B),
  (value: '64', en: 'Branches', iconKey: 'group', accent: 0xFF16243D),
  (value: '40+', en: 'Years of Service', iconKey: 'star', accent: 0xFFA8862F),
];

/// A seed milestone (timeline entry) in DB-friendly form (icon key + accent int).
typedef MilestoneSeed = ({
  String year,
  String title,
  String description,
  String iconKey,
  int accent,
});

const List<MilestoneSeed> kDefaultMilestones = [
  (
    year: '1978',
    title: 'Founding Abroad',
    description:
        'Young Filipino Muslim students in Kuwait, led by the late shiekh Muhammad '
        'Qasim Tarusan, form a group known as “Shababul Muslim.”',
    iconKey: 'mosque',
    accent: 0xFF0B5D3B,
  ),
  (
    year: '1983',
    title: 'Formal Registration',
    description:
        'Reorganized as returning students come home, and registered with the '
        'SEC in Manila as Markazosshabab Al-Muslim Fil-Filibbin Foundation, Inc.',
    iconKey: 'flag',
    accent: 0xFF16243D,
  ),
  (
    year: 'Today',
    title: 'A Nationwide Brotherhood',
    description:
        'Grown into one of the largest non-profit Islamic organizations in the '
        'Philippines, with 64 branches across the country.',
    iconKey: 'group',
    accent: 0xFFA8862F,
  ),
];
