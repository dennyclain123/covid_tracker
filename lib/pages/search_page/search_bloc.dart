import 'dart:async';
import 'dart:convert';
import 'package:covid_tracker/ob/covid_country_ob.dart';
import 'package:covid_tracker/utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:covid_tracker/ob/responseob.dart';

class SearchBloc{
  StreamController<ResponseOb> _controller = StreamController<ResponseOb>();
  Stream getSearchStream() => _controller.stream;
  getCovidCountry(String country,String from,String to)async{
    ResponseOb resOb = ResponseOb(msgState: MsgState.loading);
    _controller.sink.add(resOb);
    var response = await http.get(Uri.parse(SEARCH_URL+"$country?from=$from&to=$to"));
    // print(response.statusCode);
    if(response.statusCode==200){
      List<CovidCountryOb> ccList = [];
      List<dynamic> list = json.decode(response.body);
      list.forEach((data) {
        ccList.add(CovidCountryOb.fromJson(data));
      });
      resOb.data = ccList;
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