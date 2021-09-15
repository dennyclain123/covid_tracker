import 'package:covid_tracker/ob/covid_country_ob.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class SearchDateRange extends StatelessWidget {
CovidCountryOb ccOb;
SearchDateRange(this.ccOb);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      color: Colors.black87,
      child: Column(
        children: [
          SizedBox(height: 5,),
          Text(ccOb.country,style: TextStyle(
            color: Colors.white,
            fontSize: 18
          ),),
          SizedBox(height: 5,),
          Text(DateFormat("EEEE, MMMM, dd yyyy").format(DateTime.parse(ccOb.date)).toString(),style: TextStyle(
              color: Colors.white,
              fontSize: 15
          ),),
          Row(
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      Text("Confirmed",style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                      ),),
                      SizedBox(
                        height: 5,
                      ),
                      Text(ccOb.confirmed.toString(),style: TextStyle(
                          color: Colors.blue[900],
                          fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),)
                    ],
                  ),
                  color: Colors.blue.shade200,
                  padding: EdgeInsets.all(10),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      Text("Active",style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                      ),),
                      SizedBox(
                        height: 5,
                      ),
                      Text(ccOb.active.toString(),style: TextStyle(
                          color: Colors.amber[900],
                          fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),)
                    ],
                  ),
                  color: Colors.amber.shade200,
                  padding: EdgeInsets.all(10),
                ),
              ),

            ],
          ),
           Row(
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      Text("Recovered",style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        fontWeight: FontWeight.bold
                      ),),
                      SizedBox(
                        height: 5,
                      ),
                      Text(ccOb.recovered.toString(),style: TextStyle(
                          color: Colors.green[900],
                          fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),)
                    ],
                  ),
                  color: Colors.green.shade200,
                  padding: EdgeInsets.all(10),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      Text("Deaths",style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        fontWeight: FontWeight.bold
                      ),),
                      SizedBox(
                        height: 5,
                      ),
                      Text(ccOb.deaths.toString(),style: TextStyle(
                          color: Colors.red[900],
                          fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),)
                    ],
                  ),
                  color: Colors.red.shade200,
                  padding: EdgeInsets.all(10),
                ),
              ),

            ],
          ),

        ],
      ),
    );
  }
}
