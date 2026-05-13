part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}

class LoadThreads extends ChatEvent {}

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
