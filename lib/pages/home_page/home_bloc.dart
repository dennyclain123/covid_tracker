import 'dart:async';
import 'dart:convert';
import 'package:covid_tracker/ob/covid_summary_ob.dart';
import 'package:covid_tracker/utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:covid_tracker/ob/responseob.dart';

class HomeBloc{
  StreamController<ResponseOb> _controller = StreamController.broadcast();
  Stream<ResponseOb> getCovidSummaryStream()=>_controller.stream;
  getCovidSummaryData()async{
    ResponseOb resOb = ResponseOb(msgState: MsgState.loading);
    // _controller.sink.add(resOb);
    var response = await http.get(Uri.parse(SUMMARY_URL));
    // print(response.body);
    if(response.statusCode==200){
      Map<String,dynamic> map = json.decode(response.body);
      CovidSummaryOb cob = CovidSummaryOb.fromJson(map);
      resOb.data = cob;
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