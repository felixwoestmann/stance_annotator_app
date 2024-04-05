import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(valueField: 'value')
enum StanceLabel {
  agrees('👍 Agrees'),
  disagrees('👎 Disagrees'),
  neither('🤷🏼‍ Neither');

  final String value;

  const StanceLabel(this.value);
}
