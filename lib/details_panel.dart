import 'package:flutter/material.dart';

class DetailsPanel extends StatelessWidget {
  const DetailsPanel({
    Key? key,
    required this.title,
    this.content,
    this.leading,
    this.onTap,
    this.trailing,
    this.margin,
  }) : super(key: key);

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
                    style: Theme.of(context).textTheme.headline6!,
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
              style: Theme.of(context).textTheme.bodyText2!,
              child: content!,
            ),
          ),
      ],
    );

    final theme = Theme.of(context);
    final cardTheme = theme.cardTheme.copyWith(
      margin: margin ?? theme.cardTheme.margin ?? const EdgeInsets.all(8.0),
      clipBehavior: Clip.antiAlias,
      shape: theme.cardTheme.shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
    );
    return Theme(
      data: theme.copyWith(
        cardTheme: cardTheme,
      ),
      child: Card(
        child: onTap != null
            ? InkWell(
                onTap: onTap,
                child: cardContent,
              )
            : cardContent,
      ),
    );
  }
}
