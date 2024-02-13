import 'package:json_annotation/json_annotation.dart';

part 'container.g.dart';

@JsonSerializable()
class ContainerDTO {
  final String containerId, containerType;

  ContainerDTO({
    required this.containerId,
    required this.containerType,
  });

  factory ContainerDTO.fromJson(Map<String, dynamic> json) =>
      _$ContainerDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ContainerDTOToJson(this);
}
