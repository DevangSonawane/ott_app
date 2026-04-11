import { Play, Plus, Info } from 'lucide-react';
import { newReleases } from '@/data/content';

export function NewReleases() {
  const featured = newReleases[0];
  const smallReleases = newReleases.slice(1);

  return (
    <section className="py-12">
      <div className="max-w-[1400px] mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="flex items-center justify-between mb-6">
          <div>
            <h2 className="text-2xl sm:text-3xl font-bold text-white">New Releases</h2>
            <p className="text-sm text-white/60 mt-1">Fresh from the studio</p>
          </div>
          <span className="px-3 py-1 bg-[#7c3aed] text-white text-sm font-medium rounded-full">
            12 New This Week
          </span>
        </div>

        {/* Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
          {/* Featured Large Card */}
          <div className="lg:row-span-2 group relative rounded-xl overflow-hidden cursor-pointer">
            <div className="aspect-[4/3] lg:aspect-auto lg:h-full">
              <img
                src={featured.image}
                alt={featured.title}
                className="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105"
              />
            </div>
            <div className="absolute inset-0 bg-gradient-to-t from-black/90 via-black/30 to-transparent" />
            
            {/* Featured Content */}
            <div className="absolute bottom-0 left-0 right-0 p-6">
              <span className="inline-block px-2 py-1 bg-white/20 backdrop-blur-sm text-white text-xs rounded mb-3">
                {featured.genre[0]}
              </span>
              <h3 className="text-2xl sm:text-3xl font-bold text-white mb-2">{featured.title}</h3>
              <p className="text-white/70 text-sm mb-4 line-clamp-2 max-w-md">{featured.description}</p>
              
              <div className="flex items-center gap-3">
                <button className="flex items-center gap-2 px-5 py-2.5 bg-white text-black rounded font-semibold hover:bg-white/90 transition-colors">
                  <Play className="w-4 h-4 fill-black" />
                  Watch Now
                </button>
                {featured.type === 'movie' && (
                  <button className="flex items-center gap-2 px-5 py-2.5 btn-gradient rounded font-semibold transition-colors">
                    Rent 1 Day • ₹49
                  </button>
                )}
                <button className="w-10 h-10 rounded-full border-2 border-white/50 flex items-center justify-center hover:border-white hover:bg-white/10 transition-all">
                  <Plus className="w-5 h-5 text-white" />
                </button>
                <button className="w-10 h-10 rounded-full border-2 border-white/50 flex items-center justify-center hover:border-white hover:bg-white/10 transition-all">
                  <Info className="w-5 h-5 text-white" />
                </button>
              </div>
            </div>
          </div>

          {/* Small Cards Grid */}
          <div className="grid grid-cols-2 gap-4">
            {smallReleases.map((release, index) => (
              <div
                key={release.id}
                className="group relative rounded-lg overflow-hidden cursor-pointer"
                style={{
                  animation: `fadeIn 0.5s var(--ease-expo-out) ${300 + index * 100}ms forwards`,
                  opacity: 0,
                }}
              >
                <div className="aspect-[4/3]">
                  <img
                    src={release.image}
                    alt={release.title}
                    className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
                  />
                </div>
                <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
                
                {/* Hover Content */}
                <div className="absolute bottom-0 left-0 right-0 p-3 translate-y-full group-hover:translate-y-0 transition-transform duration-300">
                  <h4 className="text-sm font-semibold text-white mb-1">{release.title}</h4>
                  <div className="flex items-center gap-2 text-xs text-white/70">
                    <span className="text-[#46d369]">{release.rating && `${(release.rating * 10).toFixed(0)}% Match`}</span>
                    <span>{release.year}</span>
                  </div>
                  {release.type === 'movie' && (
                    <button className="mt-2 w-full px-2 py-1.5 rounded btn-gradient text-xs font-semibold transition-colors">
                      Rent 1 Day • ₹49
                    </button>
                  )}
                </div>

                {/* Play Button on Hover */}
                <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                  <button className="w-12 h-12 rounded-full bg-white/90 flex items-center justify-center hover:scale-110 transition-transform">
                    <Play className="w-6 h-6 fill-black text-black ml-0.5" />
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}
