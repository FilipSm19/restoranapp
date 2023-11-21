import 'package:flutter/material.dart';

class Drink {
  final String title;
  final num price;

  Drink({required this.title, required this.price});
}

class CategoryDrinks {
  final String category;
  final List<Drink> items;

  CategoryDrinks({required this.category, required this.items});
}

List categories = ['Topli napitci', 'Sokovi', 'Pive', 'Alkoholna pića'];

class DrinksCategory extends StatelessWidget {
  const DrinksCategory({
    Key? key,
    required this.title,
    required this.items,
  }) : super(key: key);

  final String title;
  final List items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
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
            const SizedBox(
              height: 5,
            ),
            ...items,
          ],
        ),
      ],
    );
  }
}

class DrinkCard extends StatelessWidget {
  const DrinkCard({
    Key? key,
    required this.title,
    required this.price,
  }) : super(key: key);

  final String title;
  final num price;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          height: 5,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DefaultTextStyle(
            style: const TextStyle(color: Colors.black54),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
