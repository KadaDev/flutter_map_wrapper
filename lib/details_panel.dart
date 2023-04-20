import 'package:flutter/material.dart';

class DetailsPanel extends StatelessWidget {
  const DetailsPanel({
    super.key,
    required this.title,
    this.content,
    this.leading,
    this.onTap,
    this.trailing,
    this.margin,
  });

  final Widget title;
  final Widget? leading;
  final Widget? trailing;
  final Widget? content;
  final VoidCallback? onTap;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final cardContent = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: content == null
              ? const EdgeInsets.all(16.0)
              : const EdgeInsets.all(16.0).copyWith(bottom: 8.0),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: DefaultTextStyle(
                    style: Theme.of(context).textTheme.titleLarge!,
                    child: title,
                  ),
                ),
                if (trailing != null) ...[const SizedBox(width: 8), trailing!],
              ],
            ),
          ),
        ),
        if (content != null)
          Padding(
            padding: const EdgeInsets.all(16.0).copyWith(top: 0.0),
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyMedium!,
              child: content!,
            ),
          ),
      ],
    );

    final theme = Theme.of(context);
    final cardTheme = theme.cardTheme.copyWith(
      clipBehavior: Clip.antiAlias,
      shape: theme.cardTheme.shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
    );

    EdgeInsetsGeometry margin =
        this.margin ?? theme.cardTheme.margin ?? const EdgeInsets.all(8.0);
    final mq = MediaQuery.of(context);
    margin = margin.clamp(
      mq.padding.copyWith(top: 0),
      const EdgeInsets.all(double.infinity),
    );

    return Theme(
      data: theme.copyWith(
        cardTheme: cardTheme,
      ),
      child: Card(
        margin: margin,
        child: MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          removeLeft: true,
          removeRight: true,
          child: onTap != null
              ? InkWell(
                  onTap: onTap,
                  child: cardContent,
                )
              : cardContent,
        ),
      ),
    );
  }
}
