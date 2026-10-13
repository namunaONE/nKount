import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global theme mode (light default; persisted in a later pass).
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);
