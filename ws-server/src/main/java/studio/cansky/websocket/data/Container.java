package studio.cansky.websocket.data;

import lombok.*;

@Builder
@Getter
@Setter
@EqualsAndHashCode
public class Container {
    private String containerId;
    private ContainerType containerType;
}
