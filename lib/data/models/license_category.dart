/// Standard driving-license categories BUKI teaches. The imported question
/// bank also tags tractors, trams and military vehicles, but those aren't
/// offered here — add them to this list if that ever changes, nothing else
/// has to change.
///
/// 'A' and 'B' stand in for the A/A1 and B/B1 pairs: checked against the
/// source ticket bank, those pairs are tagged with the exact same question
/// set, so there's no separate 'A1' or 'B1' entry — [licenseCategoryLabel]
/// displays them as "A/A1" and "B/B1". C/C1 and D/D1 do differ in content
/// (different weight classes, different questions) and stay as distinct
/// entries.
const List<String> kLicenseCategories = ['AM', 'A', 'B', 'C1', 'C', 'D1', 'D'];

/// The label shown to the user for a category — see [kLicenseCategories]
/// for why 'A' and 'B' display as combined pairs.
String licenseCategoryLabel(String category) => switch (category) {
  'A' => 'A/A1',
  'B' => 'B/B1',
  _ => category,
};
