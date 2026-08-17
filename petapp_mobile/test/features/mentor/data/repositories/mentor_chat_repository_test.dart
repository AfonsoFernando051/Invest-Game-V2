import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:petrimonium/core/utils/translator.dart';
import 'package:petrimonium/features/mentor/data/datasources/mentor_remote_datasource.dart';
import 'package:petrimonium/features/mentor/data/repositories/mentor_chat_repository.dart';
import 'package:petrimonium/features/mentor/domain/entities/chat_message.dart';
import 'package:petrimonium/features/pet/data/models/investment_horizon_enum.dart';
import 'package:petrimonium/features/pet/data/models/pet_goal_enum.dart';
import 'package:petrimonium/features/pet/data/repositories/pet_preferences_repository.dart';

class MockMentorRemoteDataSource extends Mock implements MentorRemoteDataSource {}

ChatMessage _msg(int n, {ChatRole role = ChatRole.user}) =>
    ChatMessage(id: '$n', role: role, text: 'msg $n', timestamp: DateTime(2024, 1, 1));

void main() {
  late MockMentorRemoteDataSource mockDataSource;
  late PetPreferencesRepository petPreferencesRepository;
  late MentorChatRepository repository;

  setUpAll(() {
    registerFallbackValue(<Map<String, String>>[]);
    registerFallbackValue(<String, String?>{});
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Translator.currentLanguage = 'pt';
    mockDataSource = MockMentorRemoteDataSource();
    petPreferencesRepository = PetPreferencesRepository();
    repository = MentorChatRepository(remoteDataSource: mockDataSource, petPreferencesRepository: petPreferencesRepository);
  });

  group('loadHistory / saveHistory / clearHistory', () {
    test('loadHistory returns an empty list when nothing is persisted', () async {
      expect(await repository.loadHistory(), isEmpty);
    });

    test('round-trips messages through saveHistory/loadHistory', () async {
      final messages = [_msg(1), _msg(2, role: ChatRole.mentor)];

      await repository.saveHistory(messages);
      final loaded = await repository.loadHistory();

      expect(loaded.length, 2);
      expect(loaded[0].id, '1');
      expect(loaded[1].role, ChatRole.mentor);
    });

    test('clearHistory empties what loadHistory returns afterward', () async {
      await repository.saveHistory([_msg(1)]);
      await repository.clearHistory();

      expect(await repository.loadHistory(), isEmpty);
    });
  });

  group('sendMessage', () {
    test('sends the message with the user\'s saved goal/horizon and current language as context', () async {
      await petPreferencesRepository.saveGoal(PetGoalEnum.retireEarly);
      await petPreferencesRepository.saveHorizon(InvestmentHorizonEnum.longTerm);
      when(() => mockDataSource.sendMessage(
            message: any(named: 'message'),
            history: any(named: 'history'),
            context: any(named: 'context'),
          )).thenAnswer((_) async => 'reply');

      await repository.sendMessage(message: 'Oi', priorMessages: [], currentScreen: 'mentor');

      final captured = verify(() => mockDataSource.sendMessage(
            message: any(named: 'message'),
            history: any(named: 'history'),
            context: captureAny(named: 'context'),
          )).captured.single as Map<String, String?>;

      expect(captured['petGoal'], PetGoalEnum.retireEarly.label);
      expect(captured['investmentHorizon'], InvestmentHorizonEnum.longTerm.label);
      expect(captured['currentScreen'], 'mentor');
      expect(captured['language'], 'pt');
    });

    test('maps prior messages to role/text pairs using "user"/"mentor" role strings', () async {
      when(() => mockDataSource.sendMessage(
            message: any(named: 'message'),
            history: any(named: 'history'),
            context: any(named: 'context'),
          )).thenAnswer((_) async => 'reply');

      final prior = [_msg(1, role: ChatRole.user), _msg(2, role: ChatRole.mentor)];
      await repository.sendMessage(message: 'Oi', priorMessages: prior);

      final captured = verify(() => mockDataSource.sendMessage(
            message: any(named: 'message'),
            history: captureAny(named: 'history'),
            context: any(named: 'context'),
          )).captured.single as List<Map<String, String>>;

      expect(captured, [
        {'role': 'user', 'text': 'msg 1'},
        {'role': 'mentor', 'text': 'msg 2'},
      ]);
    });

    test('only sends the most recent 10 turns when priorMessages is longer', () async {
      when(() => mockDataSource.sendMessage(
            message: any(named: 'message'),
            history: any(named: 'history'),
            context: any(named: 'context'),
          )).thenAnswer((_) async => 'reply');

      final prior = List.generate(15, (i) => _msg(i));
      await repository.sendMessage(message: 'Oi', priorMessages: prior);

      final captured = verify(() => mockDataSource.sendMessage(
            message: any(named: 'message'),
            history: captureAny(named: 'history'),
            context: any(named: 'context'),
          )).captured.single as List<Map<String, String>>;

      expect(captured.length, 10);
      expect(captured.first['text'], 'msg 5');
      expect(captured.last['text'], 'msg 14');
    });

    test('returns the reply text from the data source', () async {
      when(() => mockDataSource.sendMessage(
            message: any(named: 'message'),
            history: any(named: 'history'),
            context: any(named: 'context'),
          )).thenAnswer((_) async => 'Claro, posso ajudar!');

      final reply = await repository.sendMessage(message: 'Oi', priorMessages: []);

      expect(reply, 'Claro, posso ajudar!');
    });
  });
}
