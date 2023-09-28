import 'package:fireapp/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('LogOut'),
              onTap: () {
                ref.read(authProvider.notifier).userLogOut();
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Social App'),
      ),
    );
  }
}
