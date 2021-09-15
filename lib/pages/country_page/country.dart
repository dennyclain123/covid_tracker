import 'package:covid_tracker/ob/country_ob.dart';
import 'package:covid_tracker/ob/responseob.dart';
import 'package:covid_tracker/pages/country_page/country_bloc.dart';
import 'package:covid_tracker/utils/app_constants.dart';
import 'package:flutter/material.dart';
class Country extends StatefulWidget {

  @override
  _CountryState createState() => _CountryState();
}

class _CountryState extends State<Country> {
  final _bloc = CountryBloc();
  var _searchTec = TextEditingController();
  List<CountryOb> cList;
  List<CountryOb> filterList;
  @override
  void initState() {
    // TODO: implement initState
    _bloc.getCountryData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: bgcolor,
        title: Text("Country"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintStyle: TextStyle(color: Colors.white60),
                hintText: "Select Country",
                filled: true,
                fillColor: Colors.white30,
              ),
              controller: _searchTec,
              onChanged: (str){
                if(str.isEmpty){
                  filterList = [];
                }else{
                  filterList = cList.where((co){
                      return co.country.toLowerCase().contains(str.toLowerCase());
                  }).toList();
                }
                setState(() {

                });
              },
            ),
            Expanded(
              child: StreamBuilder<ResponseOb>(
                initialData: ResponseOb(msgState: MsgState.loading),
                stream: _bloc.getCountryStream(),
                builder: (BuildContext context,AsyncSnapshot<ResponseOb> snapshot){
                  ResponseOb resOb = snapshot.data;
                  if(resOb.msgState==MsgState.data){
                     cList=resOb.data;
                    return MainWidget(cList);
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
            ),
          ],
        ),
      ),
    );
  }
  Widget MainWidget(List<CountryOb> cList){
    return ListView.builder(
      itemCount: _searchTec.text.isEmpty?cList.length:filterList.length,
      itemBuilder: (Context,index){
        return Card(
          child: ListTile(
            onTap: (){
              Navigator.of(context).pop(_searchTec.text.isEmpty?cList[index].slug:filterList[index].slug);
            },
            tileColor: Colors.black87,
            title: Text(_searchTec.text.isEmpty?cList[index].country:filterList[index].country,style: TextStyle(
              color: Colors.white
            ),),
            leading: Icon(Icons.flag,color: Colors.white,),
            trailing: Icon(Icons.chevron_right, color: Colors.white,),
          ),
        );
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
