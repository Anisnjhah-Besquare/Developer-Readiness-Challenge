import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:web_socket_channel/io.dart';
import 'graph_page.dart';
import 'package:intl/intl.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  String textname = 'Stock Indices';
  bool changeColor = false;
  bool changeColor1 = true;
  bool changeColor2 = false;
  bool changeColor3 = false;
  bool changeColor4 = false;

  final channel = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  void getTickStream() {
    channel.sink.add('{"active_symbols": "full","product_type": "basic"}');
  }

  String query = '';
  @override
  void initState() {
    getTickStream();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var symbol;
    var symbolName;
    var state;

    TextEditingController selectedSymbol = new TextEditingController();

    List<String> MarketNames = [];

    List<SearchFieldListItem> list = [];
    return Scaffold(
      body: StreamBuilder(
          stream: channel.stream,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              var price = jsonDecode(snapshot.data);
              try {
                for (int i = 0; i <= 76; i++) {
                  if (price['active_symbols'][i]['exchange_is_open'] == 1) {
                    MarketNames.add(price['active_symbols'][i]['display_name']);
                  }
                }
                list = MarketNames.map((e) => SearchFieldListItem(e)).toList();
              } catch (e) {}
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF1F96B0),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                      ),
                    ),
                    height: 200,
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(5, 30, 5, 10),
                    child: Column(
                      children: [
                        SearchField(
                            //marginColor: Colors.purple,
                            controller: selectedSymbol,
                            suggestions: list,
                            suggestionState: Suggestion.expand,
                            maxSuggestionsInViewPort: 5,
                            hint: 'Search Currency Pairs',
                            searchStyle: TextStyle(
                              fontSize: 15,
                              color: Colors.black.withOpacity(0.8),
                            ),
                            searchInputDecoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,

                              // icon: Icon(Icons.search),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                            onTap: (selectedSymbol) {
                              for (int i = 0; i < list.length; i++) {
                                if (price['active_symbols'][i]
                                        ['display_name'] ==
                                    selectedSymbol.searchKey) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GraphScreen(
                                        symbolName: price['active_symbols'][i]
                                            ['display_name'],
                                        symbol: price['active_symbols'][i]
                                            ['symbol'],
                                        state: price['active_symbols'][i]
                                            ['exchange_is_open'],
                                        currency_symbol: price['active_symbols']
                                            [i]['quoted_currency_symbol'],
                                      ),
                                    ),
                                  );
                                }
                                ;
                              }
                              ;
                            }),
                        Container(
                          height: 50,
                          width: double.infinity,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Row(
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    shape: Border(
                                        bottom: BorderSide(
                                            color: changeColor
                                                ? Color.fromARGB(
                                                    255, 150, 0, 87)
                                                : Colors.transparent,
                                            width: 3.0)),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.black, // foreground

                                        // foreground
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          changeColor1 = false;
                                          changeColor2 = false;
                                          changeColor3 = false;
                                          changeColor4 = false;
                                          changeColor = !changeColor;
                                          textname = 'Forex';
                                        });
                                      },
                                      child: Text(
                                        'Forex',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    shape: Border(
                                        bottom: BorderSide(
                                            color: changeColor1
                                                ? Color.fromARGB(
                                                    255, 150, 0, 87)
                                                : Colors.transparent,
                                            width: 3.0)),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.black, // foreground

                                        // foreground
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          changeColor2 = false;
                                          changeColor = false;
                                          changeColor3 = false;
                                          changeColor4 = false;
                                          changeColor1 = !changeColor1;
                                          textname = 'Stock Indices';
                                        });
                                      },
                                      child: Text(
                                        'Stock Indices',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    shape: Border(
                                        bottom: BorderSide(
                                            color: changeColor2
                                                ? Color.fromARGB(
                                                    255, 150, 0, 87)
                                                : Colors.transparent,
                                            width: 3.0)),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.black, // foreground

                                        // foreground
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          changeColor1 = false;
                                          changeColor = false;
                                          changeColor3 = false;
                                          changeColor4 = false;
                                          changeColor2 = !changeColor2;
                                          textname = 'Commodities';
                                        });
                                      },
                                      child: Text(
                                        'Commodities',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    shape: Border(
                                        bottom: BorderSide(
                                            color: changeColor3
                                                ? Color.fromARGB(
                                                    255, 150, 0, 87)
                                                : Colors.transparent,
                                            width: 3.0)),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.black, // foreground

                                        // foreground
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          changeColor1 = false;
                                          changeColor = false;
                                          changeColor2 = false;
                                          changeColor4 = false;
                                          changeColor3 = !changeColor3;
                                          textname = 'Synthetic Indices';
                                        });
                                      },
                                      child: Text(
                                        'Synthetic Indices',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    shape: Border(
                                        bottom: BorderSide(
                                            color: changeColor4
                                                ? Color.fromARGB(
                                                    255, 150, 0, 87)
                                                : Colors.transparent,
                                            width: 3.0)),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.black, // foreground

                                        // foreground
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          changeColor1 = false;
                                          changeColor = false;
                                          changeColor3 = false;
                                          changeColor2 = false;

                                          changeColor4 = !changeColor4;
                                          textname = 'Cryptocurrencies';
                                        });
                                      },
                                      child: Text(
                                        'Cryptocurrencies',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Card(
                    elevation: 5,
                    color: Colors.amberAccent,
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(9)),
                    child: Container(
                      height: 60,
                      child: Center(
                        // child: ListTile(
                        //   visualDensity:
                        //       VisualDensity(horizontal: 0, vertical: -4),
                        //   horizontalTitleGap: 20.0,
                        //   leading: Text('Market Name' "         "),
                        //   trailing: Text(
                        //     'Display Name',
                        //     textAlign: TextAlign.center,
                        //   ),
                        //   title: Text(
                        //     '   Price'
                        //     " ",
                        //     textAlign: TextAlign.start,
                        //   ),
                        // ),

                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Market Name',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              Container(
                                color: Colors.white,
                                width: 0.2,
                                height: 22,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Price',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              Container(
                                color: Colors.white,
                                width: 0.2,
                                height: 22,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Display Name',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 60,
                      // padding: EdgeInsets.all(8),
                      child: ListView.builder(
                        padding: EdgeInsets.all(0),
                        itemCount: 78,
                        itemBuilder: (BuildContext context, int index) {
                          if (price['active_symbols'][index]
                                  ['market_display_name'] ==
                              textname) {
                            var formatPrice = NumberFormat.currency(
                                    customPattern: '##,###.0#')
                                .format(price['active_symbols'][index]['spot']);
                            return Card(
                              elevation: 5,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GraphScreen(
                                        symbolName: price['active_symbols']
                                            [index]['display_name'],
                                        symbol: price['active_symbols'][index]
                                            ['symbol'],
                                        state: price['active_symbols'][index]
                                            ['exchange_is_open'],
                                        currency_symbol: price['active_symbols']
                                            [index]['quoted_currency_symbol'],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: ListTile(
                                      visualDensity: VisualDensity(
                                          horizontal: 0, vertical: -4),
                                      horizontalTitleGap: 20.0,
                                      leading: Text(
                                          '${price['active_symbols'][index]['market_display_name']}'),
                                      trailing: Container(
                                        width: 70,
                                        child: Wrap(children: [
                                          Text(
                                            '${price['active_symbols'][index]['display_name']}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ]),
                                      ),
                                      title: Text(
                                        '${formatPrice} ${price['active_symbols'][index]['quoted_currency_symbol']} ',
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Container(
                                      color: Colors.white,
                                      width: 0.2,
                                      height: 80,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                            '${price['active_symbols'][index]['quoted_currency_symbol']}'
                                            " "
                                            '${price['active_symbols'][index]['spot']}'),
                                      ],
                                    ),
                                    Container(
                                      color: Colors.white,
                                      width: 0.2,
                                      height: 80,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          '${price['active_symbols'][index]['display_name']}',
                                        ),
                                      ],
                                    ),
                                    Container(
                                      color: Colors.white,
                                      width: 0.2,
                                      height: 80,
                                    ),
                                  ],
                                ),

                                // mainAxisAlignment:
                                //     MainAxisAlignment.center,
                              ),

                              // priceChangeEvaluator
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
