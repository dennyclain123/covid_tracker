import 'package:covid_tracker/ob/covid_country_ob.dart';
import 'package:covid_tracker/ob/responseob.dart';
import 'package:covid_tracker/pages/country_page/country.dart';
import 'package:covid_tracker/pages/search_page/search_bloc.dart';
import 'package:covid_tracker/utils/app_constants.dart';
import 'package:covid_tracker/widgets/search_date_range.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var _countryTec = TextEditingController();
  String dateRange = "Select Date Range";
  SearchBloc _bloc = SearchBloc();
  String fromDate;
  String toDate;
  var _scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: bgcolor,
        title: Text("Search Country"),
        actions: [
          Icon(
            Icons.flag_rounded,
            color: Colors.white,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return Country();
                })).then((value) {
                  if (value != null) {
                    // print(value);
                    _countryTec.text = value;
                  }
                });
              },
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: _countryTec,
                enabled: false,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintStyle: TextStyle(color: Colors.white60),
                  hintText: "Select Country",
                  filled: true,
                  fillColor: Colors.white30,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            OutlineButton(
              borderSide: BorderSide(color: Colors.indigoAccent),
              onPressed: () {
                showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020, 10),
                        lastDate: DateTime.now())
                    .then((value) {
                  if (value != null) {
                    fromDate = value.start.toString();
                    toDate = value.end.toString();
                    String firstDate = value.start.toString().split(" ")[0];
                    String endDate = value.end.toString().split(" ")[0];
                    setState(() {
                      dateRange = firstDate + " - " + endDate;
                    });
                  }
                });
              },
              child: Text(
                dateRange,
                style: TextStyle(color: Colors.indigoAccent, fontSize: 18),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            FlatButton.icon(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.indigo,
              onPressed: () {
                if (_countryTec.text.isEmpty) {
                  //error
                  _scaffoldkey.currentState.showSnackBar(SnackBar(
                    content: Text(
                      "Please Select the Country First!",
                      style: TextStyle(color: Colors.black),
                    ),
                    backgroundColor: Colors.white70,
                  ));
                  return;
                }
                if (fromDate == null || toDate == null) {
                  //error
                  _scaffoldkey.currentState.showSnackBar(SnackBar(
                    content: Text(
                      "You need to choose Date Range!",
                      style: TextStyle(color: Colors.black),
                    ),
                    backgroundColor: Colors.white70,
                  ));
                  return;
                }
                _bloc.getCovidCountry(_countryTec.text, fromDate, toDate);
              },
              label: Text(
                "Search",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: StreamBuilder<ResponseOb>(
                // initialData: ResponseOb(),
                stream: _bloc.getSearchStream(),
                builder:
                    (BuildContext context, AsyncSnapshot<ResponseOb> snapshot){
                  if (snapshot.hasData) {
                    ResponseOb resOb = snapshot.data;
                    if (resOb.msgState == MsgState.loading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    } else if (resOb.msgState == MsgState.data) {
                      List<CovidCountryOb> ccList = resOb.data;
                      return MainWidget(ccList);
                    } else {
                      if (resOb.errState == ErrState.notFoundErr) {
                        return Text("404 Not Found");
                      } else if (resOb.errState == ErrState.serverErr) {
                        return Text("500 Server Error");
                      } else {
                        return Text("Error, Something went Wrong");
                      }
                    }
                  }
                  else{
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.indigo,
                          size: 50,
                        ),
                        Text(
                          "You can Search Data with country and date",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    );
                    }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget MainWidget(List<CovidCountryOb> ccList) {
    return ccList.length==0?
        Center(
          child: Text("Empty Data",style: TextStyle(
            color: Colors.white,
            fontSize: 18
          ),),
        ):
      ListView.builder(
      itemCount: ccList.length,
      itemBuilder: (context, index) {
        return SearchDateRange(ccList[index]);
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _bloc.dispose();
    super.dispose();
  }
}
