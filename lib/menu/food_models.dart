import 'package:flutter/material.dart';

class Food {
  final String title;
  final num price;
  final String ingredients;

  Food({required this.title, required this.price, required this.ingredients});
}

class CategoryFoods {
  final String category;
  final List<Food> items;

  CategoryFoods({required this.category, required this.items});
}

List categories = ['Mesna jela', 'Grill', 'Riblja jela', 'Pizze', 'Deserti'];

class FoodsCategory extends StatelessWidget {
  const FoodsCategory({
    Key? key,
    required this.title,
    required this.items,
  }) : super(key: key);

  final String title;
  final List items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Divider(),
        ...items,
      ],
    );
  }
}

class FoodCard extends StatelessWidget {
  const FoodCard(
      {Key? key,
      required this.title,
      required this.price,
      required this.ingredients})
      : super(key: key);

  final String title;
  final num price;
  final String ingredients;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          height: 6,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DefaultTextStyle(
            style: const TextStyle(color: Colors.black54),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "$price €",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF22A45D),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 70),
                  child: Ingredients(ingredients: ingredients),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class Ingredients extends StatelessWidget {
  const Ingredients({Key? key, required this.ingredients}) : super(key: key);
  final String ingredients;
  @override
  Widget build(BuildContext context) {
    if (ingredients.length < 53) {
      return Text("($ingredients)\n",
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ));
    } else {
      return Text("($ingredients)",
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ));
    }
  }
}
