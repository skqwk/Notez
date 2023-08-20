import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/event/event_repo.dart';
import 'package:notez/crdt/hlc/hybrid_timestamp.dart';
import 'package:notez/crdt/sync/remote_node.dart';
import 'package:notez/crdt/sync/sync_service.dart';
import 'package:notez/crdt/versionvector/version_vector.dart';
import 'package:notez/crdt/versionvector/version_vector_repo.dart';

class VersionVectorRepoMock extends Mock implements VersionVectorRepo {}

class RemoteNodeMock extends Mock implements RemoteNode {}

class EventRepoMock extends Mock implements EventRepo {}

late VersionVectorRepo versionVectorRepo;
late RemoteNode remoteNode;
late EventRepo eventRepo;
late SyncService syncService;

void main() {
  setUp(() {
    registerFallbackValue(HybridTimestamp(0, 0, 'nodeId'));
    registerFallbackValue(VersionVector([]));

    versionVectorRepo = VersionVectorRepoMock();
    remoteNode = RemoteNodeMock();
    eventRepo = EventRepoMock();
    syncService = SyncServiceImpl(
      versionVectorRepo,
      remoteNode,
      eventRepo,
    );
  });

  test(
      'Должен получать локальный вектор версий и по нему запрашивать состояние удаленного узла',
      () async {
    // GIVEN
    List<Event> remoteEvents = [Event(EventType.UPDATE_VAULT, "", {})];
    List<Event> missingEvents = mockGetRemoteState(remoteEvents);

    when(() => remoteNode.sendLocalEvents(missingEvents))
        .thenAnswer((_) async => ());

    // WHEN
    bool result = await syncService.sync();

    // THEN
    expect(result, isTrue);
    verify(() => eventRepo.saveEvents(remoteEvents));
    verify(() => remoteNode.sendLocalEvents(missingEvents));
    verify(() => versionVectorRepo.saveVersionVector(any()));
  });

  test(
      'Если не удалось получить состояние с удаленного узла, должен вернуть false',
      () async {
    // GIVEN
    VersionVector local = VersionVector([HybridTimestamp(0, 0, 'nodeId')]);
    when(() => versionVectorRepo.getVersionVector()).thenReturn(local);

    when(() => remoteNode.getRemoteState(local)).thenAnswer((_) async => null);

    // WHEN
    bool result = await syncService.sync();

    // THEN
    expect(result, isFalse);
    verifyNever(() => eventRepo.saveEvents(any()));
    verifyNever(() => remoteNode.sendLocalEvents(any()));
    verifyNever(() => versionVectorRepo.saveVersionVector(any()));
  });

  test(
      'При ошибке во время отправки событий на удаленный узел должен повторить отправку 5 раз',
      () async {
    // GIVEN
    List<Event> remoteEvents = [Event(EventType.UPDATE_VAULT, "", {})];
    List<Event> missingEvents = mockGetRemoteState(remoteEvents);

    when(() => remoteNode.sendLocalEvents(missingEvents))
        .thenThrow(Exception('Ошибка во время отправки событий'));

    // WHEN
    bool result = await syncService.sync();

    // THEN
    expect(result, isFalse);
    verifyNever(() => eventRepo.saveEvents(any()));
    verify(() => remoteNode.sendLocalEvents(any())).called(5);
    verifyNever(() => versionVectorRepo.saveVersionVector(any()));
  });
}

List<Event> mockGetRemoteState(List<Event> remoteEvents) {
  VersionVector local = VersionVector([HybridTimestamp(0, 0, 'nodeId')]);
  when(() => versionVectorRepo.getVersionVector()).thenReturn(local);

  RemoteState remoteState = RemoteState(remoteEvents, VersionVector([]));
  when(() => remoteNode.getRemoteState(local))
      .thenAnswer((_) async => remoteState);

  List<Event> missingEvents = [Event(EventType.REMOVE_VAULT, "", {})];
  when(() => eventRepo.getEventsHappenAfter(any())).thenReturn(missingEvents);
  return missingEvents;
}
