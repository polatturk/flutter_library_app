import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, bottom: 30), 
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            child: const Column(
              children: [
                CircleAvatar(radius: 45, backgroundColor: Colors.white, child: Icon(Icons.person, size: 45)),
                SizedBox(height: 15),
                Text('Hoş Geldin! Kitapsever', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildOption(Icons.login, 'Giriş Yap'),
          _buildOption(Icons.settings, 'Ayarlar'),
        ],
      ),
    );
  }

  Widget _buildOption(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}