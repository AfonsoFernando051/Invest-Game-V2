import 'package:flutter/foundation.dart';
import 'package:petrimonium/core/constants/app_strings.dart';
import 'package:petrimonium/core/utils/translator.dart';
import 'package:petrimonium/features/mentor/data/repositories/mentor_chat_repository.dart';
import 'package:petrimonium/features/mentor/domain/entities/conversation_summary.dart';

/// Drives the Mentor conversation history screen: load, rename, delete.
class ConversationListController extends ChangeNotifier {
  ConversationListController({required MentorChatRepository repository}) : _repository = repository;

  final MentorChatRepository _repository;

  bool isLoading = true;
  String? error;
  List<ConversationSummary> conversations = [];

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      conversations = await _repository.listConversations();
    } catch (_) {
      error = Translator.translate(AppStrings.mentorConversationsLoadError);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> rename(int conversationId, String title) async {
    await _repository.renameConversation(conversationId, title);
    await load();
  }

  Future<void> delete(int conversationId) async {
    await _repository.deleteConversation(conversationId);
    conversations = conversations.where((c) => c.id != conversationId).toList();
    notifyListeners();
  }
}
