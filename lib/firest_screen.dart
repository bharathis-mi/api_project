import 'dart:convert';

import 'package:api_project/model/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  late Future<List<Product>> futureproduct;
  @override
  void initState() {
    futureproduct = getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Product>>(
      future: futureproduct,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Product> data = snapshot.data!;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.8),
            itemBuilder: (context, index) => Card(
              margin: EdgeInsets.all(2.5),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.network(
                      data[index].image,
                      height: 100,
                    ),
                    Text(
                      data[index].title,
                      textScaleFactor: 0.9,
                      maxLines: 2,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data[index].description,
                      textScaleFactor: 0.6,
                      maxLines: 2,
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    Text(
                      '\$ ${data[index].price}',
                      textScaleFactor: 0.9,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    FilledButton(onPressed: () {}, child: Text('Add'))
                  ],
                ),
              ),
            ),
            itemCount: data.length,
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    ));
  }
}

Future<List<Product>> getProducts() async {
  var response =
      await http.get(Uri.parse('https://fakestoreapi.com/products/'));
  var data = jsonDecode(response.body);
  return List.from(data.map((e) => Product.fromMap(e)));
}
