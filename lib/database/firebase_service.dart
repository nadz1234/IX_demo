import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ix_app_demo/models/imageModel.dart';

class FirebaseService {
  static final FirebaseService _firestoreService = FirebaseService._internal();
  FirebaseFirestore _db = FirebaseFirestore.instance;

  FirebaseService._internal();

  factory FirebaseService() {
    return _firestoreService;
  }

  Future<void> addToOurDb(String url, String views, String likes) async {
    return await _db
        .collection('images')
        .doc()
        .set({'image_url': url, 'likes': likes, 'views': views});
  }

  Future<void> fetch() {
    return _db.collection('images').get();
  }

  Stream<List<ImageModel>> getItems() {
    return _db.collection('images').snapshots().map((snapshot) => snapshot.docs
        .map(
          (doc) => ImageModel.fromMap(doc.data(), doc.id),
        )
        .toList());
  }

  Future<void> deleteImage(String id) {
    return _db.collection('images').doc(id).delete();
  }
}
