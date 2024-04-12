import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(valueField: 'value')
enum StanceLabel {
  agrees('agrees'),
  disagrees('disagrees'),
  neither('neither');

  final String value;

  const StanceLabel(this.value);

  String toDisplayString() {
    switch (this) {
      case StanceLabel.agrees:
        return '👍 Agrees';
      case StanceLabel.disagrees:
        return '👎 Disagrees';
      case StanceLabel.neither:
        return 'Neither';
    }
  }
}
