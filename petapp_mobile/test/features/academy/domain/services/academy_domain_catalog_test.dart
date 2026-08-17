import 'package:flutter_test/flutter_test.dart';
import 'package:petrimonium/core/utils/translator.dart';
import 'package:petrimonium/features/academy/domain/services/academy_catalog.dart';
import 'package:petrimonium/features/academy/domain/services/academy_domain_catalog.dart';

/// Structural/integrity coverage for `AcademyDomainCatalog`, mirroring
/// `academy_catalog_test.dart`'s style: rather than asserting copy, these
/// check the invariant the Domain layer exists for — every school declared
/// in `AcademyCatalog` belongs to exactly one domain, and no domain
/// references a school that doesn't exist.
void main() {
  for (final language in ['pt', 'en', 'es']) {
    group('AcademyDomainCatalog ($language)', () {
      setUp(() => Translator.currentLanguage = language);

      test('has at least one domain', () {
        expect(AcademyDomainCatalog.domains, isNotEmpty);
      });

      test('domain ids are unique', () {
        final ids = AcademyDomainCatalog.domains.map((d) => d.id).toList();
        expect(ids.toSet().length, ids.length);
      });

      test('every schoolId a domain declares resolves to a real school', () {
        final schoolIds = AcademyCatalog.schools.map((s) => s.id).toSet();
        for (final domain in AcademyDomainCatalog.domains) {
          for (final schoolId in domain.schoolIds) {
            expect(schoolIds.contains(schoolId), isTrue, reason: 'domain ${domain.id} references unknown school $schoolId');
          }
        }
      });

      test('every school belongs to exactly one domain', () {
        for (final school in AcademyCatalog.schools) {
          final owners = AcademyDomainCatalog.domains.where((d) => d.schoolIds.contains(school.id)).toList();
          expect(owners.length, 1, reason: 'school ${school.id} is owned by ${owners.length} domains, expected exactly 1');
        }
      });

      test('no school id is declared by more than one domain', () {
        final allSchoolIds = AcademyDomainCatalog.domains.expand((d) => d.schoolIds).toList();
        expect(allSchoolIds.toSet().length, allSchoolIds.length);
      });
    });
  }

  group('domainById', () {
    test('returns null for an unknown id instead of throwing', () {
      expect(AcademyDomainCatalog.domainById('nope'), isNull);
    });

    test('resolves a real id to the matching domain', () {
      final domain = AcademyDomainCatalog.domains.first;
      expect(AcademyDomainCatalog.domainById(domain.id)?.id, domain.id);
    });
  });

  group('domainForSchool', () {
    test('resolves a real school id to its owning domain', () {
      final domain = AcademyDomainCatalog.domains.first;
      final schoolId = domain.schoolIds.first;
      expect(AcademyDomainCatalog.domainForSchool(schoolId)?.id, domain.id);
    });

    test('returns null for an unknown school id', () {
      expect(AcademyDomainCatalog.domainForSchool('nope'), isNull);
    });
  });
}
