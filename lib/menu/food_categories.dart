import 'package:RestoranApp/menu/food_models.dart';
import 'package:flutter/material.dart';

class FoodCategories extends StatefulWidget {
  const FoodCategories({
    Key? key,
    required this.onChanged,
    required this.selectedIndex,
  }) : super(key: key);

  final ValueChanged<int> onChanged;
  final int selectedIndex;

  @override
  State<FoodCategories> createState() => _FoodCategoriesState();
}

class _FoodCategoriesState extends State<FoodCategories> {
  late ScrollController _controller;
  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              categories.length,
              (index) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: TextButton(
                  onPressed: () {
                    widget.onChanged(index);
                  },
                  style: TextButton.styleFrom(
                      foregroundColor: widget.selectedIndex == index
                          ? Colors.black
                          : Colors.black45),
                  child: Text(
                    categories[index],
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ),
        const Expanded(child: Divider())
      ],
    );
  }
}
