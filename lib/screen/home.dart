import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_avian/model/toko.dart';
import 'package:flutter_avian/model/totalHadiah.dart';
import 'package:http/http.dart' as http;

// late String namaToko;
// late String dummy;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late String dropDownNamaToko;
  late List<Map> listNamaToko = [
    {0: "Semua Toko"}
  ];
  String? namaToko;
  Map? selectedValue;
  String comboboxGagalTerimaValue = "Pilih Alasan";
  List<Toko> tokoListFilter = tokoList;
  String sudahTerima = "";
  late String custID;
  int totalHadiahValue = 0;
  @override
  void initState() {
    super.initState();
    bacaData();
    bacaDataTotalHadiah();
  }

  Future<String> fetchData(String param) async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/$param'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    tokoList.clear();
    listNamaToko.clear();
    listNamaToko = [
      {0: "Semua Toko"}
    ];
    Future<String> data = fetchData('tokoList');
    data.then((value) {
      int i = 1;
      Map json = jsonDecode(value);
      for (var mov in json['data']) {
        Toko toko = Toko.fromJson(mov);
        tokoList.add(toko);
        listNamaToko.add({i: toko.name});
        i++;
      }
      setState(() {
        // namaToko = listNamaToko[0];
      });
    });
  }

  bacaDataTotalHadiah() {
    totalHadiahList.clear();
    Future<String> data = fetchData('totalHadiah');
    data.then((value) {
      Map json = jsonDecode(value);
      for (var mov in json['data']) {
        TotalHadiah totalHadiah = TotalHadiah.fromJson(mov);
        totalHadiahList.add(totalHadiah);
      }
      setState(() {
        // namaToko = listNamaToko[0];
      });
    });
  }

  Widget comboboxGagalTerima() {
    return SizedBox(
      width: 300,
      child: DropdownButtonFormField(
          hint: const Text("Semua Toko"),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color.fromARGB(255, 0, 87, 121), width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Color.fromARGB(255, 0, 87, 121), width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color.fromARGB(255, 0, 87, 121), width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color.fromARGB(255, 0, 87, 121), width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color.fromARGB(255, 0, 87, 121), width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color.fromARGB(255, 0, 87, 121), width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          dropdownColor: Colors.white,
          value: comboboxGagalTerimaValue,
          onChanged: (String? newValue) {
            setState(() {
              comboboxGagalTerimaValue = newValue!;
            });
          },
          items: const [
            DropdownMenuItem(
              value: "Pilih Alasan",
              child: Text("Pilih Alasan"),
            ),
            DropdownMenuItem(
              value: "Toko Tutup",
              child: Text("Toko Tutup"),
            ),
            DropdownMenuItem(
              value: "Pemilik Toko Tidak Ada",
              child: Text("Pemilik Toko Tidak Ada"),
            ),
          ]),
    );
  }

  Future<String> sudahTerimaHadiah() async {
    var map = Map<String, dynamic>();
    map['sudahTerima'] = sudahTerima;
    map['custID'] = custID;
    map['failedReason'] = comboboxGagalTerimaValue;
    final response = await http.put(
      Uri.parse("http://127.0.0.1:8000/api/sudahTerimaHadiah/$custID"),
      // body: {'sudahTerima': sudahTerima, 'custID': custID, 'failedReason': comboboxGagalTerimaValue});
      body: map,
    );
    if (response.statusCode == 200) {
      bacaData();
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  Widget tokoListView() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final Toko toko = tokoListFilter[index];
        return InkWell(
          onTap: () {
            if (toko.received == 0) {
              custID = toko.custID;
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Sudah Terima TTH',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 200),
                        const Text(
                          'Yakin ingin menyimpan sudah terima TTH?',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.greenAccent,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(12)),
                              child: TextButton(
                                onPressed: () {
                                  sudahTerima = "belum";
                                  Navigator.pop(context);
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => Dialog(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          // dialog kedua mulai disini
                                          const Text('Gagal Terima TTH'),
                                          const SizedBox(height: 15),
                                          comboboxGagalTerima(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('BATAL'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    sudahTerimaHadiah();
                                                    Navigator.pop(context);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors
                                                                  .greenAccent),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: const Text(
                                                      'SIMPAN',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'TIDAK',
                                  style: TextStyle(color: Colors.greenAccent),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                sudahTerima = "sudah";
                                sudahTerimaHadiah();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.greenAccent),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: const Text(
                                  'YA, SUDAH TERIMA',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
          child: Card(
            color: const Color.fromARGB(255, 0, 87, 121),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        toko.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      if (toko.received == 0)
                        const Text(
                          "Belum Diberikan",
                          style: TextStyle(color: Colors.white),
                        )
                      else
                        const Text(
                          "Sudah Diberikan",
                          style: TextStyle(color: Colors.white),
                        )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_searching,
                            color: Colors.white,
                            size: 12,
                          ),
                          Text(
                            toko.address,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.phone,
                            color: Colors.white,
                            size: 12,
                          ),
                          Text(
                            toko.phoneNo,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 10,
                        right: 10,
                        bottom: 30,
                      ),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: toko.hadiahs.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return Container(
                                padding: const EdgeInsets.only(
                                    top: 5, bottom: 5, left: 15, right: 15),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 0, 150, 173),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.wallet_giftcard),
                                    const SizedBox(width: 10),
                                    Text(
                                      toko.hadiahs[index],
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ));
                            // return Text(toko.hadiahs[index]);
                          })),
                )

                // Expanded(
                //   flex: 1,
                //   child: Image.asset(place.imageAsset),
                // ),
                // Expanded(
                //   flex: 2,
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       mainAxisSize: MainAxisSize.min,
                //       children: <Widget>[
                //         Text(
                //           place.name,
                //           style: const TextStyle(fontSize: 16.0),
                //         ),
                //         const SizedBox(
                //           height: 10,
                //         ),
                //         Text(place.location),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
      itemCount: tokoListFilter.length,
    );
  }

  Widget namaTokoDropDown() {
    return SizedBox(
      width: 300,
      child: DropdownButtonFormField(
          hint: const Text("Semua Toko"),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          dropdownColor: Colors.white,
          value: selectedValue,
          onChanged: (Map? newValue) {
            setState(() {
              selectedValue = newValue!;
              int keys = int.parse(
                  (newValue.keys.toString().split("(")[1]).split(")")[0]);
              if (keys == 0) {
                tokoListFilter = tokoList;
              } else {
                int index = keys - 1;
                tokoListFilter = [];
                tokoListFilter.add(tokoList[index]);
              }
            });
          },
          items: listNamaToko.map<DropdownMenuItem<Map>>((Map map) {
            return DropdownMenuItem<Map>(
              value: map,
              child: Text((map.values.toString().split("(")[1]).split(")")[0]),
            );
          }).toList()),
    );
    // return DropdownButton<String>(
    //     items: listNamaToko.map<DropdownMenuItem<String>>((String value) {
    //     return DropdownMenuItem<String>(
    //       value: value,
    //       child: Text(value),
    //     );
    //   }).toList(),
    //     value: namaToko,
    //     hint: const Text('Select Nama Toko'),
    //     onChanged: (String? value) {
    //       setState(() {
    //         namaToko = value;
    //       });
    //     },
    //   );
    //   return DropdownMenu<String>(
    //   onSelected: (String? value) {
    //     // This is called when the user selects an item.
    //     setState(() {
    //       dropDownNamaToko = value!;
    //     });
    //   },

    //   dropdownMenuEntries: listNamaToko.map<DropdownMenuEntry<String>>((String value) {
    //     return DropdownMenuEntry<String>(
    //       value: value,
    //       label: value,
    //       leadingIcon: const Icon(Icons.home_filled),
    //     );
    //   }).toList(),
    //   initialSelection: listNamaToko.first,
    // );
  }

  Widget totalHadiahListView() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: totalHadiahList.length,
        itemBuilder: (BuildContext ctxt, int index) {
          // print(int.parse(totalHadiahList[index].qty));
          // totalHadiahValue += int.parse(totalHadiahList[index].qty);
          return Container(
              padding:
                  const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(Icons.card_giftcard),
                  const SizedBox(width: 10),
                  Text(
                    totalHadiahList[index].jenis,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    totalHadiahList[index].qty.toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                  Text(
                    totalHadiahList[index].unit,
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ));
          // return Text(toko.hadiahs[index]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Home')
      // ),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            namaTokoDropDown(),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton.icon(
              icon: const Icon(
                Icons.wallet_giftcard,
                size: 12,
              ),
              label: const Text("Total Hadiah"),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  backgroundColor: const Color.fromARGB(255, 255, 85, 0),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 12,
                  )),
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(left:20, top: 20),
                          child: Row(
                            children: [
                              Icon(
                                Icons.wallet_giftcard_rounded,
                                color: Color.fromARGB(255, 255, 85, 0),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text('Total Hadiah'),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          color: Color.fromARGB(255, 255, 180, 59),
                          thickness: 1,
                        ),
                        totalHadiahListView(),
                        const Divider(
                          color: Color.fromARGB(255, 255, 180, 59),
                          thickness: 1,
                        ),
                        // Text(
                        //   '${totalHadiahValue.toString()}',
                        //   // totalHadiahValue.toString(),
                        //   style: const TextStyle(
                        //     color: Colors.black
                        //   ),
                        // )
                      ],
                    ),
                  ),
                );
              },
            ),
          ]),
          tokoListView(),
        ]),
      ),
    );
  }
}

// class NamaTokoDropDown extends StatefulWidget {
//   const NamaTokoDropDown({Key? key}) : super (key: key);

//   @override
//   State<NamaTokoDropDown> createState() => _NamaTokoDropDownState();
// }

// class _NamaTokoDropDownState extends State<NamaTokoDropDown> {

//   @override
//   Widget build(BuildContext context) {
//     // return Text("masuk");
//     return DropdownMenu<String>(
//       initialSelection: tokoList.first.name,
//       onSelected: (String? value) {
//         // This is called when the user selects an item.
//         setState(() {
//           dropDownNamaToko = value!;
//         });
//       },
//       dropdownMenuEntries: listNamaToko.map<DropdownMenuEntry<String>>((String value) {
//         return DropdownMenuEntry<String>(
//           value: value,
//           label: value,
//           leadingIcon: const Icon(Icons.home_filled),
//         );
//       }).toList(),
//     );
//   }
// }
