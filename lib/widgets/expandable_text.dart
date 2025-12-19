import 'package:flutter/material.dart';
import 'package:phluowise/utils/hexColor.dart';

class ExpandableGradientText extends StatefulWidget {
  final String text;
  final int trimLines;

  const ExpandableGradientText({
    super.key,
    required this.text,
    this.trimLines = 3,
  });

  @override
  State<ExpandableGradientText> createState() => _ExpandableGradientTextState();
}

class _ExpandableGradientTextState extends State<ExpandableGradientText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Measure if text overflows
        final span = TextSpan(
          text: widget.text,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: Colors.white,
          ),
        );

        final tp = TextPainter(
          maxLines: widget.trimLines,
          text: span,
          textDirection: TextDirection.ltr,
        );

        tp.layout(maxWidth: constraints.maxWidth);

        final isOverflow = tp.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // TEXT
                Text(
                  widget.text,
                  maxLines: _expanded ? null : widget.trimLines,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                    height: 1.5,
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),

                // GRADIENT OVERLAY (only when collapsed)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 30,
                  child: IgnorePointer(
                    ignoring: true,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color(0x7A000000), // #0000007A
                            Color(0x00FFFFFF), // #FFFFFF00
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // "More" / "Less"
            if (isOverflow)
              InkWell(
                onTap: () {
                  setState(() => _expanded = !_expanded);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: HexColor('#40444B'),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Text(
                    _expanded ? "less -" : "more +",
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
