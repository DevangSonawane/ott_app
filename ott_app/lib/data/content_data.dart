import 'package:flutter/material.dart';

import '../models/genre.dart';
import '../models/hero_slide.dart';
import '../models/movie.dart';
import '../models/subscription_plan.dart';
import '../models/user_profile.dart';
import '../theme/app_colors.dart';

String _thumb(String seed) => 'https://picsum.photos/seed/$seed/400/225';
String _poster(String seed) => 'https://picsum.photos/seed/$seed/600/900';

const heroSlides = <HeroSlide>[
  HeroSlide(
    id: 'stranger-things',
    title: 'Stranger Things',
    meta: '2016 | Sci-Fi | Horror',
    description:
        'When a young boy vanishes, a small town uncovers a mystery involving secret experiments and supernatural forces.',
    image: 'https://picsum.photos/seed/stranger-things/1280/720',
  ),
  HeroSlide(
    id: 'the-witcher',
    title: 'The Witcher',
    meta: '2019 | Fantasy | Action',
    description:
        'A monster hunter struggles to find his place in a world where people often prove more wicked than beasts.',
    image: 'https://picsum.photos/seed/the-witcher/1280/720',
  ),
  HeroSlide(
    id: 'money-heist',
    title: 'Money Heist',
    meta: '2017 | Crime | Thriller',
    description:
        'A criminal mastermind who goes by "The Professor" plans the biggest heist in recorded history.',
    image: 'https://picsum.photos/seed/money-heist/1280/720',
  ),
];

final continueWatching = <Movie>[
  Movie(
    id: 'cw-friends',
    title: 'Friends',
    year: 1994,
    genre: const ['Comedy', 'Drama'],
    type: 'series',
    description: 'Six friends navigate life and love in New York City.',
    image: _thumb('Friends'),
    progress: 62,
    rating: 0.96,
    episodeInfo:
        const EpisodeInfo(season: 3, episode: 12, episodeTitle: 'The One'),
  ),
  Movie(
    id: 'cw-gilmore-girls',
    title: 'Gilmore Girls',
    year: 2000,
    genre: const ['Drama', 'Comedy'],
    type: 'series',
    description: 'A witty mother-daughter duo in a charming small town.',
    image: _thumb('Gilmore%20Girls'),
    progress: 34,
    rating: 0.91,
    episodeInfo:
        const EpisodeInfo(season: 2, episode: 4, episodeTitle: 'Road Trip'),
  ),
  Movie(
    id: 'cw-jawan',
    title: 'Jawan',
    year: 2023,
    genre: const ['Action', 'Drama'],
    type: 'movie',
    description: 'A high-octane action thriller with heart and purpose.',
    image: _thumb('Jawan'),
    progress: 78,
    rating: 0.94,
    duration: '2h 49m',
  ),
  Movie(
    id: 'cw-bbt',
    title: 'Big Bang Theory',
    year: 2007,
    genre: const ['Comedy'],
    type: 'series',
    description: 'Brilliant minds collide with everyday life and friendship.',
    image: _thumb('Big%20Bang%20Theory'),
    progress: 51,
    rating: 0.93,
    episodeInfo: const EpisodeInfo(season: 5, episode: 7, episodeTitle: 'The'),
  ),
  Movie(
    id: 'cw-the-office',
    title: 'The Office',
    year: 2005,
    genre: const ['Comedy'],
    type: 'series',
    description: 'A mockumentary on office life and absurd management.',
    image: _thumb('The%20Office'),
    progress: 87,
    rating: 0.97,
    episodeInfo:
        const EpisodeInfo(season: 4, episode: 1, episodeTitle: 'Fun Run'),
  ),
  Movie(
    id: 'cw-vampire-diaries',
    title: 'The Vampire Diaries',
    year: 2009,
    genre: const ['Romance', 'Drama', 'Thriller'],
    type: 'series',
    description: 'A supernatural romance entangled in ancient rivalries.',
    image: _thumb('The%20Vampire%20Diaries'),
    progress: 28,
    rating: 0.89,
    episodeInfo:
        const EpisodeInfo(season: 1, episode: 9, episodeTitle: 'History'),
  ),
];

