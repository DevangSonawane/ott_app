import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/content_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/app_image.dart';
import '../widgets/for_user_header.dart';
import '../widgets/profile_menu_button.dart';

class LiveNewsScreen extends ConsumerStatefulWidget {
  const LiveNewsScreen({super.key});

  @override
  ConsumerState<LiveNewsScreen> createState() => _LiveNewsScreenState();
}

class _LiveNewsScreenState extends ConsumerState<LiveNewsScreen>
    with TickerProviderStateMixin {
  late final TabController _categoryController =
      TabController(length: _categories.length, vsync: this);
  late final AnimationController _tickerController =
      AnimationController(vsync: this, duration: const Duration(seconds: 12))
        ..repeat();

  static const _categories = <_NewsCategory>[
    _NewsCategory(id: 'feed', label: 'My Feed', isLive: false),
    _NewsCategory(id: 'daily', label: 'Daily Ritual', isLive: false),
    _NewsCategory(id: 'finance', label: 'Finance', isLive: false),
    _NewsCategory(id: 'war', label: 'Israel-Iran War', isLive: true),
    _NewsCategory(id: 'sports', label: 'Sports', isLive: false),
    _NewsCategory(id: 'tech', label: 'Tech', isLive: false),
  ];

  static const _items = <_NewsItem>[
    _NewsItem(
      id: 'n1',
      categoryId: 'feed',
      source: 'Chandigarh Tribune',
      author: 'Shalini Ojha',
      timeAgo: '1 day ago',
      title:
          "Instagram reel saves woman's life after 15 killed in boat tragedy in Vrindavan",
      summary:
          "A 55-year-old woman survived a tragedy in Vrindavan after a boat capsized. She followed what she saw on an Instagram Reel and didn't drown.",
      image:
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1400&q=60',
    ),
    _NewsItem(
      id: 'n2',
      categoryId: 'finance',
      source: 'Market Wire',
      author: 'Desk',
      timeAgo: '3 hr ago',
      title: 'Markets end higher as tech shares rally',
      summary:
          'Major indices closed in the green, led by gains in large-cap tech and renewed optimism around earnings.',
      image:
          'https://images.unsplash.com/photo-1526304640581-d334cdbbf45e?auto=format&fit=crop&w=1400&q=60',
    ),
    _NewsItem(
      id: 'n3',
      categoryId: 'war',
      source: 'World News',
      author: 'Bureau',
      timeAgo: '55 min ago',
      title: 'Fresh updates emerge as tensions rise overnight',
      summary:
          'Officials issued new statements as developments continued across the region. Live updates are ongoing.',
      image:
          'https://images.unsplash.com/photo-1521747116042-5a810fda9664?auto=format&fit=crop&w=1400&q=60',
    ),
    _NewsItem(
      id: 'n4',
      categoryId: 'sports',
      source: 'Sports Desk',
      author: 'Staff',
      timeAgo: '2 hr ago',
      title: 'Late goal seals dramatic win in derby',
      summary:
          'A last-minute strike decided the match, capping off an intense night with end-to-end action.',
      image:
          'https://images.unsplash.com/photo-1521412644187-c49fa049e84d?auto=format&fit=crop&w=1400&q=60',
    ),
    _NewsItem(
      id: 'n5',
      categoryId: 'tech',
      source: 'Tech Brief',
      author: 'Editor',
      timeAgo: '4 hr ago',
      title: 'New AI features roll out to popular apps',
      summary:
          'Several consumer apps announced new features aimed at productivity and personalization, shipping this week.',
      image:
          'https://images.unsplash.com/photo-1518779578993-ec3579fee39f?auto=format&fit=crop&w=1400&q=60',
    ),
    _NewsItem(
      id: 'n6',
      categoryId: 'daily',
      source: 'Wellness Today',
      author: 'Team',
      timeAgo: '8 hr ago',
      title: 'Simple routine changes that improve sleep quality',
      summary:
          'Experts share small, consistent habits that can help improve your sleep and energy throughout the day.',
      image:
          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1400&q=60',
    ),
  ];

  @override
  void dispose() {
    _categoryController.dispose();
    _tickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top + 10;
    final bottomPadding = MediaQuery.of(context).padding.bottom + 120;
    final profileName =
        ref.watch(contentProvider.select((s) => s.selectedProfile?.name)) ??
            'You';

    final selectedCategory = _categories[_categoryController.index];
    final filtered = selectedCategory.id == 'feed'
        ? _items
        : _items.where((n) => n.categoryId == selectedCategory.id).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(0, topPadding, 0, bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(child: ForUserHeader(userName: profileName)),
                _iconButton(
                  context,
                  icon: Icons.cast_rounded,
                  onTap: () {},
                ),
                const SizedBox(width: 4),
                _iconButton(
                  context,
                  icon: Icons.file_download_outlined,
                  onTap: () {},
                ),
                const SizedBox(width: 4),
                _iconButton(
                  context,
                  icon: Icons.search_rounded,
                  onTap: () => context.go('/search?scope=news'),
                ),
                const SizedBox(width: 4),
                const ProfileMenuButton(),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 34,
            child: TabBar(
              controller: _categoryController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              dividerColor: Colors.transparent,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(color: AppColors.accentHover, width: 2.0),
                insets: EdgeInsets.symmetric(horizontal: 2),
              ),
              indicatorSize: TabBarIndicatorSize.label,
              labelPadding: const EdgeInsets.only(right: 16),
              labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.2,
                  ),
              unselectedLabelStyle:
                  Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
              labelColor: AppColors.textPrimary,
              unselectedLabelColor: AppColors.textSecondary,
              overlayColor:
                  WidgetStateProperty.all(Colors.white.withOpacity(0.06)),
              tabs: [
                for (final c in _categories)
                  Tab(child: _CategoryLabel(label: c.label, isLive: c.isLive)),
              ],
              onTap: (_) => setState(() {}),
            ),
          ),
          const SizedBox(height: 12),
          _LiveTicker(
            controller: _tickerController,
            label: 'LIVE',
            text:
                ' $profileName • Breaking updates across the world • Tap a card to read more  ',
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                for (final item in filtered) ...[
                  _NewsCard(item: item),
                  const SizedBox(height: 14),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: AppColors.textPrimary),
      ),
    );
  }
}

