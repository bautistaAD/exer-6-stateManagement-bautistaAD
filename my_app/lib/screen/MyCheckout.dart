import 'package:flutter/material.dart';
import '../model/Item.dart';
import 'package:provider/provider.dart';
import '../provider/shoppingcart_provider.dart';

class MyCheckout extends StatefulWidget {
  const MyCheckout({super.key});

  @override
  State<MyCheckout> createState() => _MyCheckoutState();
}

class _MyCheckoutState extends State<MyCheckout> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Item Details"),
          const Divider(height: 4, color: Colors.black),
          getItems(context),
          const Divider(height: 4, color: Colors.black),
          computeCost(),
          Flexible(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<ShoppingCart>().removeAll();
                      Navigator.pushNamed(context, "/products");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Payment Successful!"),
                          duration: const Duration(seconds: 1, milliseconds: 100),
                        ),
                      );
                    },
                    child: const Text("Pay Now!"),
                  ),
                ],
              ),
            ),
          )
        ]
      ),
    );
  }

  Widget computeCost() {

    return Consumer<ShoppingCart>(builder: (context, cart, child) {
    return Text("Total: ${cart.cartTotal} ");
    });
  }

  Widget getItems(BuildContext context) {
    List<Item> products = context.watch<ShoppingCart>().cart;
    String productName = "";
      return products.isEmpty
          ? const Text('No Items yet!')
          : Expanded(
              child: Column(
                children: [
                  Flexible(
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(products[index].name),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              productName = products[index].name;
                              context.read<ShoppingCart>().removeItem(productName);
                              if (products.isNotEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("$productName removed!"),
                                    duration: const Duration(seconds: 1, milliseconds: 100),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Cart Empty!"),
                                    duration: Duration(seconds: 1, milliseconds: 100),
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
  }
}
