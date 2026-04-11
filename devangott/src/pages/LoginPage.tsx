import { Link } from 'react-router-dom';
import { Navigation } from '@/components/Navigation';
import { Footer } from '@/components/Footer';
import { HelpCircle, X } from 'lucide-react';
import { useState } from 'react';

interface LoginPageProps {
  onProfileClick: () => void;
}

export function LoginPage({ onProfileClick }: LoginPageProps) {
  const [loginMethod, setLoginMethod] = useState<'email' | 'phone'>('email');
  const [showOtp, setShowOtp] = useState(false);

  return (
    <div className="min-h-screen bg-[#020202]">
      <Navigation onProfileClick={onProfileClick} />

      <main className="pt-[90px] pb-16">
        <div className="max-w-[1100px] mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-end mb-6 text-white/50 text-sm">
            <button className="flex items-center gap-2 hover:text-white transition-colors">
              <HelpCircle className="w-4 h-4" />
              Help & Support
            </button>
          </div>

          <div className="relative overflow-hidden rounded-2xl border border-white/10 bg-gradient-to-b from-[#14141f] via-[#11131a] to-[#0d0f14] shadow-[0_40px_120px_rgba(0,0,0,0.6)]">
            <div className="absolute inset-0 bg-[radial-gradient(circle_at_top_left,rgba(124,58,237,0.18),transparent_55%)]" />
            <div className="absolute inset-0 bg-[radial-gradient(circle_at_bottom_right,rgba(124,58,237,0.12),transparent_50%)]" />

            <div className="relative px-6 sm:px-10 py-8">
              <div className="flex items-start justify-between gap-4">
                <div>
                  <h1 className="text-2xl sm:text-3xl font-semibold text-white">Login or sign up to continue</h1>
                  <p className="text-white/50 mt-2">Scan QR code or enter phone number to login</p>
                </div>
                <button className="text-white/40 hover:text-white transition-colors">
                  <X className="w-5 h-5" />
                </button>
              </div>

              <div className="mt-8 grid md:grid-cols-[1fr_auto_1fr] gap-8 items-center">
                {/* QR Section */}
                <div className="flex flex-col items-center md:items-start">
                  <div className="w-44 h-44 rounded-2xl bg-white p-3 shadow-lg">
                    <div className="w-full h-full rounded-xl bg-white border border-black/10 flex items-center justify-center">
                      <svg viewBox="0 0 120 120" className="w-full h-full">
                        <rect width="120" height="120" fill="#fff" />
                        <rect x="8" y="8" width="28" height="28" fill="#111" />
                        <rect x="12" y="12" width="20" height="20" fill="#fff" />
                        <rect x="16" y="16" width="12" height="12" fill="#111" />
                        <rect x="84" y="8" width="28" height="28" fill="#111" />
                        <rect x="88" y="12" width="20" height="20" fill="#fff" />
                        <rect x="92" y="16" width="12" height="12" fill="#111" />
                        <rect x="8" y="84" width="28" height="28" fill="#111" />
                        <rect x="12" y="88" width="20" height="20" fill="#fff" />
                        <rect x="16" y="92" width="12" height="12" fill="#111" />
                        <rect x="50" y="50" width="6" height="6" fill="#111" />
                        <rect x="60" y="50" width="6" height="6" fill="#111" />
                        <rect x="70" y="50" width="6" height="6" fill="#111" />
                        <rect x="50" y="60" width="6" height="6" fill="#111" />
                        <rect x="62" y="60" width="6" height="6" fill="#111" />
                        <rect x="74" y="60" width="6" height="6" fill="#111" />
                        <rect x="50" y="72" width="6" height="6" fill="#111" />
                        <rect x="60" y="72" width="6" height="6" fill="#111" />
                        <rect x="72" y="72" width="6" height="6" fill="#111" />
                        <rect x="34" y="44" width="6" height="6" fill="#111" />
                        <rect x="28" y="60" width="6" height="6" fill="#111" />
                        <rect x="40" y="66" width="6" height="6" fill="#111" />
                        <rect x="78" y="40" width="6" height="6" fill="#111" />
                        <rect x="88" y="52" width="6" height="6" fill="#111" />
                        <rect x="84" y="70" width="6" height="6" fill="#111" />
                      </svg>
                    </div>
                  </div>
                  <p className="text-white mt-6 font-semibold">Use Camera App to Scan QR</p>
                  <p className="text-white/50 text-sm mt-2 max-w-xs md:max-w-sm">
                    Click on the link generated to redirect to theFlashx mobile app
                  </p>
                </div>

                {/* Divider */}
                <div className="hidden md:flex items-center gap-3 text-white/30">
                  <div className="h-24 w-px bg-white/10" />
                  <span className="text-xs tracking-[0.3em]">OR</span>
                  <div className="h-24 w-px bg-white/10" />
                </div>

                {/* Login Section */}
                <div>
                  <div className="inline-flex items-center gap-2 p-1 bg-white/5 rounded-full mb-4">
                    <button
                      onClick={() => {
                        setLoginMethod('email');
                        setShowOtp(false);
                      }}
                      className={`px-4 py-2 rounded-full text-sm font-medium transition-all ${
                        loginMethod === 'email' ? 'bg-white text-black' : 'text-white/70 hover:text-white'
                      }`}
                    >
                      Email
                    </button>
                    <button
                      onClick={() => {
                        setLoginMethod('phone');
                        setShowOtp(false);
                      }}
                      className={`px-4 py-2 rounded-full text-sm font-medium transition-all ${
                        loginMethod === 'phone' ? 'bg-white text-black' : 'text-white/70 hover:text-white'
                      }`}
                    >
                      Phone
                    </button>
                  </div>

                  {loginMethod === 'email' ? (
                    <div className="space-y-3">
                      <div>
                        <label className="block text-sm text-white/60 mb-2">Email</label>
                        <input
                          type="email"
                          placeholder="you@example.com"
                          className="w-full px-4 py-3 bg-white/5 border border-white/10 rounded-xl text-white placeholder:text-white/30 focus:outline-none focus:border-[#7c3aed]"
                        />
                      </div>
                      <div>
                        <label className="block text-sm text-white/60 mb-2">Password</label>
                        <input
                          type="password"
                          placeholder="••••••••"
                          className="w-full px-4 py-3 bg-white/5 border border-white/10 rounded-xl text-white placeholder:text-white/30 focus:outline-none focus:border-[#7c3aed]"
                        />
                      </div>
                      <button className="mt-2 w-full py-3 btn-gradient font-semibold rounded-xl transition-colors">
                        Login
                      </button>
                    </div>
                  ) : (
                    <div className="space-y-3">
                      <div>
                        <label className="block text-sm text-white/60 mb-2">Enter mobile number</label>
                        <div className="flex items-center gap-3">
                          <div className="px-4 py-3 rounded-xl bg-white/5 border border-white/10 text-white/70">+91</div>
                          <input
                            type="tel"
                            placeholder="Mobile number"
                            className="flex-1 px-4 py-3 bg-white/5 border border-white/10 rounded-xl text-white placeholder:text-white/30 focus:outline-none focus:border-[#7c3aed]"
                          />
                        </div>
                      </div>
                      {!showOtp ? (
                        <button
                          onClick={() => setShowOtp(true)}
                          className="mt-1 w-full py-3 btn-gradient font-semibold rounded-xl transition-colors"
                        >
                          Send OTP
                        </button>
                      ) : (
                        <div className="space-y-3">
                          <div>
                            <label className="block text-sm text-white/60 mb-2">Enter OTP</label>
                            <input
                              type="text"
                              placeholder="6-digit code"
                              className="w-full px-4 py-3 bg-white/5 border border-white/10 rounded-xl text-white placeholder:text-white/30 focus:outline-none focus:border-[#7c3aed]"
                            />
                          </div>
                          <Link
                            to="/"
                            className="block w-full text-center py-3 btn-gradient font-semibold rounded-xl transition-colors"
                          >
                            Verify & Login
                          </Link>
                        </div>
                      )}
                    </div>
                  )}

                  <p className="text-white/40 text-xs mt-4">
                    By proceeding you confirm that you are above 18 years of age and agree to the Privacy Policy & Terms of Use.
                  </p>
                  <p className="text-white/50 text-sm mt-4">
                    Having trouble logging in?{' '}
                    <a className="text-[#7c3aed] hover:text-[#8b5cf6]" href="#">
                      Get Help
                    </a>
                  </p>
                  <p className="text-white/50 text-sm mt-3">
                    New to theFlashx?{' '}
                    <Link to="/signup" className="text-[#7c3aed] hover:text-[#8b5cf6]">
                      Sign up
                    </Link>
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </main>

      <Footer />
    </div>
  );
}
