import 'dart:convert';
import 'dart:io';
import 'package:cocoa_project/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProcessCocoa extends StatefulWidget {
  const ProcessCocoa({super.key, required this.image});
  final File image;

  @override
  State<ProcessCocoa> createState() => _ProcessCocoaState();
}

class _ProcessCocoaState extends State<ProcessCocoa> {
  Map<String, dynamic>? mlResponse;
  List<Map<String, dynamic>> diseaseColors = [
    {"swollen_shoot": "red"},
    {"cocoa_pod": "red"},
    {"healthy": "green"}
  ];

  bool isLoading = false;

  Future<void> runMLAlgorithmn() async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse("https://cocoa-project.onrender.com/predictions"),
    );
    final imageStream = http.ByteStream(widget.image.openRead());
    final length = await widget.image.length();

    final multipartFile =
        http.MultipartFile('file', imageStream, length, filename: 'image.jpg');

    request.files.add(multipartFile);
    final response = await request.send();
    if (response.statusCode == 200) {
      // Display
      final responseJson = await http.Response.fromStream(response);

      setState(() {
        mlResponse = jsonDecode(responseJson.body);
      });
      print(mlResponse);
    } else {
      //Show error
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actionsIconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true,
        title: const Text(
          "Run Algorithm",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18.0,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                child: Image.file(
                  widget.image,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              isLoading
                  ? const ProgressDialog(message: "Running ML")
                  : Card(
                      child: SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Cocoa Test",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              if (mlResponse != null)
                                Text(
                                  mlResponse!["Class"].toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: mlResponse!["Class"] != "healthy"
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                  "The infected young of both sexes and adult females can also spread the virus to adjacent healthy trees by crawling across interlocking branches.")
                            ],
                          ),
                        ),
                      ),
                    ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40)),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await runMLAlgorithmn();
                  setState(() {
                    isLoading = false;
                  });
                },
                child: const Text(
                  "Run Test",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
