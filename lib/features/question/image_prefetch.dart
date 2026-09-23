import 'package:flutter/widgets.dart';

import '../../data/models/question.dart';

/// Warms the image cache for [question]'s photo so navigating to it next
/// doesn't have to wait on a fresh network fetch (the web build only —
/// the installed app bundles photos locally and never hits the network).
void precacheQuestionImage(BuildContext context, Question? question) {
  final image = question?.image;
  if (image == null) return;
  precacheImage(AssetImage('assets/images/questions/$image'), context);
}
