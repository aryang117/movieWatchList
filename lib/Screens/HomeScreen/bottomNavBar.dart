import 'package:flutter/material.dart';

//3rd Party Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

//Screens
import '../Login/LoginScreen.dart';

// Implemented a quick bottomnavbar, allows you to sign out or clear all values [only if u're logged in]
BottomNavigationBar bottomNavigationBar(FirebaseAuth _firebaseAuth,
    BuildContext _context, Function _clearAllValues) {
  return BottomNavigationBar(
      selectedLabelStyle: GoogleFonts.poppins(),
      unselectedLabelStyle: GoogleFonts.poppins(),
      unselectedFontSize: 14.0,
      selectedFontSize: 16.0,
      items: [
        BottomNavigationBarItem(
            label: 'Clear',
            icon: IconButton(
                icon: Icon(Icons.clear_all_rounded),
                onPressed: () => _clearAllValues())),
        BottomNavigationBarItem(
            label: 'Sign Out',
            icon: IconButton(
                icon: Icon(Icons.logout_rounded),
                onPressed: () {
                  _firebaseAuth.signOut();

                  ScaffoldMessenger.of(_context).showSnackBar(
                      SnackBar(content: Text('Signed Out Successfully')));

                  Navigator.push(_context,
                      MaterialPageRoute(builder: (_context) => LoginScreen()));
                }))
      ]);
}