final topBollywood = <Movie>[
  Movie(
    id: 'bol-jawan',
    title: 'Jawan',
    year: 2023,
    genre: const ['Action', 'Drama'],
    type: 'movie',
    description: 'A gripping tale of justice with blockbuster action.',
    image: _poster('Jawan'),
    rating: 0.94,
    duration: '2h 49m',
  ),
  Movie(
    id: 'bol-pathaan',
    title: 'Pathaan',
    year: 2023,
    genre: const ['Action', 'Thriller'],
    type: 'movie',
    description: 'An elite spy returns for a mission that changes everything.',
    image: _poster('Pathaan'),
    rating: 0.92,
    duration: '2h 26m',
  ),
  Movie(
    id: 'bol-animal',
    title: 'Animal',
    year: 2023,
    genre: const ['Action', 'Drama'],
    type: 'movie',
    description: 'A raw father-son saga with explosive consequences.',
    image: _poster('Animal'),
    rating: 0.9,
    duration: '3h 21m',
  ),
  Movie(
    id: 'bol-rrr',
    title: 'RRR',
    year: 2022,
    genre: const ['Action', 'Drama'],
    type: 'movie',
    description: 'Two revolutionaries fight for freedom and friendship.',
    image: _poster('RRR'),
    rating: 0.95,
    duration: '3h 7m',
  ),
  Movie(
    id: 'bol-kgf2',
    title: 'KGF Chapter 2',
    year: 2022,
    genre: const ['Action', 'Drama'],
    type: 'movie',
    description: 'A feared hero rises against powerful enemies.',
    image: _poster('KGF%20Chapter%202'),
    rating: 0.91,
    duration: '2h 48m',
  ),
  Movie(
    id: 'bol-brahmastra',
    title: 'Brahmastra',
    year: 2022,
    genre: const ['Action', 'Romance', 'Sci-Fi'],
    type: 'movie',
    description: 'A modern fantasy about ancient powers awakened.',
    image: _poster('Brahmastra'),
    rating: 0.86,
    duration: '2h 47m',
  ),
  Movie(
    id: 'bol-drishyam2',
    title: 'Drishyam 2',
    year: 2022,
    genre: const ['Thriller', 'Drama'],
    type: 'movie',
    description: 'Secrets resurface when the past refuses to stay buried.',
    image: _poster('Drishyam%202'),
    rating: 0.93,
    duration: '2h 20m',
  ),
  Movie(
    id: 'bol-vikram',
    title: 'Vikram',
    year: 2022,
    genre: const ['Action', 'Thriller'],
    type: 'movie',
    description: 'A special agent faces a ruthless drug syndicate.',
    image: _poster('Vikram'),
    rating: 0.92,
    duration: '2h 54m',
  ),
  Movie(
    id: 'bol-pushpa',
    title: 'Pushpa',
    year: 2021,
    genre: const ['Action', 'Drama'],
    type: 'movie',
    description: 'A smuggler battles power while rising from nothing.',
    image: _poster('Pushpa'),
    rating: 0.9,
    duration: '2h 59m',
  ),
  Movie(
    id: 'bol-omg2',
    title: 'OMG 2',
    year: 2023,
    genre: const ['Drama', 'Comedy'],
    type: 'movie',
    description: 'A heartfelt courtroom drama with social themes.',
    image: _poster('OMG%202'),
    rating: 0.88,
    duration: '2h 36m',
  ),
];

