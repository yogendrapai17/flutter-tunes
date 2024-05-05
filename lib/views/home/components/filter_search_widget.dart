import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tunes/app/bloc/app_bloc.dart';
import 'package:flutter_tunes/common/widgets/animated_search_bar.dart';
import 'package:flutter_tunes/common/widgets/filter_chip_widget.dart';

class FilterSearchWidget extends StatelessWidget {
  const FilterSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        BlocSelector<AppBloc, AppState, List<String>>(
          selector: (state) {
            return state.filters;
          },
          builder: (context, filterList) {
            final bloc = BlocProvider.of<AppBloc>(context);
            return SizedBox(
              width: screenSize * 0.75,
              height: 60,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  const SizedBox(width: 12),
                  GenreFilterChip(
                    text: 'Techno',
                    isEnabled: filterList.contains('Techno'),
                    onSelected: () {
                      bloc.add(ToggleFilterEvent(filter: 'Techno'));
                    },
                  ),
                  const SizedBox(width: 8),
                  GenreFilterChip(
                    text: 'DnB',
                    isEnabled: filterList.contains('DnB'),
                    onSelected: () {
                      bloc.add(ToggleFilterEvent(filter: 'DnB'));
                    },
                  ),
                  const SizedBox(width: 8),
                  GenreFilterChip(
                    text: 'Progressive House',
                    isEnabled: filterList.contains('Progressive House'),
                    onSelected: () {
                      bloc.add(ToggleFilterEvent(filter: 'Progressive House'));
                    },
                  ),
                  const SizedBox(width: 8),
                  GenreFilterChip(
                    text: 'Electronic Pop',
                    isEnabled: filterList.contains('Electronic Pop'),
                    onSelected: () {
                      bloc.add(ToggleFilterEvent(filter: 'Electronic Pop'));
                    },
                  ),
                ],
              ),
            );
          },
        ),
        const AnimatedSearchBar(),
        const SizedBox(width: 8),
      ],
    );
  }
}
