import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Institutional history content (the organization's actual milestones and
/// founding statement) — fixed app content, not sample data.

/// A milestone in the organization's history.
class Milestone {
  const Milestone({
    required this.year,
    required this.title,
    required this.titleAr,
    required this.description,
    required this.descriptionAr,
    required this.icon,
    required this.color,
  });

  final String year;
  final String title;
  final String titleAr;
  final String description;
  final String descriptionAr;
  final IconData icon;
  final Color color;
}

/// A bilingual paragraph of narrative text.
typedef Bilingual = ({String en, String ar});

/// Founding statement shown on the History hero (a concise lead).
const String kFoundingEn =
    'Founded in 1978 by young Filipino Muslim students abroad and formally '
    'registered in 1983, Markazosshabab Al-Muslim has grown into one of the '
    'largest Islamic youth organizations in the Philippines, with 64 branches '
    'nationwide.';

const String kFoundingAr =
    'تأسس مركز الشباب المسلم عام ١٩٧٨م على أيدي طلابٍ مسلمين فلبينيين في المهجر، '
    'وسُجِّل رسميًا عام ١٩٨٣م، حتى غدا من أكبر المنظمات الشبابية الإسلامية في '
    'الفلبين، وله أربعة وستون فرعًا في أنحاء البلاد.';

/// The full founding narrative, paragraph by paragraph.
const List<Bilingual> kHistoryNarrative = [
  (
    en: 'The roots of the organization trace back to 1978, when a group of '
        'young Filipino Muslim (Moro) students studying abroad — particularly '
        'in the State of Kuwait — were moved by the social conditions facing '
        'their people back home, especially in Lanao del Sur. Anchored in the '
        'Qur’anic principle that “Indeed, Allah will not change the '
        'condition of a people until they change what is in themselves” '
        '(13:11), they believed authentic reform had to spring from within the '
        'people before it could transform the wider community.',
    ar: 'تعود جذور المنظمة إلى عام ١٩٧٨م، حين تأثّرت مجموعةٌ من الطلاب المسلمين '
        'الفلبينيين (المورو) الدارسين في الخارج — ولا سيما في دولة الكويت — '
        'بالأوضاع الاجتماعية التي يعيشها أهلهم في الوطن، وبخاصة في لاناو ديل '
        'سور. وانطلاقًا من قوله تعالى: «إِنَّ اللَّهَ لَا يُغَيِّرُ مَا بِقَوْمٍ '
        'حَتَّى يُغَيِّرُوا مَا بِأَنفُسِهِمْ» (الرعد: ١١)، آمنوا بأن الإصلاح '
        'الحق لا بدّ أن ينبع من داخل الناس قبل أن يُصلح المجتمع بأسره.',
  ),
  (
    en: 'Led by the late Muhammad Qasim Tarusan, these young idealists '
        'organized a group guided by Islamic creed and ideology, first known '
        'as “Shababul Muslim.” Their clear mission and tireless devotion to '
        'spreading the Islamic message attracted people from all walks of '
        'life, especially youth, even while still abroad.',
    ar: 'وبقيادة المرحوم محمد قاسم تاروسان، نظّم هؤلاء الشباب المثاليون جماعةً '
        'تستند إلى العقيدة والفكر الإسلامي، عُرفت أولًا باسم «شباب المسلم». وقد '
        'استقطبت رسالتهم الواضحة وتفانيهم الدؤوب في نشر الدعوة الإسلامية الناس '
        'من مختلف المشارب، وبخاصة الشباب، وهم لا يزالون في المهجر.',
  ),
  (
    en: 'Five years later, in 1983, after more Filipino students returned home '
        'from Middle Eastern universities, the group was formally reorganized '
        'and registered with the Securities and Exchange Commission in Manila '
        'under its present name: Markazosshabab Al-Muslim Fil-Filibbin '
        '(Philippine Muslim Youth Center).',
    ar: 'وبعد خمس سنوات، في عام ١٩٨٣م، وعقب عودة المزيد من الطلاب الفلبينيين من '
        'جامعات الشرق الأوسط، أُعيد تنظيم الجماعة رسميًا وسُجِّلت لدى هيئة '
        'الأوراق المالية والبورصة في مانيلا باسمها الحالي: مركز الشباب المسلم '
        'في الفلبين.',
  ),
  (
    en: 'In the decades since, the brotherhood has survived and strengthened, '
        'with its founders’ original goals remaining its driving force. '
        'It grew into one of the largest non-profit, non-government Islamic '
        'organizations in the Philippines, establishing 64 branches across '
        'various cities and provinces nationwide.',
    ar: 'وعلى مدى العقود التالية، صمدت هذه الأخوّة وازدادت قوة، وبقيت أهداف '
        'مؤسسيها الأولى هي محرّكها الأساس. فنمت لتصبح من أكبر المنظمات الإسلامية '
        'غير الربحية وغير الحكومية في الفلبين، وأنشأت أربعة وستين فرعًا في مدنٍ '
        'ومحافظات متعددة على امتداد البلاد.',
  ),
];

/// Mission statement.
const Bilingual kMission = (
  en: 'To educate the generation and serve the community in a comprehensive '
      'way for peace and prosperity.',
  ar: 'تربية الجيل وخدمة المجتمع بصورةٍ شاملة من أجل السلام والازدهار.',
);

/// Vision statement.
const Bilingual kVision = (
  en: 'A firm Islamic-centered organization leading the ranks to strengthen '
      'religiosity, serve the people, and develop the community.',
  ar: 'منظمةٌ راسخةٌ محورها الإسلام، تقود الصفوف لتعزيز التديّن، وخدمة الناس، '
      'وتنمية المجتمع.',
);

const List<Milestone> kMilestones = [
  Milestone(
    year: '1978',
    title: 'Founding Abroad',
    titleAr: 'النشأة في المهجر',
    description:
        'Young Filipino Muslim students in Kuwait, led by the late shiekh Muhammad '
        'Qasim Tarusan, form a group known as “Shababul Muslim.”',
    descriptionAr:
        'طلابٌ مسلمون فلبينيون في الكويت، بقيادة المرحوم محمد قاسم تاروسان، '
        'يؤسسون جماعةً عُرفت باسم «شباب المسلم».',
    icon: Icons.public_outlined,
    color: AppColors.emerald,
  ),
  Milestone(
    year: '1983',
    title: 'Formal Registration',
    titleAr: 'التسجيل الرسمي',
    description:
        'Reorganized as returning students come home, and registered with the '
        'SEC in Manila as Markazosshabab Al-Muslim Fil-Filibbin.',
    descriptionAr:
        'إعادة التنظيم مع عودة الطلاب، والتسجيل لدى هيئة الأوراق المالية في '
        'مانيلا باسم مركز الشباب المسلم في الفلبين.',
    icon: Icons.verified_outlined,
    color: AppColors.navy,
  ),
  Milestone(
    year: 'Today',
    title: 'A Nationwide Brotherhood',
    titleAr: 'أخوّةٌ على امتداد الوطن',
    description:
        'Grown into one of the largest non-profit Islamic organizations in the '
        'Philippines, with 64 branches across the country.',
    descriptionAr:
        'نمت لتصبح من أكبر المنظمات الإسلامية غير الربحية في الفلبين، ولها '
        'أربعة وستون فرعًا في أنحاء البلاد.',
    icon: Icons.hub_outlined,
    color: AppColors.goldDeep,
  ),
];
