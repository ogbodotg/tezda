import 'package:flutter/material.dart';
import 'package:tezda/auth/widgets/sign_in.dart';
import 'package:tezda/auth/widgets/sign_up.dart';
import 'package:tezda/services/services.dart';
import 'package:tezda/theme/colour.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Services services = Services();

    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: const [
                Tab(text: 'Login'),
                Tab(text: 'Register'),
              ],
              indicatorColor: AppColour.primary,
              labelColor: AppColour.black,
              unselectedLabelColor: AppColour.grey,
            ),
            title: services.logo2(80.0, 80.0),
          ),
          body: const TabBarView(
            children: [
              SignIn(),
              SignUp(),
            ],
          ),
        ),
      ),
    );
  }
}
