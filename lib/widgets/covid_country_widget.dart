import 'package:covid_tracker/ob/covid_summary_ob.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class CountryWidget extends StatelessWidget {
  Countries country;
  CountryWidget(this.country);
  var numberFormat = NumberFormat(",###");

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            RichText(
              text: TextSpan(
                text: country.country+" . ",
                style: TextStyle(
                  color: Colors.indigoAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
                children: [
                  TextSpan(
                    text: country.newConfirmed.toString(),
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 15
                    )
                  ),
                  TextSpan(
                    text: "  New Cases",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15
                    )
                  ),
                ]
              ),
            ),
            Divider(color: Colors.white,),
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
                      SizedBox(height: 5,),
                      Text(numberFormat.format(country.totalConfirmed),style: TextStyle(
                          color: Colors.indigoAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),),
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
                      SizedBox(height: 5,),
                      Text(numberFormat.format(country.totalDeaths),style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),),
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
                      Text(numberFormat.format(country.totalRecovered),style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),),
                     ],
                  ),
                )

              ],
            ),
            Divider(color: Colors.white,),
            Text(DateFormat().format(DateTime.parse(country.date)),style: TextStyle(
                color: Colors.white,
              fontSize: 15
            ),)
          ],
        ),
      ),
    );
  }
}
