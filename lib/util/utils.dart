import 'package:intl/intl.dart';

String toWon(double number){
  return NumberFormat.currency(
    locale: 'ko_KR',
    symbol: '₩',
    decimalDigits: 0, // 소수점 자릿수를 0으로 설정
  ).format(number);
}