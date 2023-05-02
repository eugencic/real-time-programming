```mermaid
sequenceDiagram
    Publisher->>Broker Publisher Supervisor: Message & Topic
    Broker Publisher Supervisor->>Broker Topics: Message & Topic
    Broker Topics->>Broker Consumer Supervisor: Message & Topic
    Broker Consumer Supervisor->>Consumer: Message & Topic
    Consumer->>Broker Consumer Supervisor: Subscribe
```