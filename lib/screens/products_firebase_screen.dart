import 'package:flutter/material.dart';
import 'package:pmsn2024/services/products_firebase.dart';

class ProductsFirebaseScreen extends StatefulWidget {
  const ProductsFirebaseScreen({super.key});

  @override
  State<ProductsFirebaseScreen> createState() => _ProductsFirebaseStateScreen();
}

class _ProductsFirebaseStateScreen extends State<ProductsFirebaseScreen> {
  final productsFirebase = ProductsFirebase();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: StreamBuilder(
        stream: productsFirebase.consultar(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(itemBuilder: (context, index) {
              return Image.network(snapshot.data!.docs[index].get('imagen'));
            });
          } else {
            if (snapshot.hasError) {
              return Text('Ocurrio un error');
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
        },
      ),
    );
  }
}