final indianWebSeries = <Movie>[
  Movie(
    id: 'series-scam-1992',
    title: 'Scam 1992',
    year: 2020,
    genre: const ['Drama', 'Thriller'],
    type: 'series',
    description: 'The story of a stockbroker who shook India’s markets.',
    image: _poster('Scam%201992'),
    rating: 0.97,
    episodeInfo:
        const EpisodeInfo(season: 1, episode: 1, episodeTitle: 'Bull Run'),
  ),
  Movie(
    id: 'series-mirzapur',
    title: 'Mirzapur',
    year: 2018,
    genre: const ['Crime', 'Thriller', 'Action'],
    type: 'series',
    description: 'Power, guns, and vengeance in the lawless heartland.',
    image: _poster('Mirzapur'),
    rating: 0.93,
    episodeInfo:
        const EpisodeInfo(season: 2, episode: 1, episodeTitle: 'Payback'),
  ),
  Movie(
    id: 'series-sacred-games',
    title: 'Sacred Games',
    year: 2018,
    genre: const ['Crime', 'Thriller'],
    type: 'series',
    description: 'A cop receives a tip that reveals a sprawling conspiracy.',
    image: _poster('Sacred%20Games'),
    rating: 0.92,
    episodeInfo:
        const EpisodeInfo(season: 1, episode: 1, episodeTitle: 'Ashwathama'),
  ),
  Movie(
    id: 'series-panchayat',
    title: 'Panchayat',
    year: 2020,
    genre: const ['Comedy', 'Drama'],
    type: 'series',
    description: 'A reluctant secretary adjusts to village life and politics.',
    image: _poster('Panchayat'),
    rating: 0.95,
    episodeInfo:
        const EpisodeInfo(season: 1, episode: 2, episodeTitle: 'Gram Sabha'),
  ),
  Movie(
    id: 'series-family-man',
    title: 'The Family Man',
    year: 2019,
    genre: const ['Action', 'Thriller', 'Drama'],
    type: 'series',
    description:
        'A middle-class man secretly works as an intelligence officer.',
    image: _poster('The%20Family%20Man'),
    rating: 0.94,
    episodeInfo:
        const EpisodeInfo(season: 1, episode: 3, episodeTitle: 'Patriot'),
  ),
  Movie(
    id: 'series-delhi-crime',
    title: 'Delhi Crime',
    year: 2019,
    genre: const ['Crime', 'Drama'],
    type: 'series',
    description: 'Detectives race against time in chilling investigations.',
    image: _poster('Delhi%20Crime'),
    rating: 0.91,
    episodeInfo:
        const EpisodeInfo(season: 1, episode: 4, episodeTitle: 'Search'),
  ),
  Movie(
    id: 'series-aspirants',
    title: 'Aspirants',
    year: 2021,
    genre: const ['Drama'],
    type: 'series',
    description: 'Friendship and dreams collide in the world of UPSC.',
    image: _poster('Aspirants'),
    rating: 0.9,
    episodeInfo: const EpisodeInfo(season: 1, episode: 5, episodeTitle: 'Hope'),
  ),
  Movie(
    id: 'series-kota-factory',
    title: 'Kota Factory',
    year: 2019,
    genre: const ['Drama', 'Comedy'],
    type: 'series',
    description: 'Students chase IIT dreams in the pressure-cooker of Kota.',
    image: _poster('Kota%20Factory'),
    rating: 0.92,
    episodeInfo:
        const EpisodeInfo(season: 1, episode: 1, episodeTitle: 'Assembly'),
  ),
];

