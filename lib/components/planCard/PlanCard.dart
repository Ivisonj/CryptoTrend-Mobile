import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class PlanCard extends StatelessWidget {
  final String id;
  final String name;
  final int duration;
  final double currentPrice;
  final double? oldPrice;
  final int? discount;
  final VoidCallback onSubscribe;

  const PlanCard({
    super.key,
    required this.id,
    required this.name,
    required this.duration,
    required this.currentPrice,
    this.oldPrice,
    this.discount,
    required this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),

            Text(
              '${duration} ${duration == 1 ? 'mês' : 'meses'}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                // Preço atual
                Text(
                  'R\$ ${currentPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),

                // Badge de desconto (só aparece se há desconto)
                if (discount != null && discount! > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '-${discount}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Preço antigo (só aparece se há desconto)
            if (oldPrice != null)
              Text(
                'De R\$ ${oldPrice!.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red.shade600,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.red.shade600,
                  decorationThickness: 2,
                ),
              ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 35,
              child: ElevatedButton(
                onPressed: onSubscribe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Assinar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
