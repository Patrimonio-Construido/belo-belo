import 'package:flutter/material.dart';

import 'package:belobelo/models/credits_section_model.dart';

class CreditsHeadingWidget extends StatelessWidget {
  final CreditsSection section;
  final Color color;

  const CreditsHeadingWidget({
    super.key,
    required this.section,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          section.title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 10),
        for (final name in section.names)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              name,
              style: TextStyle(fontSize: 15, color: color),
            ),
          ),
      ],
    );
  }
}

class CreditsRoleRowWidget extends StatelessWidget {
  final CreditsSection section;
  final Color color;
  final double labelWidth;

  const CreditsRoleRowWidget({
    super.key,
    required this.section,
    required this.color,
    this.labelWidth = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              '${section.title}:',
              style: TextStyle(fontSize: 15, color: color),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final name in section.names)
                  Text(name, style: TextStyle(fontSize: 15, color: color)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
