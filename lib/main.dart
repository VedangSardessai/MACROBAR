import 'dart:async';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

void main() => runApp(const App());

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  ScanResult? scanResult;
  Future<Product?>? gettingProd;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final scanResult = this.scanResult;
    final gettingProd = this.gettingProd;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            'MACROBAR',
            style: GoogleFonts.poppins(
              fontSize: 30,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 20.0),
              child: IconButton(
                icon: const Icon(
                  Icons.camera,
                  size: 40,
                ),
                tooltip: 'Scan',
                onPressed: _scan,
              ),
            )
          ],
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            if (scanResult != null)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                      ),
                      child: Column(
                        children: [
                          Container(
                            child: Text(
                              'Barcode Number',
                              style: GoogleFonts.poppins(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              scanResult.rawContent,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: SnackBarPage(scanResult.rawContent),
                          ),
                          if (flag == 1)
                            Column(
                              children: [
                                Text('Proteins = ' + proteins!.toString()),
                                Text('Carbohydrates = ' + carbohydrates!.toString()),
                                Text('Fats = ' + fats!.toString()),
                                Text('Others = ' + others!.toString()),
                                // Text('Sugars = ' + sugar!),
                              ],
                            )
                          else if (flag == 0)
                            Text('Macrobar has never tasted this food item!!')
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  var flag = -1;
  double? proteins, fats, carbohydrates, others;

  Future<Product?> getProduct(var barcode) async {
    ProductQueryConfiguration configuration = ProductQueryConfiguration(barcode,
        language: OpenFoodFactsLanguage.ENGLISH, fields: [ProductField.ALL]);
    ProductResult result = await OpenFoodAPIClient.getProduct(configuration);

    if (result.status == 1 && result.product!.productName != null) {
      print('Result : ' + result.product!.productName.toString());
      setState(
        () {
          flag = 1;
          double nutrimentsPerg = double.parse(
            result.product!.nutrimentDataPer.toString().substring(
                0, result.product!.nutrimentDataPer.toString().length - 1),
          );
          print(nutrimentsPerg);

          proteins = result.product!.nutriments?.proteins!.roundToDouble();
          print('Proteins = ' + proteins.toString());

          carbohydrates =
              result.product!.nutriments?.carbohydrates!.roundToDouble();
          print('Carbohydrates = ' + carbohydrates.toString());

          fats = result.product!.nutriments?.fat!.roundToDouble();
          print('Fats = ' + fats.toString());

          others = nutrimentsPerg - (proteins! + carbohydrates! + fats!);
          print(others);
        },
      );
      return result.product;
    } else {
      print('Macrobar has never tasted this food');
      setState(
        () {
          flag = 0;
        },
      );
      // throw Exception('product not found, please insert data for $barcode');
    }
  }

  Future<void> _scan() async {
    try {
      final result = await BarcodeScanner.scan();
      setState(
        () {
          scanResult = result;
          Future<Product?> resgettingProd = getProduct(scanResult!.rawContent);
          gettingProd = resgettingProd;
          print(scanResult!.rawContent.toString());
        },
      );
    } on PlatformException catch (e) {
      setState(
        () {
          scanResult = ScanResult(
            type: ResultType.Error,
            format: BarcodeFormat.unknown,
            rawContent: e.code == BarcodeScanner.cameraAccessDenied
                ? 'The user did not grant the camera permission!'
                : 'Unknown error: $e',
          );
        },
      );
    }
  }
}

class SnackBarPage extends StatelessWidget {
  var barcode = '';

  SnackBarPage(this.barcode, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        icon: const Icon(
          Icons.copy,
          size: 40,
        ),
        onPressed: () {
          final snackBar = SnackBar(
            content: Text('Barcode : ' + barcode + 'copied to clipboard'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      ),
    );
  }
}
