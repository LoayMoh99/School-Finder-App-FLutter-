import 'package:flutter/material.dart';
import 'package:school_finder_app/ui/helper_widgets/textfield_widget.dart';

class ComparePage extends StatefulWidget {
  ComparePage({Key key}) : super(key: key);

  @override
  _ComparePageState createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Compare Schools'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                CompareColumn(schoolNo: 1),
                VerticalDivider(thickness: 2.5),
                CompareColumn(schoolNo: 2),
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              height: size.height * 0.09,
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Text(
                  'Compare',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.height * 0.035,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CompareColumn extends StatelessWidget {
  final schoolNo;

  const CompareColumn({Key key, this.schoolNo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.fromLTRB(4, 10, 4, 4),
        child: Column(
          children: <Widget>[
            TextFieldWidget(
              autoFocus: false,
              hintText: 'School $schoolNo',
              obscureText: false,
              prefixIconData: Icons.school,
            ),
          ],
        ),
      ),
    );
  }
}
