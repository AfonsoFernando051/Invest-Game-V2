import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:petrimonium/features/asset_details/data/repositories/asset_details_repository.dart';
import 'package:petrimonium/features/asset_details/domain/entities/asset_data_status.dart';
import 'package:petrimonium/features/asset_details/domain/entities/asset_details.dart';
import 'package:petrimonium/features/asset_details/presentation/controllers/asset_details_controller.dart';
import 'package:petrimonium/features/investment/data/models/investment_type_enum.dart';
import 'package:petrimonium/features/portfolio/domain/entities/holding.dart';
import 'package:petrimonium/features/portfolio/domain/entities/investment_lot.dart';

class MockAssetDetailsRepository extends Mock implements AssetDetailsRepository {}

Holding _holdingFor(InvestmentTypeEnum type) {
  final lot = InvestmentLot(
    id: 1,
    ticker: 'PETR4',
    type: type,
    quantity: 10,
    purchasePrice: 20,
    currentPrice: 25,
    purchaseDate: DateTime(2024, 1, 1),
    investedValue: 200,
    currentValue: 250,
  );
  return Holding.fromLots([lot]).first;
}

void main() {
  late MockAssetDetailsRepository mockRepository;
  late AssetDetailsController controller;

  setUp(() {
    mockRepository = MockAssetDetailsRepository();
    controller = AssetDetailsController(repository: mockRepository);
  });

  group('loadAssetDetails — success', () {
    test('sets isLoading true then false, and populates assetDetails from the repository', () async {
      final details = const AssetDetails(ticker: 'PETR4', shortName: 'Petrobras', dataStatus: AssetDataStatus.fresh);
      when(() => mockRepository.fetchAssetDetails('PETR4')).thenAnswer((_) async => details);

      final future = controller.loadAssetDetails('PETR4');
      expect(controller.isLoading, isTrue);

      await future;

      expect(controller.isLoading, isFalse);
      expect(controller.error, isNull);
      expect(controller.assetDetails, details);
    });

    test('notifies listeners on completion', () async {
      when(() => mockRepository.fetchAssetDetails(any())).thenAnswer(
        (_) async => const AssetDetails(ticker: 'PETR4'),
      );
      var notifications = 0;
      controller.addListener(() => notifications++);

      await controller.loadAssetDetails('PETR4');

      expect(notifications, greaterThan(0));
    });
  });

  group('loadAssetDetails — with a Holding (instant preview)', () {
    test('shows an immediate cached preview built from the Holding before the fetch resolves', () async {
      final holding = _holdingFor(InvestmentTypeEnum.STOCKS);
      // Never resolves during this test — asserts on the synchronous preview state.
      when(() => mockRepository.fetchAssetDetails(any())).thenAnswer(
        (_) => Completer<AssetDetails>().future,
      );

      final future = controller.loadAssetDetails('PETR4', holding: holding);

      // The preview is built synchronously inside loadAssetDetails, before
      // the repository call is awaited.
      expect(controller.assetDetails, isNotNull);
      expect(controller.assetDetails!.dataStatus, AssetDataStatus.cached);
      expect(controller.assetDetails!.userPosition, isNotNull);
      expect(controller.assetDetails!.userPosition!.quantity, holding.quantity);
      expect(controller.assetDetails!.currentPrice, holding.currentPrice);

      // Let the pending future settle so it doesn't leak into the next test.
      unawaited(future);
    });

    test('maps REAL_ESTATE holdings to the "fii" asset type', () async {
      final holding = _holdingFor(InvestmentTypeEnum.REAL_ESTATE);
      when(() => mockRepository.fetchAssetDetails(any())).thenAnswer(
        (_) => Completer<AssetDetails>().future,
      );

      final future = controller.loadAssetDetails('PETR4', holding: holding);
      expect(controller.assetDetails!.assetType, 'fii');
      unawaited(future);
    });

    test('maps FUNDS holdings to the "etf" asset type', () async {
      final holding = _holdingFor(InvestmentTypeEnum.FUNDS);
      when(() => mockRepository.fetchAssetDetails(any())).thenAnswer(
        (_) => Completer<AssetDetails>().future,
      );

      final future = controller.loadAssetDetails('PETR4', holding: holding);
      expect(controller.assetDetails!.assetType, 'etf');
      unawaited(future);
    });

    test('maps CRYPTO holdings to the "crypto" asset type', () async {
      final holding = _holdingFor(InvestmentTypeEnum.CRYPTO);
      when(() => mockRepository.fetchAssetDetails(any())).thenAnswer(
        (_) => Completer<AssetDetails>().future,
      );
      final future = controller.loadAssetDetails('PETR4', holding: holding);
      expect(controller.assetDetails!.assetType, 'crypto');
      unawaited(future);
    });

    test('maps any other type (e.g. STOCKS) to "stock"', () async {
      final holding = _holdingFor(InvestmentTypeEnum.STOCKS);
      when(() => mockRepository.fetchAssetDetails(any())).thenAnswer(
        (_) => Completer<AssetDetails>().future,
      );
      final future = controller.loadAssetDetails('PETR4', holding: holding);
      expect(controller.assetDetails!.assetType, 'stock');
      unawaited(future);
    });

    test('does not overwrite an already-loaded assetDetails with a fresh preview on a later call', () async {
      when(() => mockRepository.fetchAssetDetails(any())).thenAnswer(
        (_) async => const AssetDetails(ticker: 'PETR4', shortName: 'Real data'),
      );
      await controller.loadAssetDetails('PETR4');
      expect(controller.assetDetails!.shortName, 'Real data');

      // A second call with a holding should not clobber the already-loaded
      // real data with a synthetic preview (the `assetDetails == null` guard).
      final holding = _holdingFor(InvestmentTypeEnum.STOCKS);
      await controller.loadAssetDetails('PETR4', holding: holding);
      expect(controller.assetDetails!.shortName, 'Real data');
    });
  });

  group('loadAssetDetails — failure', () {
    test('sets error, stops loading, and keeps a prior preview instead of clearing it', () async {
      final holding = _holdingFor(InvestmentTypeEnum.STOCKS);
      when(() => mockRepository.fetchAssetDetails(any())).thenThrow(Exception('network down'));

      await controller.loadAssetDetails('PETR4', holding: holding);

      expect(controller.isLoading, isFalse);
      expect(controller.error, contains('network down'));
      // The cached preview from the holding survives the failed fetch.
      expect(controller.assetDetails, isNotNull);
      expect(controller.assetDetails!.dataStatus, AssetDataStatus.cached);
    });
  });

  group('refresh', () {
    test('does nothing if no asset has been loaded yet', () async {
      await controller.refresh();
      verifyNever(() => mockRepository.fetchAssetDetails(any()));
    });

    test('re-fetches using the ticker of the currently loaded asset', () async {
      when(() => mockRepository.fetchAssetDetails('PETR4')).thenAnswer(
        (_) async => const AssetDetails(ticker: 'PETR4'),
      );
      await controller.loadAssetDetails('PETR4');

      await controller.refresh();

      verify(() => mockRepository.fetchAssetDetails('PETR4')).called(2);
    });
  });
}
