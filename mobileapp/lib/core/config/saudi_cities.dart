import '../../l10n/app_localizations.dart';

const saudiCityIds = <String>[
  'riyadh',
  'jeddah',
  'makkah',
  'madinah',
  'dammam',
  'khobar',
  'taif',
  'tabuk',
  'abha',
  'buraydah',
  'hail',
  'najran',
  'jazan',
  'yanbu',
];

String saudiCityLabel(AppLocalizations l10n, String id) {
  return switch (id) {
    'riyadh' => l10n.cityRiyadh,
    'jeddah' => l10n.cityJeddah,
    'makkah' => l10n.cityMakkah,
    'madinah' => l10n.cityMadinah,
    'dammam' => l10n.cityDammam,
    'khobar' => l10n.cityKhobar,
    'taif' => l10n.cityTaif,
    'tabuk' => l10n.cityTabuk,
    'abha' => l10n.cityAbha,
    'buraydah' => l10n.cityBuraydah,
    'hail' => l10n.cityHail,
    'najran' => l10n.cityNajran,
    'jazan' => l10n.cityJazan,
    'yanbu' => l10n.cityYanbu,
    _ => id,
  };
}
