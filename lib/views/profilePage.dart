import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: const AssetImage('assets/virat_user.png'),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              "Virat Kohli",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 16),
            ),
            Text(
              "@virat.use22",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                  fontSize: 12),
            ),
            const SizedBox(
              height: 20,
            ),
            const Card(
              elevation: 5.0,
              child: ListTile(
                tileColor: Colors.white,
                subtitle: Text("Date of Birth"),
                title: Text("5 November 1988"),
              ),
            ),
            const Card(
              elevation: 5.0,
              child: ListTile(
                tileColor: Colors.white,
                subtitle: Text("Email"),
                title: Text("virat****@gmail.com"),
              ),
            ),
            const Card(
              elevation: 5.0,
              child: ListTile(
                tileColor: Colors.white,
                subtitle: Text("Mobile"),
                title: Text("+91 898******"),
              ),
            ),
            Card(
              elevation: 5.0,
              child: ListTile(
                tileColor: Colors.white,
                title: const Text("Notifications"),
                trailing: Switch(value: false, onChanged: (v) {}),
              ),
            ),
            const Card(
              elevation: 5.0,
              child: ListTile(
                tileColor: Colors.white,
                title: Text("Logout"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
