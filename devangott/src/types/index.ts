export interface Movie {
  id: string;
  title: string;
  year: number;
  genre: string[];
  type: 'movie' | 'series';
  description: string;
  image: string;
  rating?: number;
  duration?: string;
  progress?: number;
  episodeInfo?: {
    season: number;
    episode: number;
    episodeTitle: string;
  };
}

export interface HeroSlide {
  id: string;
  title: string;
  meta: string;
  description: string;
  image: string;
}

export interface UserProfile {
  id: string;
  name: string;
  avatar: string;
  isKids?: boolean;
}

export interface SubscriptionPlan {
  id: string;
  name: string;
  price: number;
  period: string;
  features: string[];
  isPopular?: boolean;
}

export interface Genre {
  id: string;
  name: string;
  icon: string;
  color: string;
}
