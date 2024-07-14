import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:nijaat_app/routes/routes.dart';

class MyDrawer extends StatelessWidget {
  final String? profile;
  final String email;
  const MyDrawer({super.key, required this.email, required this.profile});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHead(
            email: email,
            profile: profile,
          ),
          const SizedBox(
            height: 30,
          ),
          ListItem(
            title: "My activities",
            icon: FontAwesomeIcons.clipboard,
            ontap: () => Navigator.pushNamed(context, AppRoutes.myRecords),
          ),
          ListItem(
            title: "About us",
            icon: FontAwesomeIcons.circleInfo,
            ontap: () => Navigator.pushNamed(context, AppRoutes.aboutUS),
          ),
          ListItem(
            title: "Contact us",
            icon: FontAwesomeIcons.phone,
            ontap: () => Navigator.pushNamed(context, AppRoutes.aiPage),
          ),
          const Divider(
            thickness: 1,
            color: Colors.black45,
            indent: 20,
            endIndent: 40,
          ),
          ListItem(
            title: "Invite your friend",
            icon: FontAwesomeIcons.userPlus,
            ontap: () => Navigator.pushNamed(context, AppRoutes.myRecords),
          ),
          ListItem(
            title: "Rate us",
            icon: FontAwesomeIcons.solidStar,
            ontap: () => Navigator.pushNamed(context, AppRoutes.myRecords),
          ),
          ListItem(
            title: "Log out",
            icon: Icons.logout,
            ontap: () async {
              if (FirebaseAuth
                  .instance.currentUser!.providerData[0].providerId ==
                  'google.com') {
                await GoogleSignIn().disconnect();
              }
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}

class DrawerHead extends StatelessWidget {
  final String? profile;
  final String email;
  const DrawerHead({super.key, required this.email, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      color: const Color.fromARGB(255, 109, 158, 53),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          profile == null
              ? CircleAvatar(
            radius: 50,
            backgroundImage:
            const AssetImage("assets/images/profile.png"),
            backgroundColor: Theme.of(context).primaryColor,
          )
              : CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(profile!),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            email,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 20,
                color: Colors.white60,
                overflow: TextOverflow.fade),
          ),
        ],
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function() ontap;
  const ListItem(
      {required this.title,
        required this.icon,
        required this.ontap,
        super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          color: title == 'Log out' ? Colors.red : Colors.black45,
        ),
      ),
      leading: Icon(
        icon,
        size: 18,
        color: title == 'Log out' ? Colors.red : Colors.black45,
      ),
      onTap: () {
        Navigator.pop(context);
        ontap();
      },
    );
  }
}