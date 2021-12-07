import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHelper{

  static Future<List> getMoistureData(String URL, String API_KEY) async {
    var response = await http.get(Uri.parse(URL + API_KEY));

    List data = List.from(jsonDecode(response.body)['feeds']);
    List toReturn = List.filled(0, null, growable: true);

    for(var obj in data){
      toReturn.add({
        'moisture' : obj['field1'],
        'timestamp' : obj['created_at']
      });
    }

    return toReturn;
  }

  static Future<bool> updateThreshold(String URL, String API_KEY, int threshold) async {
    var response = await http.get(Uri.parse(URL + API_KEY + "&field2=" + threshold.toString()));

    return int.parse(response.body.toString()) != 0;
  }
  
  static Future<int> getCurrentThreshold(String URL, API_KEY) async {
    
    var response = await http.get(Uri.parse(URL + API_KEY));

    print(response.body);

    return int.parse(jsonDecode(response.body)['field2'].toString());
  }

}