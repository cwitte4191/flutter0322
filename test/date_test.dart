import 'package:intl/intl.dart';

void main(){
  DateTime date = new DateTime.fromMillisecondsSinceEpoch(1526382659000,isUtc: true).toLocal();
  //DateTime date = new DateTime.fromMillisecondsSinceEpoch(1525488950137,isUtc: true).toLocal();

  var formattedDate = new DateFormat.Hms().format(date);

  print ("m15morning:"+formattedDate);

}