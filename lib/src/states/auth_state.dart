import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Very simple demo login state (false = logged out, true = logged in)
final authProvider = StateProvider<bool>((ref) => false);
