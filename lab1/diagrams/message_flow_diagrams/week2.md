```mermaid
sequenceDiagram
    Docker Container->>Stream Reader: SSE Stream
    Stream Reader->>Task Mediator: Parsed Json
    Task Mediator->>Printer: Parsed Json
```