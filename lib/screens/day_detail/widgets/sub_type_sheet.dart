import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';

const subTypes = <String>[
  'Alpine Ski',
  'Badminton',
  'Canoeing',
  'Crossfit',
  'E-Bike Ride',
  'Fencing',
  'Golf',
  'Handball',
  'Ice Skate',
  'Inline Skate',
  'Kayaking',
  'Kitesurf',
  'Martial Arts',
  'Pilates',
  'Pickleball',
  'Racquetball',
  'Rock Climbing',
  'Roller Ski',
  'Rowing',
  'Rugby',
  'Sailing',
  'Skateboarding',
  'Snowboard',
  'Snowshoe',
  'Soccer',
  'Squash',
  'Stair Stepper',
  'Stand Up Paddling',
  'Swimming',
  'Table Tennis',
  'Trail Run',
  'Velomobile',
  'Virtual Ride',
  'Virtual Row',
  'Virtual Run',
  'Volleyball',
  'Weightlifting',
  'Wheelchair',
  'Windsurf',
  'Workout',
  'Yoga',
];

Future<String?> showSubTypeSheet(BuildContext context) {
  final colors = context.colors;
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: colors.scrim,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const _SubTypeSheet(),
  );
}

class _SubTypeSheet extends StatefulWidget {
  const _SubTypeSheet();

  @override
  State<_SubTypeSheet> createState() => _SubTypeSheetState();
}

class _SubTypeSheetState extends State<_SubTypeSheet> {
  final _search = TextEditingController();
  List<String> _filtered = subTypes;

  @override
  void initState() {
    super.initState();
    _search.addListener(_onSearch);
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _search.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filtered = subTypes;
      } else {
        _filtered =
            subTypes.where((s) => s.toLowerCase().contains(query)).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomSafe = MediaQuery.paddingOf(context).bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.65,
      ),
      decoration: BoxDecoration(
        color: colors.bgElevated,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(KRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(KRadius.full),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
            child: Text(
              'Choose activity type',
              style: KText.h3.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: colors.fgPrimary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _search,
              style: KText.body.copyWith(color: colors.fgPrimary),
              decoration: InputDecoration(
                hintText: 'Search…',
                hintStyle: KText.body.copyWith(color: colors.fgTertiary),
                prefixIcon: Icon(
                  LucideIcons.search,
                  size: 18,
                  color: colors.fgTertiary,
                ),
                filled: true,
                fillColor: colors.bgSubtle,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(KRadius.md),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Divider(height: 1, color: colors.borderSubtle),
          Flexible(
            child: _filtered.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'No results',
                      style: KText.body.copyWith(color: colors.fgTertiary),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(bottom: bottomSafe + KSpace.s2),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final name = _filtered[index];
                      return ListTile(
                        dense: true,
                        title: Text(
                          name,
                          style: KText.body.copyWith(color: colors.fgPrimary),
                        ),
                        onTap: () => Navigator.of(context).pop(name),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
