import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventCard extends StatefulWidget {
  final String name;
  final String route;

  const EventCard({required this.name, required this.route, Key? key})
      : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: () => Get.toNamed(widget.route),
        child: AnimatedScale(
          scale: _isHovering ? 1.05 : 1.0, // Slight zoom on hover
          duration: Duration(milliseconds: 200), // Smooth animation duration
          child: Container(
            // Container to hold the Card and provide the glowing border
            decoration: BoxDecoration(
              border: Border.all(
                color: _isHovering ? Colors.green : Colors.pink,
                width: _isHovering ? 2.5 : 1.5,
              ),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: _isHovering
                      ? Colors.green.withOpacity(0.5)
                      : Colors.pink.withOpacity(0.5),
                  spreadRadius: 0, // Set spread radius to 0 for a tight glow
                  blurRadius: 8,
                ),
              ],
            ),
            child: Card(
              elevation: _isHovering ? 8 : 4, // Elevation increases on hover
              margin: EdgeInsets.zero, // Remove margin for seamless look
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(8.0), // Match the border radius
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.name,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
