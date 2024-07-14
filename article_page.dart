import 'package:flutter/material.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const SizedBox(
        height: double.maxFinite,
        // color: const Color.fromARGB(189, 196, 236, 198),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Image(
                  image: AssetImage("assets/images/sucessStory.jpeg"),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '''Whoever said money brings happiness never heard of celebrity addicts. Drug and alcohol addiction is a common health issue and source of frequent news in Hollywood. And that doesn’t do much to inspire the youth, who look up to these stars for lifestyle inspiration. However, it’s good to read about the hopeful alcoholic success stories of many Hollywood celebs, too.
        
Despite having fame, power and money, lots of celebs turn towards drugs and alcohol for many reasons, from depression to just blatant recklessness. And this addiction to alcohol and drugs is very common amongst regular people, too. So let’s take a look at some famous recovering alcoholics and their sobriety stories from which we can all learn a thing or two.''',
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}