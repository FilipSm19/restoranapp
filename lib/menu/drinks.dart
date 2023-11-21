import 'package:RestoranApp/menu/drinks_categories.dart';
import 'package:RestoranApp/menu/drinks_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RestoranCategories extends SliverPersistentHeaderDelegate {
  final ValueChanged<int> onChanged;
  final int selectedIndex;
  RestoranCategories({required this.onChanged, required this.selectedIndex});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color.fromARGB(255, 248, 252, 218),
      height: 52,
      child: DrinkCategories(
        onChanged: onChanged,
        selectedIndex: selectedIndex,
      ),
    );
  }

  @override
  double get maxExtent => 52;

  @override
  double get minExtent => 52;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class Drinks extends StatefulWidget {
  const Drinks({super.key});

  @override
  State<Drinks> createState() => _DrinksState();
}

class _DrinksState extends State<Drinks> {
  List<CategoryDrinks> categoryDrinks = [];

  final CollectionReference drinksRef =
      FirebaseFirestore.instance.collection('drinks');

  getStream() async {
    for (var i = 0; i < categories.length; i++) {
      List dataList = [];
      var data =
          await drinksRef.where('category', isEqualTo: categories[i]).get();
      dataList = data.docs;
      List<Drink> items = [];
      for (var i = 0; i < dataList.length; i++) {
        items.add(
            Drink(title: dataList[i]['name'], price: dataList[i]['price']));
      }
      categoryDrinks.add(CategoryDrinks(category: categories[i], items: items));
    }

    setState(() {
      createBreakPoints();
    });
  }

  final scrollController = ScrollController();
  int selectedCategoryIndex = 0;

  void scrollToCategory(int index) {
    if (selectedCategoryIndex != index) {
      double totalItems = 0;
      for (var i = 0; i < index; i++) {
        totalItems += categoryDrinks[i].items.length;
      }
      scrollController.animateTo(totalItems * 35 + index * 60,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
      setState(
        () {
          selectedCategoryIndex = index;
        },
      );
    }
  }

  @override
  void initState() {
    getStream();
    scrollController.addListener(() {
      updateCategoryIndex(scrollController.offset);
    });
    super.initState();
  }

  List<int> breakPoints = [];
  void createBreakPoints() {
    int firstBreakPoint = (35 * categoryDrinks[0].items.length + 56);
    breakPoints.add(firstBreakPoint);
    for (var i = 1; i < categoryDrinks.length; i++) {
      int breakPoint =
          breakPoints.last + (36 * categoryDrinks[i].items.length + 56);
      breakPoints.add(breakPoint);
    }
  }

  void updateCategoryIndex(double offset) {
    for (var i = 0; i < categories.length; i++) {
      if (i == 0) {
        if ((offset < breakPoints.first) & (selectedCategoryIndex != 0)) {
          setState(() {
            selectedCategoryIndex = 0;
          });
        }
      } else if ((breakPoints[i - 1] <= offset) & (offset < breakPoints[i])) {
        if (selectedCategoryIndex != i) {
          setState(() {
            selectedCategoryIndex = i;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (categoryDrinks.isEmpty) {
      return Scaffold(
          appBar: AppBar(title: const Text('Piće')),
          body: const Center(
            child: CircularProgressIndicator(),
          ));
    }
    return Scaffold(
        body: CustomScrollView(
      controller: scrollController,
      slivers: [
        const SliverAppBar(title: Text('Piće'), pinned: true),
        SliverPersistentHeader(
          delegate: RestoranCategories(
              onChanged: scrollToCategory,
              selectedIndex: selectedCategoryIndex),
          pinned: true,
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, categoryIndex) {
                List<Drink> items = categoryDrinks[categoryIndex].items;
                return DrinksCategory(
                    title: categoryDrinks[categoryIndex].category,
                    items: List.generate(
                        items.length,
                        (index) => Padding(
                              padding: const EdgeInsets.only(bottom: 14.0),
                              child: DrinkCard(
                                title: items[index].title,
                                price: items[index].price,
                              ),
                            )));
              },
              childCount: categoryDrinks.length,
            ),
          ),
        ),
        SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: kFloatingActionButtonMargin +
                      MediaQuery.of(context).size.height -
                      340),
            ))
      ],
    ));
  }
}
