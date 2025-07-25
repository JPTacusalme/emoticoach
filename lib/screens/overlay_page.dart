import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'dart:developer';

class OverlayScreen extends StatefulWidget {
  const OverlayScreen({super.key});

  @override
  State<OverlayScreen> createState() => _OverlayScreenState();
}

class _OverlayScreenState extends State<OverlayScreen> {
  // Toggle states for each setting
  bool messagingOverlayEnabled = true;
  bool messageAnalysisEnabled = true;
  bool smartSuggestionsEnabled = false;
  bool toneAdjusterEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar mimic
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Messaging Coach",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Icon(Icons.info_outline, color: Colors.black54),
                ],
              ),
            ),
            // Tab Bar (fix overflow with Flexible and SingleChildScrollView)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  // Use no spaceBetween to avoid overflow
                  children: [
                    _buildTab("Today", selected: false),
                    SizedBox(width: 8),
                    _buildTab("Past Week", selected: true),
                    SizedBox(width: 8),
                    _buildTab("Past Month", selected: false),
                    SizedBox(width: 8),
                    _buildTab("All Time", selected: false),
                    SizedBox(width: 8),
                    _buildTab("View Graph", selected: false, outlined: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Stats Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _statColumn("47", "Messages Analyzed", kPrimaryBlue),
                      _statColumn("23", "Suggestions Used", kDailyChallengeRed),
                      _statColumn("12", "Rephrased Responses", kQuoteBlue),
                    ],
                  ),
                ),
              ),
            ),
            // Overlay Status
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: kPrimaryBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Overlay Status',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Enabled',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.flash_on, color: Colors.white, size: 28),
                  ],
                ),
              ),
            ),
            // Supported App
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Supported App",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.blue[100]!),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue[50],
                            radius: 20,
                            child: Icon(
                              Icons.telegram,
                              color: kPrimaryBlue,
                              size: 40,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text("Telegram"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Settings",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _settingsTile(
                    icon: Icons.search,
                    title: "Messaging Overlay",
                    subtitle: "Enable floating communication coach",
                    switchValue: messagingOverlayEnabled,
                    onChanged: (v) async {
                      if (v) {
                        final bool? res =
                            await FlutterOverlayWindow.requestPermission();
                        log("status: $res");
                        if (res == true) {
                          setState(() => messagingOverlayEnabled = true);
                        } else {
                          setState(() => messagingOverlayEnabled = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Permission denied for Messaging Overlay.',
                              ),
                            ),
                          );
                        }
                      } else {
                        setState(() => messagingOverlayEnabled = false);
                      }
                    },
                  ),
                  _settingsTile(
                    icon: Icons.insights,
                    title: "Message Analysis",
                    subtitle: "Detect tone, intent, & emotional cues",
                    switchValue: messageAnalysisEnabled,
                    onChanged: (v) =>
                        setState(() => messageAnalysisEnabled = v),
                  ),
                  _settingsTile(
                    icon: Icons.lightbulb_outline,
                    title: "Smart Suggestions",
                    subtitle: "Get response recommendations",
                    switchValue: smartSuggestionsEnabled,
                    onChanged: (v) =>
                        setState(() => smartSuggestionsEnabled = v),
                  ),
                  _settingsTile(
                    icon: Icons.tune,
                    title: "Tone Adjuster",
                    subtitle: "Fine-tune message tone with sliders",
                    switchValue: toneAdjusterEnabled,
                    onChanged: (v) => setState(() => toneAdjusterEnabled = v),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(
    String label, {
    bool selected = false,
    bool outlined = false,
  }) {
    if (outlined) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[400]!),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.normal,
            fontSize: 13,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: selected ? Colors.blue[100] : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? kPrimaryBlue : Colors.grey[700],
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _statColumn(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.black87, fontSize: 11),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool switchValue,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[100],
          child: Icon(icon, color: kPrimaryBlue),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 13)),
        trailing: Transform.scale(
          scale: 0.6,
          child: Switch(value: switchValue, onChanged: onChanged),
        ),
      ),
    );
  }
}
