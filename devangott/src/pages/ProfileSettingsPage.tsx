import { Link } from 'react-router-dom';
import { profiles, continueWatching, newReleases } from '@/data/content';
import { HelpCircle, Pencil, Plus } from 'lucide-react';

export function ProfileSettingsPage() {
  const featured = newReleases[0];

  return (
    <div className="min-h-screen bg-[#020202]">
      <div className="relative min-h-screen">
        <div className="absolute inset-0 bg-[radial-gradient(circle_at_top_left,rgba(124,58,237,0.22),transparent_55%)]" />
        <div className="absolute inset-0 bg-[radial-gradient(circle_at_top_right,rgba(255,255,255,0.06),transparent_45%)]" />

        <main className="relative pt-10 pb-16">
          <div className="max-w-[1400px] mx-auto px-6 sm:px-8 lg:px-10">
            {/* Top Bar */}
            <div className="flex flex-wrap items-start justify-between gap-6">
              <div>
                <div className="flex items-center gap-3 text-white">
                  <div className="w-9 h-9 rounded-full bg-white/10 flex items-center justify-center">
                    <span className="block w-2 h-2 bg-white rounded-full" />
                  </div>
                  <div>
                    <div className="text-lg font-semibold">theFlashx Plan</div>
                    <div className="text-white/60 text-sm">+91 8104744056</div>
                  </div>
                </div>
                <Link
                  to="/subscription"
                  className="mt-3 inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-white/10 text-white/70 text-xs hover:text-white hover:bg-white/15 transition-colors"
                >
                  Upgrade
                </Link>
              </div>
              <div className="flex items-center gap-3">
                <Link
                  to="/subscription"
                  className="px-4 py-2 rounded-xl bg-gradient-to-r from-[#1e3a8a] via-[#4c1d95] to-[#7e22ce] text-white font-semibold hover:brightness-110 transition-colors"
                >
                  Upgrade
                </Link>
                <button className="px-4 py-2 rounded-xl bg-gradient-to-r from-[#1e3a8a] via-[#4c1d95] to-[#7e22ce] text-white font-semibold hover:brightness-110 transition-colors inline-flex items-center gap-2">
                  <HelpCircle className="w-4 h-4" />
                  Help & Settings
                </button>
              </div>
            </div>

            <div className="h-px bg-white/10 my-8" />

            {/* Profiles */}
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-xl text-white font-semibold">Profiles</h2>
              <Link to="/profilesettings" className="text-white/60 hover:text-white inline-flex items-center gap-2 text-sm">
                <Pencil className="w-4 h-4" />
                Edit
              </Link>
            </div>

            <div className="flex flex-wrap gap-6 items-center">
              {profiles.map((profile, index) => (
                <div key={profile.id} className="flex flex-col items-center gap-2">
                  <div className="relative w-20 h-20 rounded-full overflow-hidden bg-white/5 ring-2 ring-white/10">
                    <img src={profile.avatar} alt={profile.name} className="w-full h-full object-cover" />
                    {index === 1 && (
                      <div className="absolute -bottom-1 -right-1 w-6 h-6 rounded-full bg-white text-black text-xs font-bold flex items-center justify-center">
                        ✓
                      </div>
                    )}
                  </div>
                  <div className="text-white/80 text-sm">{profile.name}</div>
                </div>
              ))}
              <button className="flex flex-col items-center gap-2">
                <div className="w-20 h-20 rounded-full bg-white/10 flex items-center justify-center">
                  <Plus className="w-6 h-6 text-white/70" />
                </div>
                <div className="text-white/60 text-sm">Add</div>
              </button>
            </div>

            {/* Watchlist */}
            <div className="mt-10">
              <div className="flex items-center justify-between mb-4">
                <h3 className="text-lg text-white font-semibold">Watchlist</h3>
                <button className="text-white/60 hover:text-white text-sm">View All</button>
              </div>
              <div className="w-[140px] sm:w-[160px] rounded-xl overflow-hidden bg-white/5 border border-white/10">
                <img src={featured.image} alt={featured.title} className="w-full h-full object-cover" />
              </div>
            </div>

            {/* Continue Watching */}
            <div className="mt-10">
              <h3 className="text-lg text-white font-semibold mb-4">Continue Watching for Aish</h3>
              <div className="flex gap-4 overflow-x-auto pb-2">
                {continueWatching.slice(0, 8).map((item) => (
                  <div key={item.id} className="w-[140px] sm:w-[160px] rounded-xl overflow-hidden bg-white/5 border border-white/10">
                    <img src={item.image} alt={item.title} className="w-full h-full object-cover" />
                  </div>
                ))}
              </div>
            </div>
          </div>
        </main>
      </div>
    </div>
  );
}
