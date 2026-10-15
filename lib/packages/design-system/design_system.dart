/// nKount Design System v2 — Material 3 backed, split into parts.
///
/// - `src/tokens.dart` — spacing, radius, elevation, motion, color,
///   icon sizes, semantic icons, breakpoints, two-column layout.
/// - `src/typography.dart` — type scale + M3 themes.
/// - `src/scaffold.dart` — shell, sidebar, bars, buttons, navigation.
/// - `src/cards.dart` — cards, stats, trends, sparklines, rows, badges.
/// - `src/dialogs_inputs.dart` — dialogs, inputs, BS date picker.
/// - `src/location_inputs.dart` — Nepal province/district/palika picker.
///
/// Single-library `part of` split: no import cycles possible, and every
/// existing `Clay*` call-site keeps working unchanged.
library;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nepal_admin_api/nepal_admin_api.dart';
import 'package:nepali_utils/nepali_utils.dart';

import '../../app/commands.dart';
import '../../core/database/hive_service.dart';

part 'src/tokens.dart';
part 'src/typography.dart';
part 'src/scaffold.dart';
part 'src/cards.dart';
part 'src/dialogs_inputs.dart';
part 'src/location_inputs.dart';
