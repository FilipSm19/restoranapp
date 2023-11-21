import 'package:RestoranApp/menu/food_categories.dart';
import 'package:RestoranApp/menu/food_models.dart';
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
      child: FoodCategories(
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

class Foods extends StatefulWidget {
  const Foods({super.key});

  @override
  State<Foods> createState() => _FoodsState();
}

class _FoodsState extends State<Foods> {
  List<CategoryFoods> categoryFoods = [];

  final CollectionReference foodsRef =
      FirebaseFirestore.instance.collection('food');

  getStream() async {
    for (var i = 0; i < categories.length; i++) {
      List dataList = [];
      var data =
          await foodsRef.where('category', isEqualTo: categories[i]).get();
      dataList = data.docs;
      List<Food> items = [];
      for (var i = 0; i < dataList.length; i++) {
        items.add(Food(
            title: dataList[i]['name'],
            price: dataList[i]['price'],
            ingredients: dataList[i]['ingredients']));
      }
      categoryFoods.add(CategoryFoods(category: categories[i], items: items));
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
        totalItems += categoryFoods[i].items.length;
      }
      scrollController.animateTo(totalItems * 64 + 64 * index,
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
    int firstBreakPoint = (112 * categoryFoods[0].items.length);
    breakPoints.add(firstBreakPoint);
    for (var i = 1; i < categoryFoods.length; i++) {
      int breakPoint =
          breakPoints.last + (64 + 58 * categoryFoods[i].items.length);
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
    if (categoryFoods.isEmpty) {
      return Scaffold(
          appBar: AppBar(title: const Text('Hrana')),
          body: const Center(
            child: CircularProgressIndicator(),
          ));
    }
    return Scaffold(
        body: CustomScrollView(
      controller: scrollController,
      slivers: [
        const SliverAppBar(title: Text('Hrana'), pinned: true),
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
                List<Food> items = categoryFoods[categoryIndex].items;
                return FoodsCategory(
                    title: categoryFoods[categoryIndex].category,
                    items: List.generate(
                        items.length,
                        (index) => Padding(
                              padding: const EdgeInsets.only(bottom: 14.0),
                              child: FoodCard(
                                title: items[index].title,
                                price: items[index].price,
                                ingredients: items[index].ingredients,
                              ),
                            )));
              },
              childCount: categoryFoods.length,
            ),
          ),
        ),
        SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: kFloatingActionButtonMargin +
                      MediaQuery.of(context).size.height -
                      400),
            )),
      ],
    ));
  }
}
