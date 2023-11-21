import 'package:RestoranApp/menu/drinks_models.dart';
import 'package:flutter/material.dart';

class DrinkCategories extends StatefulWidget {
  const DrinkCategories({
    Key? key,
    required this.onChanged,
    required this.selectedIndex,
  }) : super(key: key);

  final ValueChanged<int> onChanged;
  final int selectedIndex;

  @override
  State<DrinkCategories> createState() => _DrinkCategoriesState();
}

class _DrinkCategoriesState extends State<DrinkCategories> {
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
  void didUpdateWidget(covariant DrinkCategories oldWidget) {
    _controller.animateTo(
      80.0 * widget.selectedIndex,
      curve: Curves.ease,
      duration: const Duration(milliseconds: 200),
    );
    super.didUpdateWidget(oldWidget);
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
