#!/bin/bash

if [[ $1 = '-eta' || $1 = 'extract_to_arb' ]]; then
	echo 'dart run intl_generator:extract_to_arb --output-dir=l10n-arb lib/l10n/localization_intl.dart'
	dart run intl_generator:extract_to_arb --output-dir=l10n-arb lib/l10n/localization_intl.dart
elif [[ $1 = '-gfa' || $1 = 'generate_from_arb' ]]; then
	echo 'dart run intl_generator:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/l10n/localization_intl.dart l10n-arb/intl_*.arb'
	dart run intl_generator:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/l10n/localization_intl.dart l10n-arb/intl_*.arb
elif [[ $1 = '-intl' || $1 = 'init_intl' ]]; then
	echo 'dart run intl_generator:extract_to_arb --output-dir=l10n-arb lib/l10n/localization_intl.dart
dart run intl_generator:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/l10n/localization_intl.dart l10n-arb/intl_*.arb'
	dart run intl_generator:extract_to_arb --output-dir=l10n-arb lib/l10n/localization_intl.dart
	dart run intl_generator:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/l10n/localization_intl.dart l10n-arb/intl_*.arb
else
	echo '
	usage: sh tool.sh [args]
	args:
 	-eta,extract_to_arb          intl_generator extract to arb
 	-gfa,generate_from_arb       intl_generator generate from arb
 	-h,help                      show usage
 	'
fi
exit 0