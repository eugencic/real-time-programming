```mermaid
sequenceDiagram
    Publisher->>Broker Publisher Manager: Message & Topic
    Broker Publisher Manager->>Broker Topics: Message & Topic
    Broker Topics->>Broker Consumer Manager: Message & Topic
    Broker Consumer Manager->>Consumer: Message & Topic
    Consumer->>Broker Consumer Manager: Subscribe
```