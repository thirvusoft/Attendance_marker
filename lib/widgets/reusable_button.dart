import 'package:flutter/material.dart';

class CustomFormButton extends StatefulWidget {
  final String innerText;
  final Color backgroundColor;
  final void Function()? onPressed;

  const CustomFormButton({
    Key? key,
    required this.innerText,
    required this.onPressed,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  _CustomFormButtonState createState() => _CustomFormButtonState();
}

class _CustomFormButtonState extends State<CustomFormButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addListener(() {
      setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      height: size.height / 14,
      child: InkResponse(
        onTap: () {
          _controller.forward();
          widget.onPressed?.call();
        },
        child: ScaleTransition(
          scale: _animation,
          child: Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                widget.innerText,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
