import 'package:flutter/material.dart';

class LikeToggleButton extends StatefulWidget {
  const LikeToggleButton({super.key});

  @override
  State<LikeToggleButton> createState() => _LikeToggleButtonState();
}

class _LikeToggleButtonState extends State<LikeToggleButton> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: _isLiked ? 'Unlike' : 'Like',
      onPressed: () {
        setState(() {
          _isLiked = !_isLiked;
        });
      },
      icon: Icon(
        _isLiked ? Icons.favorite : Icons.favorite_border,
        color: _isLiked ? Colors.red : Colors.grey,
      ),
    );
  }
}
