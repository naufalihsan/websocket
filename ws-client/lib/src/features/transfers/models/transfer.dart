import 'package:json_annotation/json_annotation.dart';
import 'package:websocket_client/src/features/transfers/models/container.dart';

part 'transfer.g.dart';

@JsonSerializable()
class TransferDTO {
  final List<ContainerDTO> containers;

  TransferDTO({
    required this.containers,
  });

  factory TransferDTO.fromJson(Map<String, dynamic> json) =>
      _$TransferDTOFromJson(json);

  Map<String, dynamic> toJson() => _$TransferDTOToJson(this);
}
