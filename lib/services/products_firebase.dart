import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsFirebase {
  final firestore = FirebaseFirestore.instance;
  CollectionReference? _productsCollection;

  ProductsFirebase() {
    _productsCollection = firestore.collection('productos');
  }

  Stream<QuerySnapshot>? consultar() {
    return _productsCollection?.snapshots();
  }

  Future<void> insertar(Map<String, dynamic> data) async {
    return _productsCollection?.doc().set(data);
  }

  Future<void> actualziar(Map<String, dynamic> data, String id) async {
    return _productsCollection?.doc(id).update(data);
  }

  Future<void> eliminar(String id) async {
    return _productsCollection?.doc(id).delete();
  }
}
