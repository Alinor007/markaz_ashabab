import 'package:flutter/material.dart';

/// A fixed catalog of selectable icons keyed by a stable string. Storing the
/// key (not a dynamic codepoint) keeps Flutter's icon tree-shaking working and
/// gives departments/gallery a consistent, curated icon set.
const Map<String, IconData> kIconCatalog = {
  'dawah': Icons.campaign_outlined,
  'tarbiyah': Icons.hub_outlined,
  'education': Icons.school_outlined,
  'economy': Icons.account_balance_outlined,
  'charity': Icons.volunteer_activism_outlined,
  'media': Icons.podcasts_outlined,
  'politics': Icons.gavel_outlined,
  'women': Icons.diversity_1_outlined,
  'mosque': Icons.mosque_outlined,
  'book': Icons.menu_book_outlined,
  'group': Icons.groups_outlined,
  'event': Icons.event_available_outlined,
  'photo': Icons.photo_outlined,
  'flag': Icons.flag_outlined,
  'star': Icons.star_outline,
  'handshake': Icons.handshake_outlined,
};

IconData iconForKey(String key) =>
    kIconCatalog[key] ?? Icons.account_tree_outlined;

/// Keys offered in icon pickers, in display order.
const List<String> kIconKeys = [
  'dawah', 'tarbiyah', 'education', 'economy', 'charity', 'media',
  'politics', 'women', 'mosque', 'book', 'group', 'event',
  'photo', 'flag', 'star', 'handshake',
];
