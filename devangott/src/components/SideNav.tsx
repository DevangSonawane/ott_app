import { Home, Search, Tv, Film, Radio, ListVideo, User, Settings } from 'lucide-react';
import { Link, useLocation } from 'react-router-dom';

const items = [
  { label: 'Home', icon: Home, path: '/' },
  { label: 'Search', icon: Search, path: '/genre/drama' },
  { label: 'TV', icon: Tv, path: '/genre/drama' },
  { label: 'Movies', icon: Film, path: '/genre/action' },
  { label: 'Live', icon: Radio, path: '/genre/thriller' },
  { label: 'My List', icon: ListVideo, path: '/genre/romance' },
  { label: 'Profiles', icon: User, path: '/profilesettings' },
  { label: 'Settings', icon: Settings, path: '/account' },
];

export function SideNav() {
  const location = useLocation();
  const isActive = (path: string) => (path === '/' ? location.pathname === '/' : location.pathname.startsWith(path));

  return (
    <aside className="group hidden sm:flex fixed left-0 top-0 h-screen w-16 hover:w-56 z-40 flex-col items-center py-6 bg-gradient-to-b from-black via-black/90 to-black border-r border-white/5 transition-[width] duration-300 overflow-hidden">
      <div className="mb-10 w-full flex items-center justify-center group-hover:justify-start px-4 transition-all">
        <div className="w-8 h-8 rounded-full bg-white/10 flex items-center justify-center">
          <span className="block w-2 h-2 bg-white rounded-full" />
        </div>
        <span className="ml-3 text-white/80 text-sm font-semibold opacity-0 group-hover:opacity-100 transition-opacity">
          theFlashx
        </span>
      </div>

      <nav className="flex-1 w-full px-2">
        <ul className="flex flex-col gap-2">
          {items.map((item) => (
            <li key={item.label}>
              <Link
                to={item.path}
                className={`w-full h-10 rounded-xl flex items-center gap-3 px-3 transition-all ${
                  isActive(item.path)
                    ? 'bg-white/15 text-white shadow-[0_0_20px_rgba(124,58,237,0.25)]'
                    : 'text-white/70 hover:text-white hover:bg-white/10'
                }`}
                aria-label={item.label}
              >
                <item.icon className="w-5 h-5 shrink-0" />
                <span className="text-sm opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap">
                  {item.label}
                </span>
              </Link>
            </li>
          ))}
        </ul>
      </nav>

      <div className="mt-6 text-white/40 text-xs opacity-0 group-hover:opacity-100 transition-opacity">
        SF
      </div>
    </aside>
  );
}
