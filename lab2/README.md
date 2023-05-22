# Laboratory Work Nr.2

## Description

The goal for this project is to create an actor-based message broker application that would
manage the communication between other applications named producers and consumers.

## Message Flow Diagram

```mermaid
sequenceDiagram
    PublisherUser->>Publisher: Connection established
    ConsumerUser->>Consumer: Connection established
    Publisher->>Role Manager: Check whether the role of the user is registered
    Consumer->>Role Manager: Check whether the role of the user is registered
    Publisher->>PublisherUser: What is your name?
    PublisherUser->>Publisher: Name answer
    Publisher->>Role Manager: Assign role to the user
    Consumer->>Role Manager: Assign role to the user
    Role Manager->>Database: Store the role of the user
    Publisher->>Subscription Manager: Register publisher
    Subscription Manager->>Database: Store the name of the user
    Publisher->>Commands: Start listening to the user
    Consumer->>Commands: Start listening to the user
    PublisherUser->>Commands: Publish on topic
    ConsumerUser->>Commands: Subscribe to topic/publisher
    Command->> ConsumerUser: Send message if the user is subscribed
```

## Supervision Tree Diagram

![Diagram](https://github.com/eugencic/real-time-programming/blob/main/lab2/diagrams/supervision_tree_diagram.png)

## Installation

### Clone the repository

```bash
 git clone https://github.com/eugencic/real-time-programming/tree/main/lab2
```

### Change the directory

```
 cd lab2
```

### Run the project

Execute this command in the terminal to install all the dependencies of the project

```bash
$ mix run --no-halt
```

Execute these commands to connect via Telnet

```bash
$ telnet 127.0.0.1 4040
```

```bash
$ telnet 127.0.0.1 4041
```
