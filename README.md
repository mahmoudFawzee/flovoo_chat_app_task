# flovoo_chat_app_task

A simple chat application built with Flutter as an interview task. The application demonstrates conversation management, real-time message simulation, optimistic updates, message delivery statuses, unread message tracking, and a scalable architecture that can easily be connected to a real backend in the future.

---

## Features

- Conversation list screen
- Chat screen with sent and received message bubbles
- Optimistic message sending
- Simulated incoming replies
- Message status tracking
  - Sending
  - Sent
  - Delivered
  - Failed
- Dynamic unread message count
- Auto-scroll to latest messages
- Clean Architecture
- BLoC State Management
- Dependency Injection using GetIt

---

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK

### Installation

1. Clone the repository

```bash
git clone https://github.com/mahmoudFawzee/flovoo_chat_app_task.git
```

2. Install dependencies

```bash
flutter pub get
```

3. Generate JSON serialization files

```bash
dart run build_runner build -d
```

4. Run the application

```bash
flutter run
```

---

## Architecture

The project follows a lightweight Clean Architecture approach.

```text
lib/
├── app/
│   └── app.dart
├── core/
│   ├── di/
│   ├── errors/
│   ├── utils/
│   └── router/
│
├── features/
│   └── chat/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       │
│       ├── domain/
│       │   ├── entities/
│       │   └── repositories/
│       │
│       └── presentation/
│           ├── blocs/
│           ├── screens/
│           └── widget/
```

### Why this architecture?

The main goal was to separate responsibilities and make the application easy to maintain and extend.

- **Presentation Layer**
  - UI and BLoC logic
  - Responsible for user interactions and state updates

- **Domain Layer**
  - Business entities and repository contracts
  - Independent from Flutter and external libraries

- **Data Layer**
  - Data sources and repository implementations
  - Currently uses a mocked backend
  - Can be replaced with a REST API, WebSocket, Firebase, or SignalR implementation with minimal changes

This separation keeps the codebase scalable and testable.

---

## State Management

The application uses **flutter_bloc**.

### ConversationsBloc

Responsible for:

- Loading conversations
- Updating conversation previews
- Managing unread counts
- Reflecting changes in the conversation list

### ChatBloc

Responsible for:

- Loading messages
- Sending messages
- Receiving messages
- Listening to incoming message streams
- Updating message delivery statuses
- Optimistic UI updates

### Why BLoC?

I chose BLoC because:

- Predictable state management
- Clear separation between UI and business logic
- Easy testing
- Scales well for larger applications
- Widely adopted in production Flutter projects

I intentionally separated conversation-related state from chat-related state to avoid unnecessary rebuilds and to keep each BLoC focused on a single responsibility.

---

## Real-Time Messaging Simulation

The application currently uses a mocked data source backed by a `StreamController`.

This simulates real-time communication similar to:

- WebSockets
- Firebase Realtime Database
- SignalR

Because the implementation relies on repository abstractions, replacing the mock implementation with a real backend would require changes only in the data layer.

---

## Unread Message Handling

Unread messages are managed dynamically.

### Behavior

- Opening a conversation marks all messages as read
- Incoming messages received while the chat is open do not increase unread count
- Incoming messages received while the chat is closed increase unread count
- Reopening a conversation resets its unread count

This behavior closely resembles a real messaging application.

---

## Technologies Used

- Flutter
- flutter_bloc
- go_router
- get_it
- dio
- equatable
- json_annotation
- json_serializable
- build_runner

---
