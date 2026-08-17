import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petrimonium/features/pet/data/models/pet_specie_enum.dart';
import 'package:petrimonium/features/pet/domain/entities/pet_profile.dart';
import 'package:petrimonium/features/pet/domain/enums/accessory_type.dart';
import 'package:petrimonium/features/pet/domain/enums/pet_accessory_id.dart';
import 'package:petrimonium/features/pet/domain/enums/pet_evolution_stage.dart';
import 'package:petrimonium/features/pet/domain/repositories/mascot_repository.dart';
import 'package:petrimonium/features/pet/presentation/companion/rive/pet_rive_companion.dart';
import 'package:petrimonium/features/pet/presentation/mascot/controllers/mascot_controller.dart';
import 'package:petrimonium/features/pet/presentation/mascot/widgets/pet_mascot_widget.dart';
import 'package:rive/rive.dart' show RiveAnimation;

/// Minimal in-memory MascotRepository double, mirrors the one in
/// `mascot_controller_test.dart` — only `loadProfile` matters here.
class FakeMascotRepository implements MascotRepository {
  PetProfile profileToReturn = PetProfile();

  @override
  Future<PetProfile> loadProfile() async => profileToReturn;
  @override
  Future<void> saveName(String name) async {}
  @override
  Future<void> saveStage(PetEvolutionStage stage) async {}
  @override
  Future<void> saveXp(int xp) async {}
  @override
  Future<void> saveSpecie(PetSpecieEnum specie) async {}
  @override
  Future<void> saveNetWorth(double netWorth) async {}
  @override
  Future<void> saveEquippedAccessories(
    Map<AccessoryType, PetAccessoryId> equipped,
  ) async {}
  @override
  Future<void> saveUnlockedAccessories(Set<PetAccessoryId> unlocked) async {}
  @override
  Future<void> saveLastActiveAt(DateTime lastActiveAt) async {}
}

void main() {
  testWidgets(
    'falls back to PetMascotWidget when no .riv asset exists for the species',
    (tester) async {
      final controller = MascotController(repository: FakeMascotRepository());

      await tester.pumpWidget(
        MaterialApp(
          home: PetRiveCompanion(controller: controller, size: 48),
        ),
      );
      // Let the failed RiveFile.asset() future resolve — PetMascotWidget's
      // own looping breathe animation means pumpAndSettle would never
      // return, so a bounded pump is used instead.
      await tester.pump();
      await tester.pump();

      expect(find.byType(PetMascotWidget), findsOneWidget);
      expect(find.byType(RiveAnimation), findsNothing);
    },
  );

  testWidgets(
    'does not throw when the widget is disposed while the asset load is in flight',
    (tester) async {
      final controller = MascotController(repository: FakeMascotRepository());

      await tester.pumpWidget(
        MaterialApp(
          home: PetRiveCompanion(controller: controller, size: 48),
        ),
      );
      // Unmount immediately, before the async load future resolves.
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      await tester.pump();
      await tester.pump();

      expect(tester.takeException(), isNull);
    },
  );
}
