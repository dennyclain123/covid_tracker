import 'dart:async';
import 'dart:convert';
import 'package:covid_tracker/ob/country_ob.dart';
import 'package:covid_tracker/ob/covid_summary_ob.dart';
import 'package:covid_tracker/utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:covid_tracker/ob/responseob.dart';

class CountryBloc{
  StreamController<ResponseOb> _controller = StreamController<ResponseOb>();
  Stream<ResponseOb> getCountryStream()=>_controller.stream;
  getCountryData()async{
    ResponseOb resOb = ResponseOb(msgState: MsgState.loading);
    _controller.sink.add(resOb);
    var response = await http.get(Uri.parse(COUNTRY_URL));
    // print(response.body);
    if(response.statusCode==200){
      List<CountryOb> countryList = [];
      List<dynamic> list = json.decode(response.body);
      list.forEach((data) {
        countryList.add(CountryOb.fromJson(data));
      });
      resOb.data = countryList;
      resOb.msgState = MsgState.data;
      _controller.sink.add(resOb);
    }else if(response.statusCode ==404){
      resOb.data =null;
      resOb.msgState = MsgState.error;
      resOb.errState = ErrState.notFoundErr;
      _controller.sink.add(resOb);
    }else if(response.statusCode==500){
      resOb.data =null;
      resOb.msgState = MsgState.error;
      resOb.errState = ErrState.serverErr;
      _controller.sink.add(resOb);
    }else{
      resOb.data =null;
      resOb.msgState = MsgState.error;
      resOb.errState = ErrState.unknownErr;
      _controller.sink.add(resOb);
    }
  }
  dispose(){
    _controller.close();
  }
}