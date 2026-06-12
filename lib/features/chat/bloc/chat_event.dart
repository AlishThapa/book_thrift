part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}

class LoadThreads extends ChatEvent {}

class CreateConversation extends ChatEvent {
  final int recipientId;
  const CreateConversation(this.recipientId);
  @override
  List<Object?> get props => [recipientId];
}

class ResetLastCreatedId extends ChatEvent {}

class ChangeFilter extends ChatEvent {
  const ChangeFilter(this.filter);
  final String filter;
  @override
  List<Object?> get props => [filter];
}

class SearchThreads extends ChatEvent {
  const SearchThreads(this.query);
  final String query;
  @override
  List<Object?> get props => [query];
}

class SendMessage extends ChatEvent {
  const SendMessage(
    this.threadId,
    this.text, {
    this.type = ChatMessageType.text,
    this.mediaUrl,
    this.fileName,
    this.listing,
  });

  final String threadId;
  final String text;
  final ChatMessageType type;
  final String? mediaUrl;
  final String? fileName;
  final BookListing? listing;

  @override
  List<Object?> get props => [threadId, text, type, mediaUrl, fileName, listing];
}

class DeleteThread extends ChatEvent {
  const DeleteThread(this.threadId);
  final String threadId;
  @override
  List<Object?> get props => [threadId];
}

class ConnectWebSocket extends ChatEvent {}

class DisconnectWebSocket extends ChatEvent {}

class ReceivedWsMessage extends ChatEvent {
  final Map<String, dynamic> message;
  const ReceivedWsMessage(this.message);
  @override
  List<Object?> get props => [message];
}

class LoadMessages extends ChatEvent {
  final String threadId;
  const LoadMessages(this.threadId);
  @override
  List<Object?> get props => [threadId];
}

class MarkMessageRead extends ChatEvent {
  final int messageId;
  final int conversationId;
  const MarkMessageRead(this.messageId, this.conversationId);
  @override
  List<Object?> get props => [messageId, conversationId];
}
