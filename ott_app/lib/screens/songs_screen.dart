import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/content_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/app_image.dart';
import '../widgets/for_user_header.dart';
import '../widgets/profile_menu_button.dart';

class SongsScreen extends ConsumerStatefulWidget {
  const SongsScreen({super.key});

  @override
  ConsumerState<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends ConsumerState<SongsScreen> {
  int _selectedTabIndex = 0;
  int _selectedModeIndex = 0;

  static const _modes = <String>[
    'All',
    'Music',
    'Podcasts',
    'Radio',
    'Live',
  ];

  static const _tabs = <_MusicTab>[
    _MusicTab(
      name: 'Arijit',
      image:
          'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?auto=format&fit=crop&w=240&q=60',
    ),
    _MusicTab(
      name: 'Rahman',
      image:
          'https://images.unsplash.com/photo-1511379938547-c1f69419868d?auto=format&fit=crop&w=240&q=60',
    ),
    _MusicTab(
      name: 'Lo-fi',
      image:
          'https://images.unsplash.com/photo-1510915228340-29c85a43dcfe?auto=format&fit=crop&w=240&q=60',
    ),
    _MusicTab(
      name: 'Workout',
      image:
          'https://images.unsplash.com/photo-1526401281623-34255be78a9c?auto=format&fit=crop&w=240&q=60',
    ),
    _MusicTab(
      name: 'Indie',
      image:
          'https://images.unsplash.com/photo-1519999482648-25049ddd37b1?auto=format&fit=crop&w=240&q=60',
    ),
    _MusicTab(
      name: 'Party',
      image:
          'https://images.unsplash.com/photo-1524368535928-5b5e00ddc76b?auto=format&fit=crop&w=240&q=60',
    ),
    _MusicTab(
      name: 'Romance',
      image:
          'https://images.unsplash.com/photo-1512290923902-8a9f81dc236c?auto=format&fit=crop&w=240&q=60',
    ),
    _MusicTab(
      name: 'Focus',
      image:
          'https://images.unsplash.com/photo-1453738773917-9c3eff1db985?auto=format&fit=crop&w=240&q=60',
      ),
  ];

  static const _recents = <_SongItem>[
    _SongItem(
      title: 'Kesariya',
      artist: 'Arijit Singh',
      image:
          'https://images.unsplash.com/photo-1511379938547-c1f69419868d?auto=format&fit=crop&w=320&q=60',
    ),
    _SongItem(
      title: 'Pasoori',
      artist: 'Ali Sethi, Shae Gill',
      image:
          'https://images.unsplash.com/photo-1520975869018-eaf6c7c1a4d7?auto=format&fit=crop&w=320&q=60',
    ),
    _SongItem(
      title: 'Blinding Lights',
      artist: 'The Weeknd',
      image:
          'https://images.unsplash.com/photo-1510915228340-29c85a43dcfe?auto=format&fit=crop&w=320&q=60',
    ),
    _SongItem(
      title: 'Do I Wanna Know?',
      artist: 'Arctic Monkeys',
      image:
          'https://images.unsplash.com/photo-1485579149621-3123dd979885?auto=format&fit=crop&w=320&q=60',
    ),
    _SongItem(
      title: 'Heeriye',
      artist: 'Jasleen Royal',
      image:
          'https://images.unsplash.com/photo-1512290923902-8a9f81dc236c?auto=format&fit=crop&w=320&q=60',
    ),
  ];

  static const _topMixes = <_TopMix>[
    _TopMix(
      name: 'Daily Mix 1',
      image:
          'https://images.unsplash.com/photo-1520975869018-eaf6c7c1a4d7?auto=format&fit=crop&w=420&q=60',
    ),
    _TopMix(
      name: 'Daily Mix 2',
      image:
          'https://images.unsplash.com/photo-1483412033650-1015ddeb83d1?auto=format&fit=crop&w=420&q=60',
    ),
    _TopMix(
      name: 'Daily Mix 3',
      image:
          'https://images.unsplash.com/photo-1507838153414-b4b713384a76?auto=format&fit=crop&w=420&q=60',
    ),
    _TopMix(
      name: 'Chill Mix',
      image:
          'https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=420&q=60',
    ),
    _TopMix(
      name: 'Bollywood Mix',
      image:
          'https://images.unsplash.com/photo-1485579149621-3123dd979885?auto=format&fit=crop&w=420&q=60',
      ),
  ];

  static const _recommended = <_SongItem>[
    _SongItem(
      title: 'Midnight Drive',
      artist: 'Camcine Radio',
      image:
          'https://images.unsplash.com/photo-1507838153414-b4b713384a76?auto=format&fit=crop&w=420&q=60',
    ),
    _SongItem(
      title: 'Coffeehouse',
      artist: 'Acoustic Picks',
      image:
          'https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=420&q=60',
    ),
    _SongItem(
      title: 'Late Night',
      artist: 'Lo-fi Collective',
      image:
          'https://images.unsplash.com/photo-1453738773917-9c3eff1db985?auto=format&fit=crop&w=420&q=60',
    ),
    _SongItem(
      title: 'Power Hour',
      artist: 'Workout Beats',
      image:
          'https://images.unsplash.com/photo-1526401281623-34255be78a9c?auto=format&fit=crop&w=420&q=60',
    ),
    _SongItem(
      title: 'Bollywood Gold',
      artist: 'Trending',
      image:
          'https://images.unsplash.com/photo-1519999482648-25049ddd37b1?auto=format&fit=crop&w=420&q=60',
    ),
    _SongItem(
      title: 'Indie Finds',
      artist: 'Recommended',
      image:
          'https://images.unsplash.com/photo-1524368535928-5b5e00ddc76b?auto=format&fit=crop&w=420&q=60',
    ),
  ];

  int _tabCrossAxisCount(double maxWidth) {
    if (maxWidth >= 980) return 4;
    if (maxWidth >= 720) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top + 10;
    final bottomPadding = MediaQuery.of(context).padding.bottom + 120;
    final profileName =
        ref.watch(contentProvider.select((s) => s.selectedProfile?.name)) ??
            'You';

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
                  onTap: () => context.go('/search?scope=songs'),
                ),
                const SizedBox(width: 4),
                const ProfileMenuButton(),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 32,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _modes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (context, index) {
                  final active = index == _selectedModeIndex;
                  return InkWell(
                    onTap: () => setState(() => _selectedModeIndex = index),
                    borderRadius: BorderRadius.circular(999),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.accent.withOpacity(0.18)
                            : Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: active
                              ? AppColors.accent.withOpacity(0.45)
                              : AppColors.borderSubtle,
                        ),
                      ),
                      child: Text(
                        _modes[index],
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: active
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                              fontWeight:
                                  active ? FontWeight.w900 : FontWeight.w800,
                              letterSpacing: 0.6,
                            ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final columns = _tabCrossAxisCount(constraints.maxWidth);
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 3.2,
                  ),
                  itemCount: _tabs.length,
                  itemBuilder: (context, index) {
                    final t = _tabs[index];
                    final selected = index == _selectedTabIndex;
                    return _MusicTabTile(
                      tab: t,
                      selected: selected,
                      onTap: () => setState(() => _selectedTabIndex = index),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your top mixes',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 190,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _topMixes.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
                    itemBuilder: (context, index) {
                      final mix = _topMixes[index];
                      return _TopMixCard(mix: mix);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recents',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 10),
                for (final s in _recents) ...[
                  _RecentSongTile(song: s),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recommended for today',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 205,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _recommended.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
                    itemBuilder: (context, index) {
                      return _RecommendedSongCard(song: _recommended[index]);
                    },
                  ),
                ),
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

class _MusicTabTile extends StatelessWidget {
  const _MusicTabTile({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final _MusicTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? AppColors.accent.withOpacity(0.18)
        : Colors.white.withOpacity(0.06);
    final border = selected
        ? AppColors.accent.withOpacity(0.45)
        : AppColors.borderSubtle;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            AppImage(
              source: tab.image,
              width: 32,
              height: 32,
              borderRadius: BorderRadius.circular(999),
              placeholderBorderRadius: 999,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                tab.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopMixCard extends StatelessWidget {
  const _TopMixCard({required this.mix});
  final _TopMix mix;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: AppImage(
                source: mix.image,
                width: 140,
                height: 140,
                borderRadius: BorderRadius.circular(16),
                placeholderBorderRadius: 16,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              mix.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentSongTile extends StatelessWidget {
  const _RecentSongTile({required this.song});
  final _SongItem song;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Row(
          children: [
            AppImage(
              source: song.image,
              width: 54,
              height: 54,
              borderRadius: BorderRadius.circular(12),
              placeholderBorderRadius: 12,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    song.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.14),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: const Icon(Icons.play_arrow_rounded,
                  color: AppColors.textPrimary, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendedSongCard extends StatelessWidget {
  const _RecommendedSongCard({required this.song});
  final _SongItem song;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: AppImage(
                source: song.image,
                width: 150,
                height: 150,
                borderRadius: BorderRadius.circular(16),
                placeholderBorderRadius: 16,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              song.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              song.artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _MusicTab {
  const _MusicTab({required this.name, required this.image});
  final String name;
  final String image;
}

class _TopMix {
  const _TopMix({required this.name, required this.image});
  final String name;
  final String image;
}

class _SongItem {
  const _SongItem({
    required this.title,
    required this.artist,
    required this.image,
  });

  final String title;
  final String artist;
  final String image;
}
