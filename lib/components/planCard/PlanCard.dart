import 'package:flutter/material.dart';

class PlanCard extends StatelessWidget {
  final String planName;
  final String duration;
  final String currentPrice;
  final String oldPrice;
  final String discount;
  final VoidCallback onSubscribe;

  const PlanCard({
    super.key,
    required this.planName,
    required this.duration,
    required this.currentPrice,
    required this.oldPrice,
    required this.discount,
    required this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade700),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título do plano
            Text(
              planName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),

            // Duração do plano
            Text(
              duration,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            // Row com preço atual e desconto
            Row(
              children: [
                // Preço atual
                Text(
                  currentPrice,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),

                // Badge de desconto
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
                    '-$discount',
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

            // Preço antigo (riscado)
            Text(
              'De $oldPrice',
              style: TextStyle(
                fontSize: 14,
                color: Colors.red.shade600,
                decoration: TextDecoration.lineThrough,
                decorationColor: Colors.red.shade600,
                decorationThickness: 2,
              ),
            ),
            const SizedBox(height: 20),

            // Botão de assinar
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
