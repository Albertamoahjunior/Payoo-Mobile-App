import 'package:flutter/material.dart';

class CustomCategoryChip extends StatefulWidget {
  final String category;
  final double width;
  final double height;
  final Function(String) onSelected;

  CustomCategoryChip({
    required this.category,
    required this.width,
    required this.height,
    required this.onSelected,
  });

  @override
  _CustomCategoryChipState createState() => _CustomCategoryChipState();
}

class _CustomCategoryChipState extends State<CustomCategoryChip> {
  @override
  Widget build(BuildContext context) {
    final backgroundColor = Colors.primaries[widget.category.hashCode % Colors.primaries.length];

    return GestureDetector(
      onTap: () {
        widget.onSelected(widget.category);
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
        alignment: Alignment.center,
        child: Text(
          widget.category,
          style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.normal),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
