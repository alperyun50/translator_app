import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Translate App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Translator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late OnDeviceTranslator onDeviceTranslator;
  final modelManager = OnDeviceTranslatorModelManager();
  bool isTranslatorReady = false;
  TextEditingController inputCon = TextEditingController();
  var resultText = "translated text";
  TranslateLanguage sourceLang = TranslateLanguage.turkish;
  TranslateLanguage targetLang = TranslateLanguage.english;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isModelDownloaded();

    onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: sourceLang,
      targetLanguage: targetLang,
    );
  }

  isModelDownloaded() async {
    bool isSourceDownloaded = await modelManager.isModelDownloaded(
      targetLang.bcpCode,
    );
    bool isTargetDownloaded = await modelManager.isModelDownloaded(
      sourceLang.bcpCode,
    );
    if (isTargetDownloaded && isSourceDownloaded) {
      isTranslatorReady = true;
    } else {
      if (isSourceDownloaded == false) {
        isSourceDownloaded = await modelManager.downloadModel(
          targetLang.bcpCode,
        );
      }
      if (isTargetDownloaded == false) {
        isTargetDownloaded = await modelManager.downloadModel(
          sourceLang.bcpCode,
        );
      }
      if (isTargetDownloaded && isSourceDownloaded) {
        isTranslatorReady = true;
      }
    }
  }

  performTranslation() async {
    if (isTranslatorReady) {
      resultText = await onDeviceTranslator.translateText(inputCon.text);
      setState(() {
        resultText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.black,

        title: Text("Translator", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      style: TextStyle(fontSize: 25),
                      decoration: InputDecoration(
                        hintText: "enter your text",
                        border: InputBorder.none,
                        hintStyle: TextStyle(fontSize: 25),
                      ),
                      controller: inputCon,
                      onChanged: (text) {
                        performTranslation();
                      },
                    ),
                  ),
                ),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     performTranslation();
              //   },
              //   child: Text("translate"),
              // ),
              Expanded(
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width,
                    child: Text(resultText, style: TextStyle(fontSize: 25),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
