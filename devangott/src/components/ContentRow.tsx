import { useState, useRef } from 'react';
import { ContentCard } from './ContentCard';
import type { Movie } from '@/types';

interface ContentRowProps {
  title: string;
  subtitle?: string;
  contents: Movie[];
  variant?: 'default' | 'continue' | 'top10' | 'mixed';
  showFilter?: boolean;
  onSelect?: (content: Movie) => void;
}

export function ContentRow({ title, subtitle, contents, variant = 'default', showFilter, onSelect }: ContentRowProps) {
  const scrollRef = useRef<HTMLDivElement>(null);
  const [activeFilter, setActiveFilter] = useState('All');

  const filters = ['All', 'Movies', 'TV Shows'];

  const filteredContents = activeFilter === 'All'
    ? contents
    : contents.filter(c => activeFilter === 'Movies' ? c.type === 'movie' : c.type === 'series');

  return (
    <section className="py-6 relative group/row">
      {/* Header */}
      <div className="max-w-[1400px] mx-auto px-4 sm:px-6 lg:px-8 mb-4">
        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-xl sm:text-2xl font-bold text-white">{title}</h2>
            {subtitle && <p className="text-sm text-white/60 mt-1">{subtitle}</p>}
          </div>

          {showFilter && (
            <div className="flex items-center gap-2">
              {filters.map((filter) => (
                <button
                  key={filter}
                  onClick={() => setActiveFilter(filter)}
                  className={`px-3 py-1 text-sm rounded-full transition-all duration-300 ${
                    activeFilter === filter
                      ? 'bg-white text-black'
                      : 'bg-white/10 text-white/70 hover:bg-white/20 hover:text-white'
                  }`}
                >
                  {filter}
                </button>
              ))}
            </div>
          )}
        </div>
      </div>

      <div
        ref={scrollRef}
        className="flex gap-4 overflow-x-auto overflow-y-hidden scrollbar-hide px-4 sm:px-6 lg:px-8"
        style={{ touchAction: 'pan-y' }}
      >
        <div className="flex gap-4">
          {filteredContents.map((content, index) => (
            <div
              key={content.id}
              style={{
                animationDelay: `${index * 80}ms`,
              }}
            >
              <ContentCard
                content={content}
                variant={variant === 'top10' ? 'top10' : variant === 'continue' ? 'continue' : variant === 'mixed' && index % 3 === 1 ? 'tall' : 'default'}
                rank={variant === 'top10' ? index + 1 : undefined}
                onSelect={onSelect}
              />
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
