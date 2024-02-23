import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pmsn2024/database/products_database.dart';
import 'package:pmsn2024/model/products_model.dart';

class DespensaScreen extends StatefulWidget {
  const DespensaScreen({super.key});

  @override
  State<DespensaScreen> createState() => _DespensaScreenState();
}

class _DespensaScreenState extends State<DespensaScreen> {
  ProductsDatabase? productsDB;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productsDB = new ProductsDatabase();
  }

  @override
  Widget build(BuildContext context) {
    final conNombre = TextEditingController();
    final conCantidad = TextEditingController();
    final conFecha = TextEditingController();

    final txtNombre = TextFormField(
      keyboardType: TextInputType.text,
      controller: conNombre,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );

    final txtCantidad = TextFormField(
      keyboardType: TextInputType.number,
      controller: conCantidad,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );

    final space = SizedBox(
      height: 10,
    );

    final txtFecha = TextFormField(
      controller: conFecha,
      decoration: const InputDecoration(border: OutlineInputBorder()),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101));

        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(
              pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
          setState(() {
            conFecha.text =
                formattedDate; //set foratted date to TextField value.
          });
        } else {
          print("Date is not selected");
        }
      },
    );
    final btnAgregar = ElevatedButton.icon(
        onPressed: () {
          productsDB!.INSERTAR({
            "nomProducto": conNombre.text,
            "canProducto": int.parse(conCantidad.text),
            "fechaCaducidad": conFecha.text
          }).then((value) {
            Navigator.pop(context);
            String msj = "";
            if (value > 0) {
              msj = 'Producto Insertado';
            } else {
              msj = "Valio verga .l.";
            }

            var snackbar = SnackBar(content: Text(msj));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          });
        },
        icon: Icon(Icons.save),
        label: Text('Guardar'));
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Despensa :)'),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return ListView(
                        padding: EdgeInsets.all(10),
                        children: [
                          txtNombre,
                          space,
                          txtCantidad,
                          space,
                          txtFecha,
                          space,
                          btnAgregar
                        ],
                      );
                    });
              },
              icon: Icon(Icons.shopping_bag_rounded))
        ],
      ),
      body: FutureBuilder(
          future: productsDB!.CONSULTAR(),
          builder: (context, AsyncSnapshot<List<ProductosModel>> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Algo salio mal! :('),
              );
            } else {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return itemDespensa(snapshot.data![index]);
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }
          }),
    );
  }

  Widget itemDespensa(ProductosModel producto) {
    return Container(
      height: 100,
      child: Column(
        children: [
          Text('${producto.nomProducto!}'),
          Text('${producto.canProducto}!'),
          Text('${producto.fechaCaducidad}!'),
        ],
      ),
    );
  }
}
