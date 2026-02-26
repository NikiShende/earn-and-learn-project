import 'package:flutter/material.dart';

class WorkRequestCard extends StatelessWidget {
  final Map<String, dynamic> workData;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const WorkRequestCard({
    super.key,
    required this.workData,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final hours = workData["hours"] ?? 0;
    final date = workData["date"] ?? "-";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            workData["title"] ?? "Work Title",
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(Icons.person, size: 18),
              const SizedBox(width: 8),
              Text(workData["name"] ?? ""),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(Icons.access_time, size: 18),
              const SizedBox(width: 8),
              Text("$hours hours"),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(Icons.calendar_today, size: 18),
              const SizedBox(width: 8),
              Text(date),
            ],
          ),

          const SizedBox(height: 12),

          if (onApprove != null || onReject != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onApprove != null)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green),
                    onPressed: onApprove,
                    child: const Text("Approve"),
                  ),
                const SizedBox(width: 10),
                if (onReject != null)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red),
                    onPressed: onReject,
                    child: const Text("Reject"),
                  ),
              ],
            ),
        ],
      ),
    );
  }
  // ================= ACTION BUTTON =================
Widget actionButton({
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(.3)),
      ),
      child: Icon(icon, color: color),
    ),
  );
}
}
