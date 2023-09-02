import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dio/dio.dart';
import 'package:training_project/screens/ProductDetailsPage.dart';

class PopularProducts extends StatefulWidget {
  @override
  State<PopularProducts> createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
  var jsonList = []; // Corrected variable name

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    try {
      var response = await Dio().get('https://dummyjson.com/products');

      if (response.statusCode == 200) {
        setState(() {
          jsonList = response.data["products"] as List;
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return jsonList.isNotEmpty
        ? Container(
      height: 250, // Adjust the height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: jsonList.length, // Corrected variable name
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              left: (20 / 375.0) * MediaQuery.of(context).size.width,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductDetailsPage(product: jsonList[index]), // Corrected variable name
                  ),
                );
              },
              child: SizedBox(
                width:
                (140 / 375.0) * MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.02,
                      child: Container(
                        padding: EdgeInsets.all(
                          (20 / 375.0) * MediaQuery.of(context).size.width,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF979797).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.network(
                          jsonList[index]['images'][0] ??
                              "https://i.dummyjson.com/data/products/1/1.jpg",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      jsonList[index]["title"],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      maxLines: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${jsonList[index]["price"].toString()}",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 184, 96, 56),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    )
        : Center(
      child: CircularProgressIndicator(color: Colors.black12),
    );
  }
}
