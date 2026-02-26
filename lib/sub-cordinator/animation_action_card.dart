import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AnimatedActionCard extends StatefulWidget {
  final Widget child;
  final Future<void> Function()? onApprove;
  final Future<void> Function()? onReject;

  const AnimatedActionCard({
    super.key,
    required this.child,
    this.onApprove,
    this.onReject,
  });

  @override
  State<AnimatedActionCard> createState() =>
      _AnimatedActionCardState();
}

class _AnimatedActionCardState extends State<AnimatedActionCard>
    with SingleTickerProviderStateMixin {

  bool isProcessing = false;
  bool isSuccess = false;
  Color actionColor = Colors.green;

  late AnimationController _controller;
  late Animation<double> scaleAnim;
  late Animation<double> fadeAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    scaleAnim =
        Tween(begin: 1.0, end: 0.96).animate(_controller);

    fadeAnim =
        Tween(begin: 1.0, end: 0.0).animate(_controller);
  }

  /// ===== ACTION HANDLER =====
  Future<void> _handleAction(
      Future<void> Function()? action, Color color) async {
    if (action == null) return;

    setState(() {
      isProcessing = true;
      actionColor = color;
    });

    await Future.delayed(const Duration(milliseconds: 400));

    await action();

    setState(() {
      isSuccess = true;
    });

    await Future.delayed(const Duration(milliseconds: 700));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnim,
      child: ScaleTransition(
        scale: scaleAnim,
        child: Stack(
          alignment: Alignment.center,
          children: [

            /// MAIN CARD
            widget.child,

            /// SHIMMER LOADING
            if (isProcessing && !isSuccess)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.8),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(color: Colors.white),
                  ),
                ),
              ),

            /// SUCCESS TICK
            if (isSuccess)
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: actionColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 42,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// BUTTON BUILDERS
  Widget approveButton() => _actionBtn(
        icon: Icons.check,
        label: "Approve",
        color: Colors.green,
        onTap: () => _handleAction(widget.onApprove, Colors.green),
      );

  Widget rejectButton() => _actionBtn(
        icon: Icons.close,
        label: "Reject",
        color: Colors.red,
        onTap: () => _handleAction(widget.onReject, Colors.red),
      );

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(.12),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: color.withOpacity(.4)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}