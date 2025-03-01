import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tezda/providers/expandable_text.dart';
import 'package:tezda/theme/colour.dart';

class ExpandableText extends StatelessWidget {
  final String? title;
  final String? content;
  final int? maxLines;
  const ExpandableText({
    Key? key,
    @required this.title,
    @required this.content,
    this.maxLines = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpandText(),
      child: Consumer<ExpandText>(builder: (context, expandText, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title!,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
            const Divider(
              height: 8,
              thickness: 1,
              endIndent: 16,
            ),
            Text(
              content!,
              maxLines: expandText.isExpanded ? null : maxLines,
              textAlign: TextAlign.left,
            ),
            GestureDetector(
              onTap: () {
                expandText.isExpanded ^= true;
              },
              child: Row(
                children: [
                  Text(
                    expandText.isExpanded == false ? "See more" : "Show less",
                    style: TextStyle(
                        color: AppColour.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: AppColour.grey,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
