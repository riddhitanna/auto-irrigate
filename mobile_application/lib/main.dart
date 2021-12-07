import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_auto_irrigation/graph_helper.dart';
import 'package:iot_auto_irrigation/network_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int threshold = 10;
  String FEED_URL = "https://api.thingspeak.com/channels/1586440/feeds.json?api_key=";
  String THRESHOLD_URL = "https://api.thingspeak.com/channels/1586440/fields/2/last.json?api_key=";
  String UPDATE_URL = "https://api.thingspeak.com/update?api_key=";
  String READ_API = "EC38J4J9KV9WB6UI";
  String WRITE_API = "EY7I02KD8SQ3RX0S";
  TextEditingController readKey_controller = TextEditingController();
  TextEditingController writeKey_controller = TextEditingController();
  Stopwatch stopwatch = Stopwatch();

  List moistureData = List.empty(growable: true);

  Future<void> getMoistureData() async {
    moistureData = await NetworkHelper.getMoistureData(FEED_URL, READ_API);
    setState(() {});
  }

  Future<void> getCurrentThreshold() async {
    threshold = await NetworkHelper.getCurrentThreshold(THRESHOLD_URL, READ_API);
  }

  @override
  void initState() {
    super.initState();
    getMoistureData();
    getCurrentThreshold();
    readKey_controller.text = READ_API;
    writeKey_controller.text = WRITE_API;
  }

  @override
  Widget build(BuildContext context) {

    NetworkHelper.getCurrentThreshold(THRESHOLD_URL, READ_API);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: const Icon(
                Icons.add_link,
                size: 30,
              ),
              onPressed: () {
                showDialog<String>(
                context: context,
                    builder: (BuildContext context) =>
                        AlertDialog(
                            title: const Text(
                                'Enter API Keys',
                              style: TextStyle(
                                fontSize: 21,
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: const Color(0xff1c2a40),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Read Key',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white
                                  ),
                                ),
                                readKeyTextField(),
                                const SizedBox(height: 25),
                                const Text(
                                  'Write Key',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white
                                  ),
                                ),
                                writeKeyTextField()
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                child: const Text(
                                    'Cancel',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: (){
                                  READ_API = readKey_controller.text;
                                  WRITE_API = writeKey_controller.text;
                                  Navigator.pop(context, 'OK');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Read Key: " + readKey_controller.text + "\nWrite Key: " + writeKey_controller.text,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                        backgroundColor: Colors.lightBlue,
                                      )
                                  );
                                },
                                child: const Text(
                                  'Done',
                                  style: TextStyle(
                                    fontSize: 18
                                  ),
                                ),
                              )
                            ],
                ),
                );
              }
            )
          )
        ],
        title: const Text(
          'Auto Irrigation Remote',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: const Color(0xff1c2a40),
      body: SafeArea(
        child: MediaQuery.of(context).size.shortestSide < 600 ? mobileBody() : desktopBody(),
      ),
    );
  }

  Widget readKeyTextField(){
    return TextField(
      controller: readKey_controller,
      decoration: const InputDecoration(
        hintText: "Read Key",
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white60),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        hintStyle: TextStyle(
            fontSize: 18,
            color: Colors.white60
        ),
      ),
      style: const TextStyle(
        fontSize: 20,
        color: Colors.grey,
      ),
    );
  }

  Widget writeKeyTextField(){
    return TextField(
      controller: writeKey_controller,
      decoration: const InputDecoration(
        hintText: "Write Key",
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white60),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        hintStyle: TextStyle(
            fontSize: 18,
            color: Colors.white60
        ),
      ),
      style: const TextStyle(
        fontSize: 20,
        color: Colors.grey,
      ),
    );
  }

  Widget desktopBody(){
    return Center(
      child: Container(
        color: Colors.black45,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 25),
            Expanded(
                flex: 2,
                child: Container(child: moistureGraph())
            ),
            const SizedBox(width: 40),
            SizedBox(width: 2, child: Container(color: Colors.grey)),
            SizedBox(width: 40, child: Container(color: Colors.black54)),
            Expanded(
                flex: 1,
                child: Container(
                  color: Colors.black54,
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    irrigationStartButton(),
                    const SizedBox(height: 30),
                    thresholdRow(),
                    const SizedBox(height: 30),
                    irrigationStopButton(),
                  ],
              ),
                )
            ),
            SizedBox(width: 40, child: Container(color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget mobileBody(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        moistureGraph(),
        const SizedBox(height: 100),
        thresholdRow(),
        const SizedBox(height: 150),
        irrigationStartButton(),
        const SizedBox(height: 30),
        irrigationStopButton(),
        SizedBox(height: 25)
      ],
    );
  }

  Widget thresholdRow(){

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        // Threshold Increment IconButton
        InkWell(
          onTap: () async {
              if (threshold < 100) {
                bool isUpdated = await NetworkHelper.updateThreshold(UPDATE_URL, WRITE_API, threshold + 10);
                if(isUpdated){
                  threshold = threshold + 10;
                  stopwatch.reset();
                  stopwatch.start();
                  setState(() {});
                } else {
                  showScaffold('Wait for ' + (15 - stopwatch.elapsedMilliseconds/1000).toInt().toString() + ' more seconds');
                }
              }
              else {
                showScaffold("Threshold cannot be more than 100%");
              }
            },
          radius: 20,
          child: const Icon(
            Icons.add,
            size: 42,
            color: Colors.white,
          ),
        ),

        // Text Widget to Display Current Threshold
        Text(
          threshold.toString() + " %",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
          ),
        ),

        // Threshold Decrement IconButton
        InkWell(
          onTap: () async {
              if (threshold > 11) {
                bool isUpdated = await NetworkHelper.updateThreshold(UPDATE_URL, WRITE_API, threshold - 10);
                if(isUpdated){
                  threshold = threshold - 10;
                  stopwatch.reset();
                  stopwatch.start();
                  setState(() {});
                } else {
                  showScaffold('Wait for ' + (15 - stopwatch.elapsedMilliseconds/1000).toInt().toString() + ' more seconds');
                }
              }
              else {
                showScaffold('Threshold cannot be less than 10%');
              }
            },
          radius: 20,
          child: const Icon(
            Icons.remove,
            size: 42,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget irrigationStartButton(){

    return SizedBox(
      height: 40,
      width: MediaQuery.of(context).size.width * 0.7,
      child: ElevatedButton(
          child: const Text(
            "Force Start Pump",
            style: TextStyle(
              fontSize: 19,
              color: Colors.white,
            ),
          ),
        onPressed: () async {
          bool isUpdated = await NetworkHelper.updateThreshold(UPDATE_URL, WRITE_API, 100);
           if(isUpdated){
             threshold = 100;
             stopwatch.reset();
             stopwatch.start();
             setState(() {});
           } else {
             showScaffold('Wait for ' + (15 - stopwatch.elapsedMilliseconds/1000).toInt().toString() + ' more seconds');
           }
        },
      ),
    );
  }

  Widget irrigationStopButton(){

    return SizedBox(
      height: 40,
      width: MediaQuery.of(context).size.width * 0.7,
      child: ElevatedButton(
        child: const Text(
          "Force Stop Pump",
          style: TextStyle(
            fontSize: 19,
            color: Colors.white,
          ),
        ),
        onPressed: () async {
          bool isUpdated = await NetworkHelper.updateThreshold(UPDATE_URL, WRITE_API, 0);
          if(isUpdated){
            threshold = 0;
            stopwatch.reset();
            stopwatch.start();
            setState(() {});
          } else {
            showScaffold('Wait for ' + (15 - stopwatch.elapsedMilliseconds/1000).toInt().toString() + ' more seconds');
          }
        },
      ),
    );
  }

  void showScaffold(text){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              text,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ))
    );
  }

  Widget moistureGraph() {
    if (moistureData.isEmpty){
      return const SizedBox(height: 0);
    }
    else {
      return MediaQuery.of(context).size.shortestSide < 600 ?
          GraphHelper.moistureGraph(moistureData)
          : GraphHelper.moistureGraphWeb(moistureData);
    }
  }
}