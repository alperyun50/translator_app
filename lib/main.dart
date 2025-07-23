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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isModelDownloaded();

    onDeviceTranslator = OnDeviceTranslator(sourceLanguage: TranslateLanguage.english, targetLanguage: TranslateLanguage.turkish);
  }

  isModelDownloaded() async {
    bool isSourceDownloaded = await modelManager.isModelDownloaded(TranslateLanguage.english.bcpCode);
    bool isTargetDownloaded = await modelManager.isModelDownloaded(TranslateLanguage.turkish.bcpCode);
    if(isTargetDownloaded && isSourceDownloaded){
      isTranslatorReady = true;
    }
    else{
      if(isSourceDownloaded == false){
        isSourceDownloaded = await modelManager.downloadModel(TranslateLanguage.english.bcpCode);
      }
      if(isTargetDownloaded == false){
        isTargetDownloaded = await modelManager.downloadModel(TranslateLanguage.turkish.bcpCode);
      }
      if(isTargetDownloaded && isSourceDownloaded){
        isTranslatorReady = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
       
        title: Text("Translator"), centerTitle: true,
      ),
      body: Center(
        
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextField(decoration: InputDecoration(hintText: "enter your text"),),
            ElevatedButton(onPressed: (){}, child: Text("translate")),
            Text("Translated text.."),
          ],
        ),
      ),
    );
  }
}
