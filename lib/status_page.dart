import 'package:fireapp/view/auth_page.dart';
import 'package:fireapp/view/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStream = StreamProvider.autoDispose(
    (ref) => FirebaseAuth.instance.authStateChanges());

class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final authData = ref.watch(authStream);
        return authData.when(
            data: (data) {
              if (data == null) {
                return AuthPage();
              } else {
                return HomePage();
              }
            },
            error: (error, stack) => Center(child: Text('$error')),
            loading: () => Center(child: CircularProgressIndicator()));
      },
    );
  }
}
