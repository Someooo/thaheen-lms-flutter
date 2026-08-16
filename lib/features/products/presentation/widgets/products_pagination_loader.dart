import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductsPaginationLoader extends StatelessWidget {
  final bool isLoadingMore;
  final bool hasMore;

  const ProductsPaginationLoader({
    super.key,
    required this.isLoadingMore,
    required this.hasMore,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoadingMore) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade50,
          child: Row(
            children: [
              Expanded(child: _PaginationShimmerCard()),
              const SizedBox(width: 12),
              Expanded(child: _PaginationShimmerCard()),
            ],
          ),
        ),
      );
    }

    if (!hasMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0),
        child: Center(
          child: Text(
            'All products loaded.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return const SizedBox(height: 50);
  }
}

class _PaginationShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const aspectRatio = 0.80;
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
