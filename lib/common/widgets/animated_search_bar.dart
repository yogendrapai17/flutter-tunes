import 'package:flutter/material.dart';
import 'package:flutter_tunes/app/app_colors.dart';

class AnimatedSearchBar extends StatefulWidget {
  const AnimatedSearchBar({super.key});

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<double>? _widthAnimation;
  bool _isOpen = false;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final screenWidth = MediaQuery.of(context).size.width;

    _widthAnimation =
        Tween<double>(begin: 0, end: screenWidth * 0.75).animate(_controller);
  }

  void _toggleSearch() {
    if (_isOpen) {
      _controller.reverse().then((value) {
        setState(() {
          _isOpen = !_isOpen;
        });
      });
      _focusNode.unfocus();
    } else {
      _focusNode.requestFocus();
      _controller.forward().then((value) {
        setState(() {
          _isOpen = !_isOpen;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: _widthAnimation!.value,
          child: TextField(
            focusNode: _focusNode,
            decoration: const InputDecoration(
              hintText: 'Search...',
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        GestureDetector(
          onTap: _toggleSearch,
          child: Container(
            margin: const EdgeInsets.only(left: 16.0),
            height: 48.0,
            width: 48.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon((_isOpen) ? Icons.close : Icons.search,
                color: Colors.white, size: 28.0),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
