import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CuteSurprisePage(),
    );
  }
}

class CuteSurprisePage extends StatefulWidget {
  const CuteSurprisePage({super.key});

  @override
  State<CuteSurprisePage> createState() => _CuteSurprisePageState();
}

class _CuteSurprisePageState extends State<CuteSurprisePage>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  double scale = 1.0;
  final AudioPlayer player = AudioPlayer();
  late ConfettiController _confettiController;

  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 3));
  }

  @override
  void dispose() {
    player.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> openPacket() async {
    await player.play(AssetSource("audio/wow.mp3"));
    setState(() {
      scale = 2;
    });
    await Future.delayed(Duration(milliseconds: 200));

    setState(() {
      scale = 0;
      isOpened = true;
    });
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFDEE9), Color(0xFFB5FFFC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: -pi / 2,
              emissionFrequency: 0.05,
              numberOfParticles: 100,
              gravity: 0.2,
              shouldLoop: false,
            ),
          ),
          isOpened ? ingredientsView() : packetView(),
        ],
      ),
    );
  }

  Widget packetView() {
    return GestureDetector(
      onTap: openPacket,
      child: AnimatedScale(
        scale: scale,
        duration: Duration(milliseconds: 300),
        curve: Curves.elasticOut,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage("assets/images/packet.jpg"), width: 220),
            SizedBox(height: 20),
            Text(
              "Tap Me!",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            Text("New Text"),
          ],
        ),
      ),
    );
  }

  Widget ingredientsView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Suprise",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32,
            color: Colors.deepPurple,
          ),
        ),
        SizedBox(height: 30),
        ingredientsCard("WFP", "assets/images/wfp.png", Colors.pink.shade500),
        ingredientsCard(
          "Flutter",
          "assets/images/download.png",
          Colors.blue.shade500,
        ),
        ingredientsCard(
          "Portrait",
          "assets/images/photo.avif",
          Colors.orange.shade500,
        ),
      ],
    );
  }

  Widget ingredientsCard(String name, String image, Color color) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(image, width: 50),
          SizedBox(width: 20),
          Text(
            name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
