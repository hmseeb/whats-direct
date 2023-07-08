import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whats_direct/utils/countires.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final FocusNode phoneNumberFocusNode = FocusNode();
  final FocusNode messageNode = FocusNode();
  String? selectedCountry;
  String countryCode = '';
  String phoneNumberType = '';
  final List<Map<String, dynamic>> countries = Countries.countries;
  bool phoneNumberError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl:
                    'https://cdn-icons-png.flaticon.com/512/124/124034.png',
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.3,
                placeholder: (context, url) => const SizedBox(),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  color: Colors.redAccent,
                ),
              ),
              const Text(
                'Enter phone number',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                "Enter the phone number you want to send a message to.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              DropdownButton<String>(
                value: selectedCountry,
                hint: const Text('Select your country'),
                onChanged: _onCountryChanged,
                underline: Container(
                  height: 2,
                  color: const Color(0xFF25D366),
                ),
                items: _buildCountryDropdownItems(),
              ),
              if (selectedCountry != null) ...[
                const SizedBox(height: 16),
                TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onTapOutside: (event) => phoneNumberFocusNode.unfocus(),
                  focusNode: phoneNumberFocusNode,
                  controller: phoneNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF25D366),
                      ),
                    ),
                    border: const OutlineInputBorder(),
                    labelText: 'Enter your phone',
                    labelStyle: const TextStyle(
                      color: Color(0xFF25D366),
                    ),
                    errorText: phoneNumberError ? 'Invalid phone number' : null,
                  ),
                  onSubmitted: _onPhoneNumberSubmitted,
                ),
                const SizedBox(height: 16),
                TextField(
                  focusNode: messageNode,
                  onTapOutside: (event) => messageNode.unfocus(),
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF25D366),
                      ),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Say Hello!',
                    hintText: 'Optional',
                    labelStyle: TextStyle(
                      color: Color(0xFF25D366),
                    ),
                  ),
                  controller: messageController,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _openWhatsApp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'Open With WhatsApp',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 200), // Extra space for demonstration
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildCountryDropdownItems() {
    return countries.map<DropdownMenuItem<String>>((country) {
      return DropdownMenuItem<String>(
        value: country['name'],
        child: Text(country['name']),
      );
    }).toList();
  }

  void _onCountryChanged(String? value) {
    setState(() {
      selectedCountry = value;
      countryCode = countries.firstWhere(
        (country) => country['name'] == value,
      )['code'];
      phoneNumberController.text = '+$countryCode ';
      phoneNumberFocusNode.requestFocus();
    });
  }

  void _onPhoneNumberSubmitted(String value) {
    setState(() {
      phoneNumberType = value;
    });
  }

  void _openWhatsApp() async {
    String phoneNumber = phoneNumberController.text.trim();
    String messageText = messageController.text.replaceAll(' ', '%20');
    if (_validatePhoneNumber(phoneNumber)) {
      String url = 'https://wa.me/$phoneNumber?text=$messageText';
      await launchWhatsAppUrl(url);
    } else {
      setState(() {
        phoneNumberError = true;
      });
    }
  }

  bool _validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty || phoneNumber.length < 10) {
      phoneNumberError = true;
      return false;
    }
    phoneNumberError = false;
    return true;
  }
}

Future<void> launchWhatsAppUrl(String url) async {
  Uri uri = Uri.parse(url);
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (e) {
    debugPrint(e.toString());
  }
}
