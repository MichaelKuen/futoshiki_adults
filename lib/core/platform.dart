import 'package:flutter/foundation.dart';

/// True for the web build embedded on appversegames.com.
///
/// Same as [kIsWeb] in production; it is a variable only so VM tests can
/// exercise the web layout and flow.
bool isWebEmbed = kIsWeb;
