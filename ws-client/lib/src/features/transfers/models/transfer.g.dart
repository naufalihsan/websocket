// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferDTO _$TransferDTOFromJson(Map<String, dynamic> json) => TransferDTO(
      containers: (json['containers'] as List<dynamic>)
          .map((e) => ContainerDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TransferDTOToJson(TransferDTO instance) =>
    <String, dynamic>{
      'containers': instance.containers,
    };
