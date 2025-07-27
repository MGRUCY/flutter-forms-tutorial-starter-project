import 'package:flutter/material.dart';

class SearchBars extends StatelessWidget {
  const SearchBars({
    super.key,
    required this.onChanged,
    required this.onSortPressed,
  });

  final Function(String) onChanged;
  final VoidCallback onSortPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Search tasks...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.sort),
          tooltip: 'Sort by Priority',
          onPressed: onSortPressed,
        ),
      ],
    );
  }
}

