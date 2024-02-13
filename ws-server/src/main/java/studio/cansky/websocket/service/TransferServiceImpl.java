package studio.cansky.websocket.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;
import studio.cansky.websocket.data.Container;

import java.util.HashMap;
import java.util.HashSet;

@Service
public class TransferServiceImpl implements TransferService {
    private final SimpMessagingTemplate simpMessagingTemplate;
    private final HashMap<Long, HashSet<Container>> inMemDB = new HashMap<>();

    @Autowired
    public TransferServiceImpl(SimpMessagingTemplate simpMessagingTemplate) {
        this.simpMessagingTemplate = simpMessagingTemplate;
    }

    @Override
    public void scanContainer(Long transferId, Container container) {
        final HashSet<Container> scannedContainers = inMemDB.get(transferId);
        if (scannedContainers != null && scannedContainers.contains(container)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST);
        } else {
            inMemDB.computeIfAbsent(transferId, key -> new HashSet<>()).add(container);
        }

        simpMessagingTemplate.convertAndSend(getBroadcastDestination(transferId), getContainers(transferId));
    }

    @Override
    public HashMap<String, HashSet<Container>> getContainers(Long transferId) {
        final HashMap<String, HashSet<Container>> payload = new HashMap<>();
        payload.put("containers", inMemDB.getOrDefault(transferId, new HashSet<>()));

        return payload;
    }

    private String getBroadcastDestination(Long transferId) {
        return String.format("/broker/transfers/%d", transferId);
    }
}
