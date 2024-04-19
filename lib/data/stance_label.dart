import 'package:annotator_app/data/stance_annotation_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(valueField: 'value')
enum StanceLabel {
  positive('positive'),
  negative('negative'),
  neither('neither');

  final String value;

  const StanceLabel(this.value);

  String toDisplayString(StanceAnnotationType type) {
    if (type == StanceAnnotationType.source) {
      return switch (this) {
        StanceLabel.positive => 'In Favor',
        StanceLabel.negative => '  Against  ',
        StanceLabel.neither => 'Neither',
      };
    } else {
      return switch (this) {
        StanceLabel.positive => 'Agrees',
        StanceLabel.negative => 'Disagrees',
        StanceLabel.neither => 'Neither',
      };
    }
  }
}
