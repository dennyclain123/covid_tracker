import 'package:covid_tracker/ob/covid_summary_ob.dart';
import 'package:covid_tracker/ob/responseob.dart';
import 'package:covid_tracker/pages/home_page/home_bloc.dart';
import 'package:covid_tracker/pages/search_page/search.dart';
import 'package:covid_tracker/utils/app_constants.dart';
import 'package:covid_tracker/widgets/covid_country_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _bloc = HomeBloc();
  var numberFormat = NumberFormat(",###");
  RefreshController _controller = RefreshController();
  @override
  void initState() {
    // TODO: implement initState
    _bloc.getCovidSummaryData();
    _bloc.getCovidSummaryStream().listen((ResponseOb resOb) {
      if(resOb.msgState==MsgState.data){
        _controller.refreshCompleted();
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: bgcolor,
        title: Text("Latest Covid News"),
        leading: Icon(Icons.coronavirus),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context){
                  return Search();
                }
              ));
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: StreamBuilder<ResponseOb>(
        initialData: ResponseOb(msgState: MsgState.loading),
        stream: _bloc.getCovidSummaryStream(),
        builder: (BuildContext context,AsyncSnapshot<ResponseOb> snapshot){
          ResponseOb resOb = snapshot.data;
          if(resOb.msgState==MsgState.data){
            CovidSummaryOb cob=resOb.data;
            return MainWidget(cob);
          }else if(resOb.msgState==MsgState.error){
            if(resOb.errState==ErrState.notFoundErr){
              return Text("404 Not Found");
            }else if(resOb.errState==ErrState.serverErr){
              return Text("500 Server Error");
            }else{
              return Text("Error, Something went Wrong");
            }
          }else{
            return Center(
              child: CircularProgressIndicator(color: Colors.white,),
            );
          }
        },
      ),
    );
  }
  Widget MainWidget(CovidSummaryOb cob){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: bgcolor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                //Date
                Text("Date: "+DateFormat().format(DateTime.parse(cob.date)),style: TextStyle(
                  color: Colors.indigoAccent,
                  fontSize: 14,
                ),),
                SizedBox(height: 10,),
                Row(
                  children: [
                    //Total Confirmed
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Total\nConfirmed",style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),),
                          SizedBox(height: 10,),
                          Text(numberFormat.format(cob.global.totalConfirmed),style: TextStyle(
                              color: Colors.indigoAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                          ),),
                          SizedBox(height: 10,),
                          RichText(
                            text: TextSpan(
                                text: "New: ",
                                style: TextStyle(
                                    color: Colors.grey
                                ),
                                children:[
                                  TextSpan(
                                      text: numberFormat.format(cob.global.newConfirmed),
                                      style: TextStyle(
                                          color: Colors.indigoAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15
                                      )
                                  )
                                ]
                            ),
                          )
                        ],
                      ),
                    ),
                    //Total Deaths
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Total\nDeaths",style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          ),),
                          SizedBox(height: 10,),
                          Text(numberFormat.format(cob.global.totalDeaths),style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          ),),
                          SizedBox(height: 10,),
                          RichText(
                            text: TextSpan(
                              text: "New: ",
                            style: TextStyle(
                              color: Colors.grey
                            ),
                            children:[
                                TextSpan(
                                  text: numberFormat.format(cob.global.newDeaths),
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15
                                  )
                                )
                              ]
                            ),
                          )
                        ],
                      ),
                    ),
                    //Total Recovered
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Total\nRecovered",style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          ),),
                          SizedBox(height: 5,),
                          Text(numberFormat.format(cob.global.totalRecovered),style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          ),),
                          SizedBox(height: 5,),
                          RichText(
                            text: TextSpan(
                              text: "New: ",
                            style: TextStyle(
                              color: Colors.grey
                            ),
                            children:[
                                TextSpan(
                                  text: numberFormat.format(cob.global.newRecovered),
                                  style: TextStyle(
                                    color: Colors.lightBlueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15
                                  )
                                )
                              ]
                            ),
                          )
                        ],
                      ),
                    )

                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10,top: 10,bottom: 5),
          child: Row(
            children: [
              Text("Countries",style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),),
              SizedBox(width: 10,),
              Image.network("https://image.flaticon.com/icons/png/128/2164/2164620.png",width: 20,height: 20,)
            ],
          ),
        ),
        Expanded(
          child: SmartRefresher(
            controller: _controller,
            enablePullDown: true,
            onRefresh: (){
              _bloc.getCovidSummaryData();
            },
            header: WaterDropMaterialHeader(backgroundColor: bgcolor,color: Colors.white,),
            child: ListView.builder(
              itemCount: cob.countries.length,
              itemBuilder: (context,index){
                return CountryWidget(cob.countries[index]);
              },
            ),
          ),
        )
      ],
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _bloc.dispose();
    super.dispose();
  }
}
