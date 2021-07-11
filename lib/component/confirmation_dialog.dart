import 'package:flutter/material.dart';

class ConfirmationDialog extends StatefulWidget {
  const ConfirmationDialog({
    Key key,
    @required this.title,
    @required this.message,
    this.height = 280,
    @required this.onPressConfirm,
  }) : super(key: key);

  final String title;
  final String message;
  final double height;
  final Function onPressConfirm;

  @override
  _ConfirmationDialogState createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: widget.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 15),
                width: MediaQuery.of(context).size.width * 0.75,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      (10),
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 40,
                      child: Text(
                        widget.title,
                        style: theme.textTheme.headline6
                            .copyWith(fontWeight: FontWeight.w600),
                        textScaleFactor: 1,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                      height: 1,
                      color: Colors.grey.withOpacity(0.7),
                    ),
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        alignment: Alignment.center,
                        child: Text(
                          widget.message,
                          style: theme.textTheme.bodyText1.copyWith(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.2,
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  width: 0.7,
                                  color: Colors.black.withOpacity(0.7)))),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: widget.onPressConfirm,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Delete',
                                  style: theme.textTheme.bodyText1
                                      .copyWith(color: Colors.red),
                                  textScaleFactor: 1.2,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 0.7,
                            height: 50,
                            color: Colors.black.withOpacity(0.7),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Cancel',
                                  style: theme.textTheme.bodyText1.copyWith(
                                    // fontWeight: FontWeight.normal,
                                    color: Colors.grey,
                                  ),
                                  textScaleFactor: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 20,
              ),
              child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      (100),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        border: Border.all(color: Colors.white)),
                    child: Icon(Icons.close, color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
