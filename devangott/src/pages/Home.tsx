import { HeroSlider } from '@/components/HeroSlider';
import { ContentRow } from '@/components/ContentRow';
import { Footer } from '@/components/Footer';
import { continueWatching, top10, genreContent, newReleases, topBollywood, indianWebSeries, topHollywood } from '@/data/content';
import type { Movie } from '@/types';
import { useMemo, useState } from 'react';
import { X } from 'lucide-react';

interface HomeProps {
  onProfileClick: () => void;
}

export function Home({ onProfileClick }: HomeProps) {
  const [selected, setSelected] = useState<Movie | null>(null);

  const allContent = useMemo(() => {
    const combined = [
      ...continueWatching,
      ...top10,
      ...newReleases,
      ...Object.values(genreContent).flat(),
    ];
    const map = new Map<string, Movie>();
    combined.forEach((item) => map.set(item.id, item));
    return Array.from(map.values());
  }, []);

  const similar = useMemo(() => {
    if (!selected) return [];
    return allContent
      .filter((item) => item.id !== selected.id)
      .filter((item) => item.genre?.some((g) => selected.genre?.includes(g)))
      .slice(0, 10);
  }, [allContent, selected]);

  return (
    <div className="min-h-screen bg-[#020202]">
      <main>
        {/* Hero Section */}
        <HeroSlider />

        {/* Content Rows */}
        <div className="relative z-10 -mt-32 space-y-8 pb-12">
          {/* Continue Watching */}
          <ContentRow
            title="Continue Watching"
            subtitle="Pick up where you left off"
            contents={continueWatching}
            variant="continue"
            onSelect={setSelected}
          />

          {/* Top 10 Bollywood Movies */}
          <ContentRow
            title="Top 10 Bollywood Movies"
            subtitle="Popular picks from our collection"
            contents={topBollywood}
            variant="default"
            onSelect={setSelected}
          />

          {/* Indian Web Series */}
          <ContentRow
            title="Indian Web Series"
            subtitle="Binge-worthy Indian originals"
            contents={indianWebSeries}
            variant="default"
            onSelect={setSelected}
          />

          {/* Top Hollywood */}
          <ContentRow
            title="Top Hollywood"
            subtitle="Blockbuster hits"
            contents={topHollywood}
            variant="default"
            onSelect={setSelected}
          />

          {/* Drama Series */}
          <ContentRow
            title="Drama Series"
            subtitle="Binge-worthy drama picks"
            contents={genreContent.drama}
            variant="default"
            onSelect={setSelected}
          />

          {/* Top 10 */}
          <ContentRow
            title="Top 10 in India"
            subtitle="Today in Hindi"
            contents={top10}
            variant="default"
            onSelect={setSelected}
          />

          {/* Action */}
          <ContentRow
            title="Action"
            subtitle="High-octane action hits"
            contents={genreContent.action}
            variant="default"
            onSelect={setSelected}
          />
        </div>
      </main>

      <Footer />

      {selected && (
        <div className="fixed inset-0 z-50 bg-black/80 backdrop-blur-sm p-4 flex items-center justify-center">
          <div className="relative w-full max-w-4xl bg-[#141414] border border-white/10 rounded-2xl overflow-hidden">
            <button
              onClick={() => setSelected(null)}
              className="absolute top-4 right-4 w-9 h-9 rounded-full bg-white/10 text-white/70 hover:text-white hover:bg-white/20 transition-colors"
            >
              <X className="w-4 h-4 mx-auto" />
            </button>
            <div className="grid md:grid-cols-[1.1fr_1fr] gap-6 p-6">
              <div className="rounded-xl overflow-hidden bg-black/40">
                <img src={selected.image} alt={selected.title} className="w-full h-full object-cover" />
              </div>
              <div>
                <h3 className="text-2xl font-semibold text-white">{selected.title}</h3>
                <p className="text-white/60 mt-2">{selected.description}</p>
                <div className="mt-4 flex flex-wrap gap-3">
                  <button className="px-4 py-2 rounded-lg btn-gradient font-semibold">
                    Watch Video
                  </button>
                  <button className="px-4 py-2 rounded-lg btn-gradient font-semibold">
                    Rent 1 Day • ₹49
                  </button>
                </div>
              </div>
            </div>
            {similar.length > 0 && (
              <div className="px-6 pb-6">
                <h4 className="text-white font-semibold mb-3">Similar Movies</h4>
                <div className="flex gap-3 overflow-x-auto pb-2">
                  {similar.map((item) => (
                    <button
                      key={item.id}
                      onClick={() => setSelected(item)}
                      className="w-[140px] sm:w-[160px] rounded-xl overflow-hidden bg-white/5 border border-white/10 hover:border-white/20 transition-all"
                    >
                      <img src={item.image} alt={item.title} className="w-full h-full object-cover" />
                    </button>
                  ))}
                </div>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
