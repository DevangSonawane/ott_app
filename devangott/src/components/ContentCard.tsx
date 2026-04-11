import { Play, Plus, ThumbsUp, ChevronDown } from 'lucide-react';
import type { Movie } from '@/types';

interface ContentCardProps {
  content: Movie;
  variant?: 'default' | 'continue' | 'top10' | 'tall';
  rank?: number;
  onSelect?: (content: Movie) => void;
}

export function ContentCard({ content, variant = 'default', rank, onSelect }: ContentCardProps) {
  const isContinue = variant === 'continue';
  const isTop10 = variant === 'top10';
  const isTall = variant === 'tall';
  const isPoster = !isContinue && !isTall && !isTop10;

  return (
    <div
      className={`group relative flex-shrink-0 cursor-pointer transition-all duration-300 ${
        isContinue
          ? 'w-[260px] sm:w-[320px] md:w-[360px]'
          : isPoster
          ? 'w-[150px] sm:w-[190px] md:w-[210px]'
          : isTall
          ? 'w-[200px] sm:w-[240px]'
          : 'w-[160px] sm:w-[200px] md:w-[240px]'
      } ${isTop10 ? 'w-[140px] sm:w-[180px] md:w-[200px]' : ''}`}
      style={{
        perspective: '1000px',
      }}
      onClick={() => onSelect?.(content)}
    >
      <div
        className="relative rounded-md overflow-hidden transition-all duration-300 group-hover:scale-105 group-hover:z-10"
        style={{
          transformStyle: 'preserve-3d',
        }}
      >
        {/* Image */}
        <div className={`relative ${isPoster ? 'aspect-[2/3]' : isTall ? 'aspect-[9/16]' : 'aspect-video'} ${isTop10 ? 'aspect-[2/3]' : ''} overflow-hidden`}>
          <img
            src={content.image}
            alt={content.title}
            className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
          />

          {/* Gradient Overlay on Hover */}
          <div className="absolute inset-0 bg-gradient-to-t from-black/90 via-black/20 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />

          {/* Top 10 Rank */}
          {isTop10 && rank && (
            <div className="absolute -left-2 bottom-0 text-[80px] sm:text-[100px] font-bold leading-none text-transparent tracking-tighter"
              style={{
                WebkitTextStroke: '3px rgba(255,255,255,0.8)',
                textShadow: '4px 4px 0 rgba(0,0,0,0.5)',
              }}
            >
              {rank}
            </div>
          )}

          {/* Progress Bar for Continue Watching */}
          {isContinue && content.progress !== undefined && (
            <div className="absolute bottom-0 left-0 right-0 h-1 bg-white/20">
              <div
                className="h-full bg-[#7c3aed] transition-all duration-1000"
                style={{ width: `${content.progress}%` }}
              />
            </div>
          )}

          {/* Hover Actions */}
          <div className="absolute inset-0 flex flex-col justify-end p-3 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
            {/* Play Button */}
            <div className="flex items-center gap-2 mb-2">
              <button className="w-10 h-10 rounded-full bg-white flex items-center justify-center hover:scale-110 transition-transform">
                <Play className="w-5 h-5 fill-black text-black ml-0.5" />
              </button>
              <button className="w-8 h-8 rounded-full border-2 border-white/70 flex items-center justify-center hover:border-white hover:bg-white/10 transition-all">
                <Plus className="w-4 h-4 text-white" />
              </button>
              <button className="w-8 h-8 rounded-full border-2 border-white/70 flex items-center justify-center hover:border-white hover:bg-white/10 transition-all">
                <ThumbsUp className="w-4 h-4 text-white" />
              </button>
              <button className="w-8 h-8 rounded-full border-2 border-white/70 flex items-center justify-center hover:border-white hover:bg-white/10 transition-all ml-auto">
                <ChevronDown className="w-4 h-4 text-white" />
              </button>
            </div>

            {/* Info */}
            <div className="space-y-1">
              <h3 className="text-sm font-semibold text-white line-clamp-1">{content.title}</h3>
              <div className="flex items-center gap-2 text-xs text-white/70">
                <span className="text-[#46d369] font-medium">{content.rating ? `${content.rating * 10}% Match` : '98% Match'}</span>
                <span>{content.year}</span>
                {content.type === 'series' && <span className="border border-white/40 px-1 rounded text-[10px]">HD</span>}
              </div>
              {content.genre && (
                <div className="flex flex-wrap gap-1">
                  {content.genre.slice(0, 3).map((g) => (
                    <span key={g} className="text-[10px] text-white/60">{g}</span>
                  ))}
                </div>
              )}
            </div>

            <button className="mt-2 w-full px-3 py-2 rounded-md btn-gradient text-xs font-semibold transition-colors">
              {isContinue ? 'Continue Watching' : 'Rent 1 Day • ₹49'}
            </button>
          </div>
        </div>
      </div>

      {/* Episode Info for Continue Watching */}
      {isContinue && content.episodeInfo && (
        <div className="mt-2 px-1">
          <h3 className="text-sm font-medium text-white/90 group-hover:text-white transition-colors">
            {content.title}
          </h3>
          <p className="text-xs text-white/60">
            S{content.episodeInfo.season}:E{content.episodeInfo.episode} &quot;{content.episodeInfo.episodeTitle}&quot;
          </p>
        </div>
      )}
    </div>
  );
}
