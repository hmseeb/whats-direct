import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whats_direct/views/home_page.dart';

void main() => runApp(const WhatsappDirect());

class WhatsappDirect extends StatefulWidget {
  const WhatsappDirect({super.key});
  static const String _title = 'Whatsapp Direct';
  @override
  State<WhatsappDirect> createState() => _MyAppState();
}

class _MyAppState extends State<WhatsappDirect> {
  bool isDarkMode = true;
  @override
  Widget build(BuildContext context) {
    Color darkBackground = const Color(0xFF121212);
    Color lightBackground = const Color(0xFFF2F2F2);

    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFF25D366),
        useMaterial3: true,
        fontFamily: 'Poppins',
        // textTheme: TextTheme(
        //   bodyMedium: TextStyle(
        //     color: isDarkMode ? darkText : lightText,
        //   ),
        // ),
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: isDarkMode ? darkBackground : lightBackground,
        appBarTheme: AppBarTheme(
          scrolledUnderElevation: 0,
          backgroundColor: isDarkMode ? darkBackground : lightBackground,
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: WhatsappDirect._title,
      home: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const IconButton(
                    icon: Icon(Icons.code),
                    onPressed: _openGitHub,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isDarkMode = !isDarkMode;
                      });
                    },
                    icon: isDarkMode
                        ? const Icon(Icons.brightness_6_outlined)
                        : const Icon(
                            Icons.brightness_6,
                            color: Color(0xFF121212),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: const HomePage(),
      ),
    );
  }
}

void _openGitHub() async {
  const githubUrl = 'https://github.com/hmseeb';
  await launchUrl(Uri.parse(githubUrl), mode: LaunchMode.externalApplication);
}