final topHollywood = <Movie>[
  Movie(
    id: 'hol-oppenheimer',
    title: 'Oppenheimer',
    year: 2023,
    genre: const ['Drama', 'Thriller'],
    type: 'movie',
    description: 'The story of the man behind the atomic bomb.',
    image: _poster('Oppenheimer'),
    rating: 0.94,
    duration: '3h 0m',
  ),
  Movie(
    id: 'hol-dune-2',
    title: 'Dune Part Two',
    year: 2024,
    genre: const ['Sci-Fi', 'Action'],
    type: 'movie',
    description: 'Paul Atreides unites with the Fremen to wage war.',
    image: _poster('Dune%20Part%20Two'),
    rating: 0.93,
    duration: '2h 46m',
  ),
  Movie(
    id: 'hol-the-batman',
    title: 'The Batman',
    year: 2022,
    genre: const ['Action', 'Thriller'],
    type: 'movie',
    description: 'A detective mystery in Gotham’s darkest nights.',
    image: _poster('The%20Batman'),
    rating: 0.91,
    duration: '2h 56m',
  ),
  Movie(
    id: 'hol-top-gun',
    title: 'Top Gun Maverick',
    year: 2022,
    genre: const ['Action', 'Drama'],
    type: 'movie',
    description:
        'A legendary pilot trains a new generation for an impossible mission.',
    image: _poster('Top%20Gun%20Maverick'),
    rating: 0.92,
    duration: '2h 11m',
  ),
  Movie(
    id: 'hol-avatar-2',
    title: 'Avatar Way of Water',
    year: 2022,
    genre: const ['Sci-Fi', 'Action'],
    type: 'movie',
    description: 'The saga continues beneath the oceans of Pandora.',
    image: _poster('Avatar%20Way%20of%20Water'),
    rating: 0.88,
    duration: '3h 12m',
  ),
  Movie(
    id: 'hol-interstellar',
    title: 'Interstellar',
    year: 2014,
    genre: const ['Sci-Fi', 'Drama'],
    type: 'movie',
    description:
        'A team travels through a wormhole in search of a new home for humanity.',
    image: _poster('Interstellar'),
    rating: 0.96,
    duration: '2h 49m',
  ),
  Movie(
    id: 'hol-endgame',
    title: 'Avengers Endgame',
    year: 2019,
    genre: const ['Action', 'Sci-Fi'],
    type: 'movie',
    description: 'The Avengers assemble for one final stand.',
    image: _poster('Avengers%20Endgame'),
    rating: 0.9,
    duration: '3h 1m',
  ),
  Movie(
    id: 'hol-joker',
    title: 'Joker',
    year: 2019,
    genre: const ['Drama', 'Thriller'],
    type: 'movie',
    description: 'A troubled man’s descent sparks a citywide revolt.',
    image: _poster('Joker'),
    rating: 0.89,
    duration: '2h 2m',
  ),
  Movie(
    id: 'hol-1917',
    title: '1917',
    year: 2019,
    genre: const ['Drama', 'Thriller'],
    type: 'movie',
    description: 'Two soldiers race against time across enemy territory.',
    image: _poster('1917'),
    rating: 0.9,
    duration: '1h 59m',
  ),
  Movie(
    id: 'hol-dark-knight',
    title: 'The Dark Knight',
    year: 2008,
    genre: const ['Action', 'Thriller', 'Drama'],
    type: 'movie',
    description: 'Batman faces the Joker in a battle for Gotham’s soul.',
    image: _poster('The%20Dark%20Knight'),
    rating: 0.97,
    duration: '2h 32m',
  ),
];

final top10 = <Movie>[
  topBollywood[0],
  indianWebSeries[0],
  topHollywood[0],
  topHollywood[5],
  topBollywood[3],
  indianWebSeries[4],
  topHollywood[9],
  topBollywood[1],
  topHollywood[1],
  indianWebSeries[2],
];

final genres = <Genre>[
  const Genre(
      id: 'action', name: 'Action', icon: 'bolt', color: Color(0xFFEF4444)),
  const Genre(
      id: 'drama', name: 'Drama', icon: 'theater', color: Color(0xFF60A5FA)),
  const Genre(
      id: 'romance',
      name: 'Romance',
      icon: 'favorite',
      color: Color(0xFFF472B6)),
  const Genre(
      id: 'scifi', name: 'Sci-Fi', icon: 'rocket', color: Color(0xFFA78BFA)),
  const Genre(
      id: 'thriller',
      name: 'Thriller',
      icon: 'visibility',
      color: Color(0xFFF59E0B)),
  const Genre(
      id: 'horror', name: 'Horror', icon: 'skull', color: Color(0xFF34D399)),
  const Genre(
      id: 'comedy',
      name: 'Comedy',
      icon: 'sentiment',
      color: Color(0xFFFDE047)),
];

