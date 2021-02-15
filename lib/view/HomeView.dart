

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cricscore/Constants.dart';
import 'package:cricscore/controller/GoogleSignIn.dart';
import 'package:cricscore/controller/SharedPrefUtil.dart';
import 'package:cricscore/model/player.dart';
import 'package:cricscore/view/MatchSummary.dart';
import 'package:cricscore/view/ProfilePage.dart';
import 'package:cricscore/view/SelectTeam.dart';
import 'package:cricscore/widget/Loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'StartMatch.dart';

class HomeView extends StatefulWidget {

  @override
  _HomeView createState() => _HomeView();
}
final grayColor = const Color(0xFF939393);

class _HomeView extends State<HomeView> with TickerProviderStateMixin{

  final List<MyTabs> _tabs = [new MyTabs(title: "Matches in your city"),
    new MyTabs(title: Constant.PROFILE_APP_BAR_TITLE),
  ];

  MyTabs _myHandler ;
  TabController _controller ;
  final _textEditingController = new TextEditingController();
  bool loading = false;
  Player profile;

  void initState() {
    super.initState();
     profile = SharedPrefUtil.getPlayerObject(Constant.PROFILE_KEY);
    _textEditingController.text = profile.name;
    _controller = new TabController(length: 2, vsync: this);
    _myHandler = _tabs[0];
    _controller.addListener(_handleSelected);
  }
  void _handleSelected() {
    setState(() {
      _myHandler= _tabs[_currentIndex];
      loading = false;
    });
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      MatchSummaryList(),
//      Center(child: FlatButton(
//        onPressed: (){
//          Navigator.push(context, MaterialPageRoute(builder: (context) => MatchSummaryList()));
//        },
//        child: Text("Press"),
//      )),
      EditProfile(profileBodyType: ProfileBodyEnum.view, showAppBar: false,),
      //EditProfile()
    ];

    return (loading) ? Loading() : Scaffold(
      appBar: new AppBar(
        title: AutoSizeText(
          _myHandler.title,
          maxLines: 1,
          textAlign: TextAlign.start,
          style: TextStyle(
              fontSize: 18.0,
              fontFamily: "Lemonada"
          ),
        ),
      ),
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[

            Container(
              color : Constant.PRIMARY_COLOR,
              child: new UserAccountsDrawerHeader(
                accountName: ((profile.name) != null) ? AutoSizeText(
                  profile.name,
                  maxLines: 4,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 13.0,
                      fontFamily: "Lemonada"
                  ),
                ) : null,

                accountEmail: AutoSizeText(
                  profile.email,
                  maxLines: 4,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 13.0,
                      fontFamily: "Lemonada"
                  ),
                ),
                currentAccountPicture : new CircleAvatar(
                  backgroundImage: new NetworkImage((profile.photoUrl == null) ? 'lib/assets/images/default_profile_avatar.png' : profile.photoUrl),
                  backgroundColor: Colors.white,
                ),
              ),
            ),

            new ListTile(
              title: AutoSizeText(
                "Profile",
                maxLines: 4,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: "Lemonada"
                ),
              ),
              onTap: () async{
                try {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EditProfile(profileBodyType: ProfileBodyEnum.view, showAppBar: true,)));
                } catch (e) {
                  print(e);
                }
              },
            ),

            new ListTile(
              title: AutoSizeText(
                "Start Match",
                maxLines: 4,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: "Lemonada"
                ),
              ),
              onTap: () async{
                 try {
                   Navigator.of(context).pop();
                   Navigator.push(context,
                       MaterialPageRoute(builder: (context) => StartMatch()));
                       //MaterialPageRoute(builder: (context) => TeamSelect()));
                 } catch (e) {
                   print(e);
                 }
              },
            ),

            new ListTile(
              title: AutoSizeText(
                "Sign Out",
                maxLines: 4,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: "Lemonada"
                ),
              ),

              onTap: () async{
                try {
                  final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.logout();
                  print("Signed Out!");
                } catch (e) {
                  print(e);
                }
              },
            )
          ],
        ),
      ),
      body : tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,

          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: AutoSizeText(
                "Home",
                maxLines: 1,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 10.0,
                    fontFamily: "Lemonada"
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: AutoSizeText(
                "Profile",
                maxLines: 1,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 12.0,
                    fontFamily: "Lemonada"
                ),
              ),
            ),
//          BottomNavigationBarItem(
//              icon: Icon(Icons.person),
//              title: Text('Profile'),
//          ),
          ],
          onTap: (index){
            setState(() {
              _currentIndex = index; _myHandler= _tabs[_currentIndex];
            });
          }
      ),

    );
  }
}

class MyTabs {
  final String title;
  final Color color;
  MyTabs({this.title,this.color});
}