class _LiveTicker extends StatelessWidget {
  const _LiveTicker({
    required this.controller,
    required this.label,
    required this.text,
  });

  final AnimationController controller;
  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.9,
        );
    final tickerStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w700,
        );

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.18),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.redAccent.withOpacity(0.45)),
            ),
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(label, style: style),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final tp = TextPainter(
                  text: TextSpan(text: text, style: tickerStyle),
                  maxLines: 1,
                  textDirection: TextDirection.ltr,
                )..layout();
                final textWidth = tp.width;
                final boxWidth = constraints.maxWidth;
                return ClipRect(
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, _) {
                      final t = controller.value;
                      final dx =
                          (1 - t) * (boxWidth + textWidth) - textWidth;
                      return Transform.translate(
                        offset: Offset(dx, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(text, style: tickerStyle, maxLines: 1),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.item});

  final _NewsItem item;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          border: Border.all(color: AppColors.borderSubtle),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AppImage(
                  source: item.image,
                  width: double.infinity,
                  height: 320,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.zero,
                  placeholderBorderRadius: 0,
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.20),
                          Colors.black.withOpacity(0.72),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 6,
                  child: Row(
                    children: [
                      _overlayIcon(Icons.bookmark_border_rounded),
                      const SizedBox(width: 8),
                      _overlayIcon(Icons.share_outlined),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.summary,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.45,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${item.timeAgo} | ${item.author} | ${item.source}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _overlayIcon(IconData icon) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Icon(icon, size: 18, color: AppColors.textPrimary),
    );
  }
}

class _CategoryLabel extends StatelessWidget {
  const _CategoryLabel({required this.label, required this.isLive});

  final String label;
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    final text = Text(label, maxLines: 1, overflow: TextOverflow.ellipsis);
    if (!isLive) return text;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
            color: Colors.redAccent,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        text,
      ],
    );
  }
}

class _NewsCategory {
  const _NewsCategory({
    required this.id,
    required this.label,
    required this.isLive,
  });

  final String id;
  final String label;
  final bool isLive;
}

class _NewsItem {
  const _NewsItem({
    required this.id,
    required this.categoryId,
    required this.source,
    required this.author,
    required this.timeAgo,
    required this.title,
    required this.summary,
    required this.image,
  });

  final String id;
  final String categoryId;
  final String source;
  final String author;
  final String timeAgo;
  final String title;
  final String summary;
  final String image;
}
