import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:websocket_client/src/constants/app.dart';
import 'package:websocket_client/src/constants/transfers.dart';
import 'package:websocket_client/src/features/transfers/models/container.dart';
import 'package:websocket_client/src/features/transfers/models/transfer.dart';
import 'package:websocket_client/src/features/transfers/transfer_repository.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key, required this.transferId});

  final String transferId;

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final containerController = TextEditingController();

  List<ContainerDTO> containers = <ContainerDTO>[];
  String containerTypeValue = containerType.first;

  late final StompClient stompClient;

  void initWebSocket() async {
    stompClient = StompClient(
      config: StompConfig(
        url: wsUrl,
        onConnect: onConnect,
        reconnectDelay: const Duration(seconds: 3),
        beforeConnect: () async {
          print('Waiting to connect...');
          await Future.delayed(const Duration(milliseconds: 200));
          print('Connecting...');
        },
        // server sends an error frame
        onStompError: (dynamic error) {
          print("Stomp Error: $error");
        },
        // the underyling WebSocket throws an error
        onWebSocketError: (dynamic error) {
          print("Websocket Error: $error");
        },
        onDebugMessage: (dynamic error) {
          print("Debug: $error");
        },
        // stompConnectHeaders: {'Authorization': 'Bearer token'},
        // webSocketConnectHeaders: {'Authorization': 'Bearer token'},
      ),
    );

    stompClient.activate();
  }

  void onConnect(StompFrame frame) {
    // sync current transfers
    syncLiveContainers(transferId: widget.transferId);

    stompClient.subscribe(
      destination: "/broker/transfers/${widget.transferId}",
      callback: (frame) {
        TransferDTO? transfer = TransferDTO.fromJson(json.decode(frame.body!));
        setState(() {
          containers = transfer.containers;
        });
      },
    );
  }

  void syncLiveContainers({required String transferId}) async {
    final TransferDTO transfer =
        await TransferRepository.getContainers(transferId: transferId);

    setState(() {
      containers = transfer.containers;
    });
  }

  void submitContainer({
    required String containerId,
    required String containerType,
  }) async {
    if (containerId.isEmpty || containerType.isEmpty) return;

    await TransferRepository.scanContainer(
      transferId: widget.transferId,
      containerDTO: ContainerDTO(
        containerId: containerId,
        containerType: containerType,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initWebSocket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Transfer ID: ${widget.transferId}"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  "Scanned Container: ${containers.length}",
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              TextFormField(
                controller: containerController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Container ID',
                ),
              ),
              DropdownMenu<String>(
                initialSelection: containerTypeValue,
                onSelected: (String? value) {
                  setState(() {
                    containerTypeValue = value!;
                  });
                },
                dropdownMenuEntries: containerType
                    .map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  submitContainer(
                    containerId: containerController.text,
                    containerType: containerTypeValue,
                  );
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    stompClient.deactivate();
    super.dispose();
  }
}
