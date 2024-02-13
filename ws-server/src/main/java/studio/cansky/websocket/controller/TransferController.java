package studio.cansky.websocket.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import studio.cansky.websocket.data.Container;
import studio.cansky.websocket.data.ContainerForm;
import studio.cansky.websocket.data.ContainerType;
import studio.cansky.websocket.service.TransferService;

import java.util.HashMap;
import java.util.HashSet;

@RestController
@RequestMapping("/transfers")
public class TransferController {
    @Autowired
    private TransferService transferService;

    @GetMapping("/{transferId}")
    public HashMap<String, HashSet<Container>> getContainers(@PathVariable Long transferId) {
        return transferService.getContainers(transferId);
    }

    @PostMapping("/{transferId}/scan")
    public void scanContainer(
            @PathVariable Long transferId,
            @RequestBody ContainerForm containerForm
    ) {
        transferService.scanContainer(transferId, Container.builder()
                .containerId(containerForm.getContainerId())
                .containerType(ContainerType.valueOf(containerForm.getContainerType()))
                .build());
    }

}
