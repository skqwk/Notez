import 'package:notez/common/log.dart';
import 'package:notez/crdt/event/event.dart';
import 'package:notez/crdt/event/event_repo.dart';
import 'package:notez/crdt/sync/remote_node.dart';
import 'package:notez/crdt/versionvector/version_vector.dart';
import 'package:notez/crdt/versionvector/version_vector_repo.dart';

abstract class SyncService {
  void sync();
}

class SyncServiceImpl implements SyncService {
  final VersionVectorRepo versionVectorRepo;
  final EventRepo eventRepo;
  final RemoteNode remoteNode;

  SyncServiceImpl(
    this.versionVectorRepo,
    this.remoteNode,
    this.eventRepo,
  );

  @override
  void sync() {
    VersionVector local = versionVectorRepo.getVersionVector();
    RemoteState? remoteState = remoteNode.getRemoteState(local);

    if (remoteState == null) {
      log.info("Состояние удаленного узла - null");
      return;
    }

    VersionVector remote = remoteState.remoteVector;
    VersionVector diff = local.diff(remote);

    List<Event> missingEvents =  _getMissingLocalEvents(diff);
    remoteNode.sendLocalEvents(missingEvents);

    List<Event> remoteEvents = remoteState.missingEvents;
    eventRepo.saveEvents(remoteEvents);

    VersionVector merge = local.merge(remote);
    versionVectorRepo.saveVersionVector(merge);
  }

  List<Event> _getMissingLocalEvents(VersionVector diff) {
    return diff.stamps.values
        .map(eventRepo.getEventsHappenAfter)
        .expand((e) => e)
        .toList();
  }
}
