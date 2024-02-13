import 'package:dio/dio.dart';
import 'package:websocket_client/src/constants/app.dart';
import 'package:websocket_client/src/features/transfers/models/container.dart';
import 'package:websocket_client/src/features/transfers/models/transfer.dart';

class TransferRepository {
  static Future<TransferDTO> getContainers({
    required String transferId,
  }) async {
    final Dio dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 3),
      ),
    );

    final path = "$baseUrl/transfers/$transferId";
    final response = await dio.get(path);

    if (response.statusCode == 200) {
      return TransferDTO.fromJson(response.data);
    }

    return TransferDTO(containers: List.empty());
  }

  static Future<void> scanContainer({
    required String transferId,
    required ContainerDTO containerDTO,
  }) async {
    final Dio dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 3),
      ),
    );

    final path = "$baseUrl/transfers/$transferId/scan";
    final response = await dio.post(path, data: containerDTO.toJson());
  }
}
