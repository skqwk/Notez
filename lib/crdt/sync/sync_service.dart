import 'package:notez/common/log.dart';
import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/event/event_repo.dart';
import 'package:notez/crdt/sync/remote_node.dart';
import 'package:notez/crdt/versionvector/version_vector.dart';
import 'package:notez/crdt/versionvector/version_vector_repo.dart';

abstract class SyncService {
  Future<bool> sync();
}

class SyncServiceImpl implements SyncService {
  static const int MAX_NUMBER_ATTEMPTS = 5;

  final VersionVectorRepo versionVectorRepo;
  final EventRepo eventRepo;
  final RemoteNode remoteNode;

  SyncServiceImpl(
    this.versionVectorRepo,
    this.remoteNode,
    this.eventRepo,
  );

  @override
  Future<bool> sync() async {
    VersionVector local = versionVectorRepo.getVersionVector();
    RemoteState? remoteState = await remoteNode.getRemoteState(local);

    if (remoteState == null) {
      log.info("Состояние удаленного узла - null");
      return false;
    }

    VersionVector remote = remoteState.remoteVector;
    VersionVector diff = local.diff(remote);

    List<Event> missingEvents =  _getMissingLocalEvents(diff);

    bool sendSuccessful = await _sendLocalEvents(missingEvents);
    if (!sendSuccessful) {
      return false;
    }

    List<Event> remoteEvents = remoteState.missingEvents;
    eventRepo.saveEvents(remoteEvents);

    VersionVector merge = local.merge(remote);
    versionVectorRepo.saveVersionVector(merge);

    return true;
  }

  Future<bool> _sendLocalEvents(List<Event> events) async {
    int attempt = 0;
    while (attempt < MAX_NUMBER_ATTEMPTS) {
      try {
        await remoteNode.sendLocalEvents(events);
        return true;
      } on Exception catch (e) {
        log.error('Ошибка [$e]. При попытке $attempt отправить локальные события');
        attempt++;
      }
    }
    return false;
  }

  List<Event> _getMissingLocalEvents(VersionVector diff) {
    return diff.stamps.values
        .map(eventRepo.getEventsHappenAfter)
        .expand((e) => e)
        .toList();
  }
}
