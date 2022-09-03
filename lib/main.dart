import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:pie_chart/pie_chart.dart';

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
        backgroundColor: Colors.grey.shade100,
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 300,
                    padding: const EdgeInsets.only(top: 30),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 15,
                              offset: Offset(5, 5),
                            ),
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 1,
                              offset: Offset(-5, -5),
                            )
                          ]),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 30),
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
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: SnackBarPage(scanResult.rawContent),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (flag == 1 && isLoading == false)
                    Container(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: [
                          Container(
                            child: Text(
                              productName!,
                              style: GoogleFonts.poppins(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 3),
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                'Nutrition per ' +
                                    nutrimentsPerg.toString() +
                                    'g',
                                style: GoogleFonts.poppins(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),

                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Proteins = ' + proteins!.toString(),
                                  style: GoogleFonts.poppins(
                                      fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                              ),
                              Text(
                                'Carbohydrates = ' + carbohydrates!.toString(),
                                style: GoogleFonts.poppins(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Fats = ' + fats!.toString(),
                                style: GoogleFonts.poppins(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Others = ' + others!.toString(),
                                style: GoogleFonts.poppins(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          PieChart(
                            dataMap: {
                              "Proteins": proteins!,
                              "Carbohydrates": carbohydrates!,
                              "Fats": fats!,
                              "Others": others!,
                            },
                            colorList: [
                              Colors.redAccent,
                              Colors.yellowAccent,
                              Colors.blueAccent,
                              Colors.purpleAccent
                            ],
                            chartLegendSpacing: 8,
                            chartValuesOptions: ChartValuesOptions(
                              showChartValueBackground: false,
                              showChartValues: true,
                              showChartValuesInPercentage: true,
                              showChartValuesOutside: false,
                              decimalPlaces: 1,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (flag == 1 && isLoading == true)
                    CircularProgressIndicator()
                  else if (flag == 0)
                    Text('Macrobar has never tasted this food item!!')
                ],
              )
            else
              Container(
                height: 350,
                margin: EdgeInsets.only(
                  top: 100,
                  left: 25,
                  right: 25,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 15,
                        offset: Offset(5, 5),
                      ),
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 1,
                        offset: Offset(-5, -5),
                      )
                    ]),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                      bottom: 10,
                    ),
                    child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        TyperAnimatedText(
                            'Hello Foodie :)\nMy name is Macrobar tap on the camera icon in the top right corner to begin scanning your food!',
                            textStyle: GoogleFonts.kalam(
                              fontSize: 32,
                            ),
                            speed: Duration(milliseconds: 70))
                      ],
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  var flag = -1;
  bool isLoading = true;

  double? proteins, fats, carbohydrates, others, nutrimentsPerg;
  String? productName;

  Future<Product?> getProduct(var barcode) async {
    ProductQueryConfiguration configuration = ProductQueryConfiguration(barcode,
        language: OpenFoodFactsLanguage.ENGLISH, fields: [ProductField.ALL]);
    ProductResult result = await OpenFoodAPIClient.getProduct(configuration);

    if (result.status == 1 && result.product!.productName != null) {
      productName = result.product!.productName.toString();
      print('Result : ' + productName!);

      setState(
        () {
          flag = 1;
          nutrimentsPerg = double.parse(
            result.product!.nutrimentDataPer.toString().substring(
                0, result.product!.nutrimentDataPer.toString().length - 1),
          );
          proteins = result.product!.nutriments?.proteins!.roundToDouble();
          carbohydrates =
              result.product!.nutriments?.carbohydrates!.roundToDouble();
          fats = result.product!.nutriments?.fat!.roundToDouble();
          others = nutrimentsPerg! - (proteins! + carbohydrates! + fats!);

          if (nutrimentsPerg! / 100 != 1) {
            double mul = nutrimentsPerg! / 100;
            nutrimentsPerg = nutrimentsPerg! * mul;
            proteins = proteins! * mul;
            carbohydrates = carbohydrates! * mul;
            fats = fats! * mul;
            others = others! * mul;

            print('Proteins = ' + proteins.toString());
            print('Carbohydrates = ' + carbohydrates.toString());
            print('Fats = ' + fats.toString());
            print('Others = ' + others.toString());
          }
          print(nutrimentsPerg!);

          setState(() {
            isLoading = false;
          });
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
          Clipboard.setData(ClipboardData(text: barcode));
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
