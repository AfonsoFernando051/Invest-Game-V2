import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:petrimonium/features/mentor/data/repositories/mentor_chat_repository.dart';
import 'package:petrimonium/features/mentor/domain/entities/chat_message.dart';
import 'package:petrimonium/features/mentor/presentation/controllers/mentor_chat_controller.dart';

class MockMentorChatRepository extends Mock implements MentorChatRepository {}

void main() {
  late MockMentorChatRepository mockRepository;
  late MentorChatController controller;

  setUpAll(() {
    registerFallbackValue(<ChatMessage>[]);
  });

  setUp(() {
    mockRepository = MockMentorChatRepository();
    controller = MentorChatController(repository: mockRepository);
    when(() => mockRepository.saveHistory(any())).thenAnswer((_) async {});
  });

  tearDown(() {
    controller.dispose();
  });

  group('loadHistory', () {
    test('populates messages from the repository and clears the loading flag', () async {
      final history = [
        ChatMessage(id: '1', role: ChatRole.user, text: 'Oi', timestamp: DateTime(2024, 1, 1)),
        ChatMessage(id: '2', role: ChatRole.mentor, text: 'Olá!', timestamp: DateTime(2024, 1, 1)),
      ];
      when(() => mockRepository.loadHistory()).thenAnswer((_) async => history);

      expect(controller.isLoadingHistory, isTrue);
      await controller.loadHistory();

      expect(controller.isLoadingHistory, isFalse);
      expect(controller.messages, history);
    });

    test('messages is unmodifiable', () async {
      when(() => mockRepository.loadHistory()).thenAnswer((_) async => []);
      await controller.loadHistory();

      expect(() => controller.messages.add(
            ChatMessage(id: 'x', role: ChatRole.user, text: 'x', timestamp: DateTime.now()),
          ), throwsUnsupportedError);
    });
  });

  group('sendMessage — happy path', () {
    test('appends the user message immediately, then the revealed mentor reply', () async {
      when(() => mockRepository.sendMessage(
            message: any(named: 'message'),
            priorMessages: any(named: 'priorMessages'),
            currentScreen: any(named: 'currentScreen'),
          )).thenAnswer((_) async => 'Claro, posso ajudar!');

      await controller.sendMessage('O que são dividendos?', currentScreen: 'mentor');

      expect(controller.messages.length, 2);
      expect(controller.messages[0].role, ChatRole.user);
      expect(controller.messages[0].text, 'O que são dividendos?');
      expect(controller.messages[1].role, ChatRole.mentor);
      expect(controller.messages[1].text, 'Claro, posso ajudar!');
      expect(controller.messages[1].isError, isFalse);
      expect(controller.isSending, isFalse);
    });

    test('passes the trimmed text and prior messages to the repository', () async {
      when(() => mockRepository.sendMessage(
            message: any(named: 'message'),
            priorMessages: any(named: 'priorMessages'),
            currentScreen: any(named: 'currentScreen'),
          )).thenAnswer((_) async => 'ok');

      await controller.sendMessage('  Qual missão devo completar?  ');

      final captured = verify(() => mockRepository.sendMessage(
            message: captureAny(named: 'message'),
            priorMessages: any(named: 'priorMessages'),
            currentScreen: any(named: 'currentScreen'),
          )).captured;
      expect(captured.single, 'Qual missão devo completar?');
    });

    test('persists history after the user message and again after the reply settles', () async {
      when(() => mockRepository.sendMessage(
            message: any(named: 'message'),
            priorMessages: any(named: 'priorMessages'),
            currentScreen: any(named: 'currentScreen'),
          )).thenAnswer((_) async => 'ok');

      await controller.sendMessage('Oi');

      verify(() => mockRepository.saveHistory(any())).called(2);
    });

    test('ignores a blank/whitespace-only message', () async {
      await controller.sendMessage('   ');

      expect(controller.messages, isEmpty);
      verifyNever(() => mockRepository.sendMessage(
            message: any(named: 'message'),
            priorMessages: any(named: 'priorMessages'),
            currentScreen: any(named: 'currentScreen'),
          ));
    });

    test('ignores a new send while one is already in flight', () async {
      when(() => mockRepository.sendMessage(
            message: any(named: 'message'),
            priorMessages: any(named: 'priorMessages'),
            currentScreen: any(named: 'currentScreen'),
          )).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        return 'ok';
      });

      final first = controller.sendMessage('primeira');
      final second = controller.sendMessage('segunda, deve ser ignorada');
      await Future.wait([first, second]);

      // Only the first user message should have been appended.
      expect(controller.messages.where((m) => m.role == ChatRole.user).length, 1);
      expect(controller.messages.first.text, 'primeira');
    });
  });

  group('sendMessage — failure', () {
    test('reveals the fallback error reply and marks it as an error, without throwing', () async {
      when(() => mockRepository.sendMessage(
            message: any(named: 'message'),
            priorMessages: any(named: 'priorMessages'),
            currentScreen: any(named: 'currentScreen'),
          )).thenThrow(Exception('backend down'));

      await controller.sendMessage('Oi');

      expect(controller.messages.length, 2);
      expect(controller.messages[1].role, ChatRole.mentor);
      expect(controller.messages[1].isError, isTrue);
      expect(controller.messages[1].text, isNotEmpty);
      expect(controller.isSending, isFalse);
    });
  });

  group('clearConversation', () {
    test('empties the message list and clears persisted history', () async {
      when(() => mockRepository.sendMessage(
            message: any(named: 'message'),
            priorMessages: any(named: 'priorMessages'),
            currentScreen: any(named: 'currentScreen'),
          )).thenAnswer((_) async => 'ok');
      when(() => mockRepository.clearHistory()).thenAnswer((_) async {});
      await controller.sendMessage('Oi');
      expect(controller.messages, isNotEmpty);

      await controller.clearConversation();

      expect(controller.messages, isEmpty);
      verify(() => mockRepository.clearHistory()).called(1);
    });
  });
}
