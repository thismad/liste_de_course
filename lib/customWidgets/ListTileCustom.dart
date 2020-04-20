import 'package:flutter/material.dart';

class ListTileCustom extends StatefulWidget {
  final String productName;

  ListTileCustom(this.productName);

  _ListTileState createState() => _ListTileState();
}

class _ListTileState extends State<ListTileCustom> with AutomaticKeepAliveClientMixin{
  bool inCart = false;

  @override
  get wantKeepAlive=> true;

  Widget build(BuildContext context) {
    print("$this inCart$inCart");
    return ListTile(
      title: Text(
        widget.productName,
        style: _buildText(),
      ),
      onTap: () {
        inCart ? inCart = false : inCart = true;
        setState(() {});
      },
    );
  }

  TextStyle _buildText() {
    TextStyle style;
    if (inCart) {
      style =
          TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough);
    } else {
      style = TextStyle(
          color: Colors.blue, fontSize: 19, fontWeight: FontWeight.w500);
    }
    return style;
  }
}
