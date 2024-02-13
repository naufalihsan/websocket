package studio.cansky.websocket.service;

import studio.cansky.websocket.data.Container;

import java.util.HashMap;
import java.util.HashSet;

public interface TransferService {
    HashMap<String, HashSet<Container>> getContainers(Long transferId);

    void scanContainer(Long transferId, Container container);
}
