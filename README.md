# Markazosshabab Al-Muslim Fil-Filibbin Foundation, Inc. 

مؤسسة مركز الشباب المسلم بالفلبين

An **offline internal Documentation & Archive System** for the Muslim youth
organization in the Philippines. Built with Flutter for **Android tablets in
landscape (1280×800)**. Used only by authorized personnel — Administrators,
Leadership, Board of Trustees, Consultative Assembly, and Department Heads.

## Status

A bilingual (EN/AR), tablet-first archive UI with a complete design system and
all major modules wired with mock data.

**Foundation**

- **Design tokens** — emerald / navy / gold / ivory / charcoal color system,
  bilingual typography (Cormorant Garamond headings, Inter UI, Amiri Arabic),
  spacing / radius / elevation, Material 3 theme. See `lib/core/theme/`.
- **Islamic geometric pattern** — drawn in code (`lib/core/patterns/`).
- **Reusable components** (`lib/widgets/`) — sidebar, top bar, app shell,
  bilingual title, profile header, portrait avatar, stat card, role badge,
  info panel, hierarchy breadcrumb, search field + filter bar, timeline item,
  and leadership / department / report / gallery / user cards, plus empty /
  loading / error states.
- **Split-screen login** — brand + mission panel and credential card.
- **EN ⇄ AR** toggle with full **RTL** mirroring across every screen.

**Modules**

- **Dashboard** — welcome hero (Qur’anic quote) + statistics cards.
- **Leadership** — category-grouped cards + full profile (biography,
  achievements, contact, responsibilities).
- **Departments** — card grid + department detail.
- **Tarbiya Kawadeer** — 4-level hierarchy (Area → Municipality → Roster →
  Member) with breadcrumbs and a full member profile (personal, demographic,
  leadership, naqib, tas‘ed, activity history).
- **Reports** — searchable, category-filtered list with a PDF preview pane.
- **Gallery** — year-filtered masonry grid with a lightbox.
- **Search** — unified search across members, leaders, departments, reports,
  and photos, grouped with category badges.
- **User Management** (admin) — searchable list, create / edit / disable /
  reset-password.
- **Audit Logs** (admin) — chronological action timeline.
- **History** — founding hero, key facts, and a milestones timeline.
- **Settings** — account summary, language (EN/AR) switch, notification
  toggles, and application/about info.

Every sidebar destination is now a fully built screen.

## Running

```bash
flutter pub get
flutter run            # choose an Android tablet emulator (landscape)
# or for a quick desktop/web preview:
flutter run -d chrome
```

Mock sign-in: any non-empty username and password (pre-filled `admin` /
`markaz`). The default session is an **Administrator** so the admin-only
sidebar items (User Management, Audit Logs) are visible for review.

## Assets

Fonts (OFL) are bundled in `assets/fonts/` for offline use. Drop the real
organization seal at `assets/images/logo.png` to replace the placeholder emblem.

## Project layout

```
lib/
  app/        # app root, router, navigation model
  core/       # theme tokens, i18n, patterns, mock data, session
  widgets/    # reusable design-system components
  features/   # login, dashboard, placeholder screens
```

## Verification

```bash
flutter analyze   # no issues
flutter test      # boot, sign-in → dashboard, EN→AR (RTL) smoke tests
```
