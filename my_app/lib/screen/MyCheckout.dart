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
    List<Item> products = context.watch<ShoppingCart>().cart;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Item Details"),
          const Divider(height: 4, color: Colors.black),
          getItems(context),
          
          if(products.isNotEmpty)
            const Divider(height: 4, color: Colors.black),
          
          if(products.isNotEmpty)
            computeCost(),
            
          if(products.isNotEmpty)
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
                          trailing: Text((products[index].price).toString()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
  }
}