final genreContent = <String, List<Movie>>{
  'action': [
    ...topBollywood.take(6),
    ...topHollywood.take(4),
  ],
  'drama': [
    ...indianWebSeries,
    ...topHollywood.where((m) => m.genre.contains('Drama')).take(4),
  ],
  'romance': [
    topBollywood.firstWhere((m) => m.title == 'Brahmastra'),
    continueWatching.firstWhere((m) => m.title == 'The Vampire Diaries'),
    Movie(
      id: 'rom-la-la-land',
      title: 'La La Land',
      year: 2016,
      genre: const ['Romance', 'Drama'],
      type: 'movie',
      description: 'A jazz musician and an actress fall in love in LA.',
      image: _poster('La%20La%20Land'),
      rating: 0.92,
      duration: '2h 8m',
    ),
    Movie(
      id: 'rom-pride',
      title: 'Pride & Prejudice',
      year: 2005,
      genre: const ['Romance', 'Drama'],
      type: 'movie',
      description: 'A classic romance of manners and misunderstandings.',
      image: _poster('Pride%20and%20Prejudice'),
      rating: 0.9,
      duration: '2h 9m',
    ),
    Movie(
      id: 'rom-eternal',
      title: 'Eternal Sunshine',
      year: 2004,
      genre: const ['Romance', 'Sci-Fi', 'Drama'],
      type: 'movie',
      description:
          'A couple erases memories of each other with surprising results.',
      image: _poster('Eternal%20Sunshine'),
      rating: 0.93,
      duration: '1h 48m',
    ),
    Movie(
      id: 'rom-before',
      title: 'Before Sunrise',
      year: 1995,
      genre: const ['Romance', 'Drama'],
      type: 'movie',
      description:
          'Two strangers meet on a train and spend a night walking Vienna.',
      image: _poster('Before%20Sunrise'),
      rating: 0.91,
      duration: '1h 41m',
    ),
  ],
  'scifi': [
    topHollywood.firstWhere((m) => m.title == 'Interstellar'),
    topHollywood.firstWhere((m) => m.title == 'Dune Part Two'),
    topHollywood.firstWhere((m) => m.title == 'Avatar Way of Water'),
    Movie(
      id: 'scifi-arrival',
      title: 'Arrival',
      year: 2016,
      genre: const ['Sci-Fi', 'Drama', 'Thriller'],
      type: 'movie',
      description: 'A linguist races to understand alien visitors.',
      image: _poster('Arrival'),
      rating: 0.94,
      duration: '1h 56m',
    ),
    Movie(
      id: 'scifi-ex-machina',
      title: 'Ex Machina',
      year: 2014,
      genre: const ['Sci-Fi', 'Thriller'],
      type: 'movie',
      description: 'A programmer evaluates an AI with hidden motives.',
      image: _poster('Ex%20Machina'),
      rating: 0.9,
      duration: '1h 48m',
    ),
    Movie(
      id: 'scifi-blade-runner',
      title: 'Blade Runner 2049',
      year: 2017,
      genre: const ['Sci-Fi', 'Drama'],
      type: 'movie',
      description:
          'A new blade runner uncovers a secret that could change society.',
      image: _poster('Blade%20Runner%202049'),
      rating: 0.93,
      duration: '2h 44m',
    ),
  ],
  'thriller': [
    topBollywood.firstWhere((m) => m.title == 'Drishyam 2'),
    topHollywood.firstWhere((m) => m.title == 'Joker'),
    topHollywood.firstWhere((m) => m.title == '1917'),
    indianWebSeries.firstWhere((m) => m.title == 'Sacred Games'),
    indianWebSeries.firstWhere((m) => m.title == 'Delhi Crime'),
    Movie(
      id: 'thriller-gone-girl',
      title: 'Gone Girl',
      year: 2014,
      genre: const ['Thriller', 'Drama'],
      type: 'movie',
      description:
          'A marriage turns into a national spectacle after a disappearance.',
      image: _poster('Gone%20Girl'),
      rating: 0.91,
      duration: '2h 29m',
    ),
  ],
  'horror': [
    Movie(
      id: 'hor-conjuring',
      title: 'The Conjuring',
      year: 2013,
      genre: const ['Horror', 'Thriller'],
      type: 'movie',
      description:
          'Paranormal investigators help a family terrorized by a dark presence.',
      image: _poster('The%20Conjuring'),
      rating: 0.88,
      duration: '1h 52m',
    ),
    Movie(
      id: 'hor-it',
      title: 'IT',
      year: 2017,
      genre: const ['Horror', 'Thriller'],
      type: 'movie',
      description: 'A group of kids face a terrifying evil in their town.',
      image: _poster('IT'),
      rating: 0.86,
      duration: '2h 15m',
    ),
    Movie(
      id: 'hor-a-quiet-place',
      title: 'A Quiet Place',
      year: 2018,
      genre: const ['Horror', 'Thriller'],
      type: 'movie',
      description: 'Silence is survival in a world hunted by sound.',
      image: _poster('A%20Quiet%20Place'),
      rating: 0.9,
      duration: '1h 30m',
    ),
    Movie(
      id: 'hor-stranger-things',
      title: 'Stranger Things',
      year: 2016,
      genre: const ['Horror', 'Sci-Fi'],
      type: 'series',
      description: 'A supernatural mystery in a small town.',
      image: _poster('Stranger%20Things'),
      rating: 0.96,
      episodeInfo: const EpisodeInfo(
          season: 1, episode: 1, episodeTitle: 'The Vanishing'),
    ),
    Movie(
      id: 'hor-hereditary',
      title: 'Hereditary',
      year: 2018,
      genre: const ['Horror', 'Thriller'],
      type: 'movie',
      description: 'A family unravels terrifying secrets after a loss.',
      image: _poster('Hereditary'),
      rating: 0.87,
      duration: '2h 7m',
    ),
    Movie(
      id: 'hor-the-witch',
      title: 'The Witch',
      year: 2015,
      genre: const ['Horror', 'Drama'],
      type: 'movie',
      description: 'A family’s faith is tested by ominous forces in the woods.',
      image: _poster('The%20Witch'),
      rating: 0.85,
      duration: '1h 32m',
    ),
  ],
  'comedy': [
    continueWatching.firstWhere((m) => m.title == 'Friends'),
    continueWatching.firstWhere((m) => m.title == 'The Office'),
    continueWatching.firstWhere((m) => m.title == 'Big Bang Theory'),
    Movie(
      id: 'com-superbad',
      title: 'Superbad',
      year: 2007,
      genre: const ['Comedy'],
      type: 'movie',
      description: 'A hilarious coming-of-age night gone wrong.',
      image: _poster('Superbad'),
      rating: 0.86,
      duration: '1h 53m',
    ),
    Movie(
      id: 'com-3-idiots',
      title: '3 Idiots',
      year: 2009,
      genre: const ['Comedy', 'Drama'],
      type: 'movie',
      description:
          'Friends reunite to find a lost buddy and rediscover purpose.',
      image: _poster('3%20Idiots'),
      rating: 0.95,
      duration: '2h 50m',
    ),
    Movie(
      id: 'com-the-hangover',
      title: 'The Hangover',
      year: 2009,
      genre: const ['Comedy'],
      type: 'movie',
      description: 'A bachelor party aftermath becomes a wild mystery.',
      image: _poster('The%20Hangover'),
      rating: 0.84,
      duration: '1h 40m',
    ),
  ],
};

