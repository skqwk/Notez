import 'package:notez/crdt/versionvector/version_vector.dart';

abstract class VersionVectorRepo {
  VersionVector getVersionVector();

  void saveVersionVector(VersionVector versionVector);
}

class InMemoryVersionVectorRepo implements VersionVectorRepo {
  VersionVector? vector;

  @override
  VersionVector getVersionVector() {
    return vector!;
  }

  @override
  void saveVersionVector(VersionVector versionVector) {
    vector = versionVector;
  }
}