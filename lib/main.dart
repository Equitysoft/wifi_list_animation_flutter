
import 'package:fluttertoast/fluttertoast.dart';
import 'package:demo_project_wifi/wifi_list_model.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  List<WifiListModel> wifiList = [
    WifiListModel(icons: Icons.wifi_lock, wifiName: "XYZ-WLAN",onTap: true),
    WifiListModel(icons: Icons.wifi_lock, wifiName: "Workspace-WLAN",onTap: true),
    WifiListModel(icons: Icons.network_wifi_1_bar_rounded, wifiName: "Fritzbox12345",onTap: false),
    WifiListModel(icons: Icons.network_wifi_sharp, wifiName: "Jonas-WLAN",onTap: false),
    WifiListModel(icons: Icons.wifi_lock, wifiName: "jack-LAN",onTap: false),
    WifiListModel(icons: Icons.network_wifi_3_bar, wifiName: "iBelieveWlan",onTap: false),
  ];



  void showPasswordDialog(String wifiName) {
    bool _isObscure = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text("Verbinden mit $wifiName"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Bitte geben Sie das WLAN-Passwort ein.",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Passwort",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setDialogState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    passwordController.clear();
                    Fluttertoast.showToast(
                        msg: "Success",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                    Navigator.pop(context); // Close dialog
                  },
                  child: const Text("Verbinden"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void shuffleList() {
    final List<WifiListModel> oldList = List.from(wifiList);

    setState(() {
      wifiList.shuffle();
    });

    for (int i = 0; i < wifiList.length; i++) {
      if (oldList[i] != wifiList[i]) {
        _listKey.currentState?.removeItem(
          i,
              (context, animation) => _buildAnimatedItem(oldList[i], animation, isRemoving: true),
          duration: const Duration(milliseconds: 300),
        );

        _listKey.currentState?.insertItem(
          wifiList.indexOf(oldList[i]),
          duration: const Duration(milliseconds: 300),
        );
      }
    }
  }

  Widget _buildAnimatedItem(WifiListModel data, Animation<double> animation, {bool isRemoving = false}) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(
                data.icons,
                color: isRemoving ? Colors.transparent : Colors.black.withOpacity(0.80),
                size: 30,
              ),
              const SizedBox(width: 8),
              Text(
                data.wifiName,
                style: TextStyle(
                  fontSize: 25,
                  color: isRemoving ? Colors.transparent : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Demoprojekt"),
      ),
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left-side Image
            Expanded(
              flex: 1,
              child: Padding(

                padding: const EdgeInsets.only(left: 5.0),
                child: Image.asset(
                  "assets/images/image_lumos2.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                height: 600,
                child: VerticalDivider(
                  thickness: 2,
                  color: Colors.black,
                ),
              ),
            ),

            // Right-side Column with Texts
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Willkommen",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Lass uns beginnen, indem wir uns mit einem WLAN verbinden.",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 32),

                  // Constrained height for the AnimatedList
                  SizedBox(
                    height: 300, // Adjust this value as needed
                    child: AnimatedList(
                      key: _listKey,
                      initialItemCount: wifiList.length,
                      itemBuilder: (context, index, animation) {
                        var data = wifiList[index];
                        return GestureDetector(
                          onTap: () {
                            if(data.onTap) {
                              showPasswordDialog(data.wifiName);
                            }
                          },
                          child: _buildAnimatedItem(data, animation),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 25),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: shuffleList,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Neu Laden",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


