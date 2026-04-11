import { useState, useEffect } from 'react';
import { Search, Bell, ChevronDown, User } from 'lucide-react';
import { Link, useLocation } from 'react-router-dom';

interface NavigationProps {
  onProfileClick?: () => void;
}

export function Navigation({ onProfileClick }: NavigationProps) {
  const [isScrolled, setIsScrolled] = useState(false);
  const [showSearch, setShowSearch] = useState(false);
  const [showProfileMenu, setShowProfileMenu] = useState(false);
  const location = useLocation();

  useEffect(() => {
    const handleScroll = () => {
      setIsScrolled(window.scrollY > 100);
    };

    window.addEventListener('scroll', handleScroll, { passive: true });
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  const navLinks = [
    { label: 'Home', path: '/' },
    { label: 'Series', path: '/genre/drama' },
    { label: 'Movies', path: '/genre/action' },
    { label: 'Originals', path: '/genre/scifi' },
  ];

  const isActive = (path: string) => {
    if (path === '/') return location.pathname === '/';
    return location.pathname.startsWith(path);
  };

  return (
    <nav
      className={`fixed top-0 left-0 right-0 z-50 transition-all duration-500 ${
        isScrolled
          ? 'glass border-b border-white/5'
          : 'bg-gradient-to-b from-black/80 to-transparent'
      }`}
    >
      <div className="max-w-[1400px] mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-[70px]">
          {/* Logo & Nav Links */}
          <div className="flex items-center gap-8">
            <Link
              to="/"
              className={`text-2xl font-bold text-white transition-transform duration-300 ${
                isScrolled ? 'scale-[0.85]' : 'scale-100'
              }`}
              style={{ fontFamily: 'Inter Tight, sans-serif' }}
            >
              <span className="text-[#7c3aed]">Stream</span>Flix
            </Link>

            <div className="hidden md:flex items-center gap-6">
              {navLinks.map((link, index) => (
                <Link
                  key={link.path}
                  to={link.path}
                  className={`relative text-sm font-medium transition-colors duration-250 group ${
                    isActive(link.path)
                      ? 'text-white'
                      : 'text-white/70 hover:text-white'
                  }`}
                  style={{
                    animationDelay: `${100 + index * 80}ms`,
                  }}
                >
                  {link.label}
                  <span
                    className={`absolute -bottom-1 left-1/2 h-0.5 bg-[#7c3aed] transition-all duration-250 ${
                      isActive(link.path)
                        ? 'w-full -translate-x-1/2'
                        : 'w-0 group-hover:w-full group-hover:-translate-x-1/2'
                    }`}
                  />
                </Link>
              ))}
            </div>
          </div>

          {/* Right Side Actions */}
          <div className="flex items-center gap-4">
            {/* Search */}
            <div className="relative">
              {showSearch ? (
                <div className="animate-fade-in">
                  <input
                    type="text"
                    placeholder="Titles, people, genres"
                    className="w-[200px] sm:w-[280px] h-9 px-3 pr-10 bg-black/60 border border-white/20 rounded text-sm text-white placeholder:text-white/50 focus:outline-none focus:border-white/40 transition-all"
                    autoFocus
                    onBlur={() => setShowSearch(false)}
                  />
                  <Search className="absolute right-3 top-1/2 -translate-y-1/2 w-4 h-4 text-white/50" />
                </div>
              ) : (
                <button
                  onClick={() => setShowSearch(true)}
                  className="p-2 text-white/80 hover:text-white hover:scale-110 hover:rotate-[15deg] transition-all duration-200"
                >
                  <Search className="w-5 h-5" />
                </button>
              )}
            </div>

            {/* Notifications */}
            <button className="relative p-2 text-white/80 hover:text-white transition-colors group">
              <Bell className="w-5 h-5 group-hover:animate-[swing_2s_ease-in-out_infinite]" />
              <span className="absolute top-1 right-1 w-2 h-2 bg-[#7c3aed] rounded-full animate-pulse" />
            </button>

            {/* Profile */}
            <div className="relative">
              <button
                onClick={() => setShowProfileMenu((prev) => !prev)}
                className="flex items-center gap-2 group"
              >
                <div className="w-8 h-8 rounded bg-[#7c3aed] flex items-center justify-center overflow-hidden transition-transform duration-300 group-hover:scale-105">
                  <User className="w-5 h-5 text-white" />
                </div>
                <ChevronDown className={`w-4 h-4 text-white/70 group-hover:text-white transition-colors duration-300 ${
                  showProfileMenu ? 'rotate-180' : ''
                }`} />
              </button>

              {showProfileMenu && (
                <div className="absolute right-0 mt-3 w-56 rounded-xl bg-[#141414] border border-white/10 shadow-xl overflow-hidden z-50">
                  <button
                    onClick={() => {
                      setShowProfileMenu(false);
                      onProfileClick?.();
                    }}
                    className="w-full text-left px-4 py-3 text-sm text-white/80 hover:text-white hover:bg-white/5 transition-colors"
                  >
                    Switch Profile
                  </button>
                  <Link
                    to="/profilesettings"
                    onClick={() => setShowProfileMenu(false)}
                    className="block px-4 py-3 text-sm text-white/80 hover:text-white hover:bg-white/5 transition-colors"
                  >
                    Profile Settings
                  </Link>
                  <Link
                    to="/account"
                    onClick={() => setShowProfileMenu(false)}
                    className="block px-4 py-3 text-sm text-white/80 hover:text-white hover:bg-white/5 transition-colors"
                  >
                    Account Settings
                  </Link>
                  <Link
                    to="/subscription"
                    onClick={() => setShowProfileMenu(false)}
                    className="block px-4 py-3 text-sm text-white/80 hover:text-white hover:bg-white/5 transition-colors"
                  >
                    Subscription
                  </Link>
                  <div className="h-px bg-white/10" />
                  <Link
                    to="/login"
                    onClick={() => setShowProfileMenu(false)}
                    className="block px-4 py-3 text-sm text-white/70 hover:text-white hover:bg-white/5 transition-colors"
                  >
                    Login
                  </Link>
                  <Link
                    to="/signup"
                    onClick={() => setShowProfileMenu(false)}
                    className="block px-4 py-3 text-sm text-white/70 hover:text-white hover:bg-white/5 transition-colors"
                  >
                    Sign Up
                  </Link>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </nav>
  );
}
