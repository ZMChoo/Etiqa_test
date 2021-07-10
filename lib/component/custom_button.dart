import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key key, this.buttonText, this.onPressed}) : super(key: key);

  final String buttonText;
  final Function onPressed;
  // final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          color: Colors.black,
          child: Text(
            buttonText,
            style: theme.textTheme.bodyText1.copyWith(
              // color: isDisabled
              //     ? Colors.white
              //     : isDarkBackground
              //         ? Colors.white.withOpacity(0.8)
              //         : Colors.black,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
            textScaleFactor: 1.1,
          ),
        ),
      ),
    );
  }
}
