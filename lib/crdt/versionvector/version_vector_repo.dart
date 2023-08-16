import 'package:notez/crdt/versionvector/version_vector.dart';

abstract class VersionVectorRepo {
  VersionVector getVersionVector();

  void saveVersionVector(VersionVector versionVector);
}