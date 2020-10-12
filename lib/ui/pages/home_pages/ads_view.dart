import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_finder_app/viewmodels/ads_view_model.dart';
import 'package:school_finder_app/viewmodels/change_ntifier_helper.dart';

class AdsView extends StatefulWidget {
  final Size size;

  const AdsView({this.size});

  @override
  _AdsViewState createState() => _AdsViewState();
}

class _AdsViewState extends State<AdsView> {
  @override
  void initState() {
    super.initState();
    Provider.of<AdsViewModel>(context, listen: false).getAds();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.widget.size.width,
      height: this.widget.size.height * 0.25,
      child: Consumer<AdsViewModel>(
        builder: (_, notifier, __) {
          if (notifier.state == NotifierState.initial) {
            return Center(
              child: Text('No Ads'),
            );
          } else if (notifier.state == NotifierState.loading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return notifier.ads.fold((failure) {
              return Center(
                child: Text(failure.message()),
              );
            }, (ads) {
              bool showAd = (ads != null && ads.isNotEmpty);
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: showAd ? ads.length : 1,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(0, 8, 8, 8),
                    width: this.widget.size.width,
                    child: showAd
                        ? Container(
                            margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                FittedBox(
                                  fit: BoxFit.fill,
                                  child: Image.asset(
                                      ads[index].adImageUrl != null
                                          ? '${ads[index].adImageUrl}'
                                          : 'imgs/placeholder.jpg'),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      List: [
                                        Colors.black87,
                                        Colors.transparent
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.center,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(8, 0, 0, 8),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      '${ads[index].adContent}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: Text('No Ads'),
                          ),
                  );
                },
              );
            });
          }
        },
      ),
    );
  }
}
