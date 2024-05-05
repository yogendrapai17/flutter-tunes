import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tunes/app/app_colors.dart';
import 'package:flutter_tunes/app/bloc/app_bloc.dart';

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
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        const Row(
          children: [
            SizedBox(width: 16),
            Text(
              "Search your favourite song here ",
              style: TextStyle(
                  fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
            ),
            Icon(Icons.keyboard_double_arrow_right_outlined)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _widthAnimation!.value,
              child: TextField(
                focusNode: _focusNode,
                decoration: const InputDecoration(
                  hintText: "Search Title, Artist, Year, Genre ...",
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (val) {
                  BlocProvider.of<AppBloc>(context)
                      .add(SearchSongEvent(searchKey: val.trim()));
                },
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