final profiles = <UserProfile>[
  const UserProfile(
    id: 'alex',
    name: 'Alex',
    avatar: 'https://i.pravatar.cc/150?img=12',
    isKids: false,
  ),
  const UserProfile(
    id: 'sarah',
    name: 'Sarah',
    avatar: 'https://i.pravatar.cc/150?img=32',
    isKids: false,
  ),
  const UserProfile(
    id: 'mike',
    name: 'Mike',
    avatar: 'https://i.pravatar.cc/150?img=48',
    isKids: false,
  ),
  const UserProfile(
    id: 'kids',
    name: 'Kids',
    avatar: 'https://i.pravatar.cc/150?img=20',
    isKids: true,
  ),
];

final subscriptionPlans = <SubscriptionPlan>[
  SubscriptionPlan(
    id: 'super_monthly',
    name: 'Super',
    price: 199,
    period: 'month',
    isPopular: false,
    features: const [
      'All content (Movies, Live sports, TV, Specials)',
      'Watch on TV or Laptop',
      'Dolby Atmos',
      '2 devices',
      'Full HD 1080p',
    ],
  ),
  SubscriptionPlan(
    id: 'super_quarterly',
    name: 'Super',
    price: 499,
    period: 'quarter',
    isPopular: false,
    features: const [
      'All content (Movies, Live sports, TV, Specials)',
      'Watch on TV or Laptop',
      'Dolby Atmos',
      '2 devices',
      'Full HD 1080p',
    ],
  ),
  SubscriptionPlan(
    id: 'super_yearly',
    name: 'Super',
    price: 1499,
    period: 'year',
    isPopular: false,
    features: const [
      'All content (Movies, Live sports, TV, Specials)',
      'Watch on TV or Laptop',
      'Dolby Atmos',
      '2 devices',
      'Full HD 1080p',
    ],
  ),
  SubscriptionPlan(
    id: 'premium_monthly',
    name: 'Premium',
    price: 299,
    period: 'month',
    isPopular: true,
    features: const [
      'All content (Movies, Live sports, TV, Specials)',
      'Watch on TV or Laptop',
      'Ads-free movies and shows',
      'Dolby Atmos',
      '4 devices',
      '4K 2160p + Dolby Vision',
    ],
  ),
  SubscriptionPlan(
    id: 'premium_quarterly',
    name: 'Premium',
    price: 699,
    period: 'quarter',
    isPopular: true,
    features: const [
      'All content (Movies, Live sports, TV, Specials)',
      'Watch on TV or Laptop',
      'Ads-free movies and shows',
      'Dolby Atmos',
      '4 devices',
      '4K 2160p + Dolby Vision',
    ],
  ),
  SubscriptionPlan(
    id: 'premium_yearly',
    name: 'Premium',
    price: 1999,
    period: 'year',
    isPopular: true,
    features: const [
      'All content (Movies, Live sports, TV, Specials)',
      'Watch on TV or Laptop',
      'Ads-free movies and shows',
      'Dolby Atmos',
      '4 devices',
      '4K 2160p + Dolby Vision',
    ],
  ),
];

