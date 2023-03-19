```mermaid
sequenceDiagram
    Docker Container->>Stream Reader: SSE Stream
    Stream Reader->>Printer: Parsed Json
```