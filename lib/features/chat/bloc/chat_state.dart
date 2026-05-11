part of 'chat_bloc.dart';


class ChatState extends Equatable {
  const ChatState({this.threads = const []});
  final List<ChatThread> threads;
  ChatState copyWith({List<ChatThread>? threads}) => ChatState(threads: threads ?? this.threads);
  @override
  List<Object?> get props => [threads];
}
