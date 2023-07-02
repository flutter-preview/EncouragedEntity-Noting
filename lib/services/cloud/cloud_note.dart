import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:noting/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String content;

  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.content,
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot):
    documentId = snapshot.id,
    ownerUserId = snapshot.data()[CloudConst.ownerUserIdFieldName],
    content = snapshot.data()[CloudConst.contentFieldName] as String;

}
