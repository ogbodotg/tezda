import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tezda/theme/colour.dart';
import 'package:intl/intl.dart';

class Services {
  // navigator
  void navigateTo(String path, arguments, context) {
    Navigator.pushNamed(context, path, arguments: arguments);
  }

  // app wide sized box
  Widget sizedBox({double? h, double? w}) {
    return SizedBox(
      height: h ?? 0,
      width: w ?? 0,
    );
  }

  // logo
  Widget logo(height, width) {
    return Image.asset(
      'assets/images/tezda.png',
      height: height,
      width: width,
    );
  }

  // logo2
  Widget logo2(height, width) {
    return Image.asset(
      'assets/images/tezda-logo.png',
      height: height,
      width: width,
    );
  }

  // auth text
  Widget authText(
      {String? bigText,
      String? smallText,
      CrossAxisAlignment? crossAxisAlignment,
      MainAxisAlignment? mainAxisAlignment,
      TextAlign? textAlign,
      double? bigTextFontSize}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          bigText!,
          style: TextStyle(
              fontSize: bigTextFontSize ?? 38, fontWeight: FontWeight.bold),
        ),
        Text(
          smallText!,
          style: authScreenTextStyle,
        ),
      ],
    );
  }

// auth text style
  TextStyle authScreenTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );

  // label style
  TextStyle formFieldLableStyle = const TextStyle(fontWeight: FontWeight.bold);

  // text form field
  Widget formField({
    controller,
    label,
    hint,
    validator,
    keyboardType,
    initialValue,
    isPhoneNumberField = false,
    showLabel = true,
    showHint = false,
    maxLines,
    formFill = true,
    context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showLabel == false
            ? Container()
            : Text(
                label,
                style: formFieldLableStyle,
              ),
        if (!isPhoneNumberField) sizedBox(h: 5),
        TextFormField(
            controller: initialValue == null ? controller : null,
            keyboardType: keyboardType,
            validator: validator,
            initialValue: initialValue,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: showHint == true ? hint : '',
              filled: formFill == false ? false : true,
              fillColor: AppColour.grey.withOpacity(0.1),
              labelStyle: const TextStyle(color: Colors.black),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              enabledBorder: OutlineInputBorder(
                  borderRadius: isPhoneNumberField == false
                      ? const BorderRadius.all(Radius.circular(14.0))
                      : const BorderRadius.only(
                          topRight: Radius.circular(14),
                          bottomRight: Radius.circular(14.0)),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  )),
              focusedBorder: OutlineInputBorder(
                borderRadius: isPhoneNumberField == false
                    ? const BorderRadius.all(Radius.circular(14.0))
                    : const BorderRadius.only(
                        topRight: Radius.circular(14),
                        bottomRight: Radius.circular(14.0)),
                borderSide:
                    const BorderSide(color: AppColour.primary, width: 2),
              ),
              focusColor: AppColour.primary,
            )),
      ],
    );
  }

  // password field
  Widget passwordFormField(
      {controller,
      label,
      validator,
      keyboardType,
      visible,
      onPressed,
      context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: formFieldLableStyle,
        ),
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: visible == true ? false : true,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColour.grey.withOpacity(0.1),
            suffixIcon: IconButton(
              icon: visible
                  ? const Icon(
                      Icons.remove_red_eye_outlined,
                      color: AppColour.primary,
                    )
                  : Icon(
                      Icons.visibility_off,
                      color: AppColour.grey,
                    ),
              onPressed: onPressed,
            ),
            // enabledBorder: OutlineInputBorder(),
            // contentPadding: EdgeInsets.zero,
            hintText: '***********',

            labelStyle: const TextStyle(color: Colors.black),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14.0)),
                borderSide: BorderSide(
                  color: Colors.grey,
                )),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14.0)),
              borderSide: BorderSide(color: AppColour.primary, width: 2),
            ),
            focusColor: AppColour.primary,
          ),
        ),
      ],
    );
  }

  // app bar
  PreferredSizeWidget appBar({showBackButton, context}) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: showBackButton == false
          ? Center(child: logo2(60.0, 130.0))
          : Row(children: [
              IconButton(
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              sizedBox(w: 60),
              Center(child: logo2(60.0, 130.0)),
            ]),
    );
  }

  // app bar
  PreferredSizeWidget mainAppBar({context}) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: logo2(60.0, 150.0),
      actions: [
        Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: AppColour.grey,
              )),
          child: IconButton(
              onPressed: null,
              icon: Icon(Icons.search_outlined,
                  size: 20, color: AppColour.black)),
        ),
        sizedBox(w: 10),
        Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: AppColour.grey,
              )),
          child: IconButton(
              onPressed: null,
              icon: Icon(Icons.shopping_cart_outlined,
                  size: 20, color: AppColour.black)),
        ),
        sizedBox(w: 20),
      ],
    );
  }

// loader
  showLoader(radius) {
    return Platform.isIOS
        ? const CupertinoActivityIndicator(
            radius: 100,
            color: AppColour.primary,
          )
        : const CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColour.primary,
          );
  }

// cached image
  Widget cachedImage({imageUrl, height, width}) {
    return CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
          child: SizedBox(
        height: 1.0,
        width: 35.0,
        child: LinearProgressIndicator(
          value: downloadProgress.progress,
          color: AppColour.primary.withOpacity(0.4),
        ),
      )),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

// format currency
  String formatPrice({context, amount}) {
    var format =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: '£');
    return '${format.currencySymbol}$amount';
  }
}
