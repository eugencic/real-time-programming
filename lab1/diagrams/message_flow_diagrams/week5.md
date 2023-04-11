```mermaid
sequenceDiagram
    Docker Container->>Stream Reader: SSE Stream
    Stream Reader->>Redactor Task Mediator: Parsed Json
    Stream Reader->>Sentiment Scorer Task Mediator: Parsed Json
    Stream Reader->>Engagement Rationer Task Mediator: Parsed Json
    Redactor Task Mediator->>Redactor: Parsed Json
    Sentiment Scorer Task Mediator->>Sentiment Scorer: Parsed Json
    Engagement Rationer Task Mediator->>Engagement Rationer: Parsed Json
    Redactor->>Batcher: Parsed Json
```