SubscriptionPlan planFor({
  required String tier, // 'super' | 'premium'
  required String billingCycle, // 'monthly'|'quarterly'|'yearly'
}) {
  final id = '${tier}_$billingCycle';
  return subscriptionPlans.firstWhere(
    (p) => p.id == id,
    orElse: () =>
        subscriptionPlans.firstWhere((p) => p.id == 'premium_monthly'),
  );
}

List<Movie> get allContent {
  final set = <String, Movie>{};
  for (final list in [
    continueWatching,
    topBollywood,
    indianWebSeries,
    topHollywood,
    top10,
    ...genreContent.values,
  ]) {
    for (final movie in list) {
      set[movie.id] = movie;
    }
  }
  return set.values.toList();
}

List<Movie> similarTo(Movie movie, {int max = 10}) {
  final g = movie.genre.toSet();
  return allContent
      .where((m) => m.id != movie.id && m.genre.any(g.contains))
      .take(max)
      .toList();
}

List<Movie> dramaSeries() {
  return [
    ...indianWebSeries.where((m) => m.genre.contains('Drama')),
    ...topHollywood.where((m) => m.genre.contains('Drama')).take(4),
  ];
}

List<Movie> actionMix() {
  return [
    ...topBollywood.where((m) => m.genre.contains('Action')).take(6),
    ...topHollywood.where((m) => m.genre.contains('Action')).take(4),
  ];
}

BoxDecoration subscriptionBackgroundDecoration() {
  return BoxDecoration(
    color: AppColors.background,
    gradient: RadialGradient(
      center: Alignment.topLeft,
      radius: 1.2,
      colors: [
        AppColors.accent.withOpacity(0.2),
        Colors.transparent,
      ],
    ),
  );
}
