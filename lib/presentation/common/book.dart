import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final String? author;
  final List<String?>? authors;
  final VoidCallback onTap;
  final double? width;

  const BookCard({
    super.key,
    this.title,
    this.imageUrl,
    this.authors,
    this.author,
    required this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the hero tag. If imageUrl is present, use it as part of the tag,
    // otherwise fallback to title or random string. Ideally, pass ID.
    final heroTag = imageUrl ?? title ?? UniqueKey().toString();

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width ?? 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Hero(
                tag: heroTag,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl ?? '',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.book,
                          size: 40,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title ?? 'Unknown Title',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.2,
              ),
            ),
            if (author != null || (authors != null && authors!.isNotEmpty)) ...[
              const SizedBox(height: 4),
              Text(
                author ?? authors?.first ?? 'Unknown Author',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
