import 'package:flutter/material.dart';
import 'package:tezda/theme/colour.dart';
// import 'package:google_fonts/google_fonts.dart';

class CustomFlatButton extends StatelessWidget {
  const CustomFlatButton(
      {Key? key,
      this.onPressed,
      this.label,
      this.isLoading,
      this.color,
      this.labelStyle,
      this.isWraped = false,
      this.width,
      this.borderRadius = 6.0,
      this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      this.onTap})
      : super(key: key);
  final Function? onTap;
  final void Function()? onPressed;
  final String? label;
  final TextStyle? labelStyle;
  final ValueNotifier<bool>? isLoading;
  final bool? isWraped;
  final double? width;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isWraped!
          ? null
          : width != 0
              ? width
              : double.infinity,
      child: ValueListenableBuilder<bool>(
        valueListenable: isLoading ?? ValueNotifier(false),
        builder: (context, loading, child) {
          return TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(padding),
              backgroundColor: MaterialStateProperty.all(
                loading
                    ? Theme.of(context).disabledColor
                    : color ?? Theme.of(context).primaryColor,
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius!)),
              ),
              overlayColor: MaterialStateProperty.all(
                  color ?? Theme.of(context).primaryColorDark),
              foregroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            onPressed: loading ? null : onPressed,
            child: loading
                ? SizedBox(
                    height: 22,
                    width: 22,
                    child: FittedBox(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(AppColour.white),
                      ),
                    ),
                  )
                : child!,
          );
        },
        child: Text(label!, style: labelStyle),
      ),
    );
  }
}
