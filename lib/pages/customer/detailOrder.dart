import 'package:flutter/material.dart';

class DetailOrderPage extends StatefulWidget {
  static const String routeName = '/detailOrder';

  const DetailOrderPage({super.key});

  @override
  State<DetailOrderPage> createState() => _DetailOrderPageState();
}

class _DetailOrderPageState extends State<DetailOrderPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> tabBar = [Text('Data'), Text('Pengiriman')];

    return DefaultTabController(
      length: tabBar.length,
      child: Scaffold(
        backgroundColor: Color(0xFFECF0F1),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.height * 0.12,
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              'Detail Order',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            bottom: TabBar(
              tabs: tabBar,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: UnderlineTabIndicator(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFF1F3A93), width: 4),
                insets: EdgeInsets.symmetric(horizontal: 8),
              ),
              unselectedLabelStyle: TextStyle(
                color: Color(0xFFD9D9D9),
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
              ),
              labelColor: Colors.black,
              labelPadding: EdgeInsets.symmetric(vertical: 15),
              labelStyle: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text('Data')),
            Center(child: Text('Pengiriman')),
          ],
        ),
      ),
    );
  }
}
