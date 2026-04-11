import { useState } from 'react';
import { Footer } from '@/components/Footer';
import { Check, X, Sparkles } from 'lucide-react';

interface SubscriptionPageProps {
  onProfileClick: () => void;
}

type BillingCycle = 'monthly' | 'quarterly' | 'yearly';
type Tier = 'super' | 'premium';

const pricing: Record<BillingCycle, Record<Tier, number>> = {
  monthly: { super: 199, premium: 299 },
  quarterly: { super: 499, premium: 699 },
  yearly: { super: 1499, premium: 1999 },
};

const features = [
  {
    title: 'All content',
    subtitle: 'Movies, Live sports, TV, Specials',
    values: { super: true, premium: true },
  },
  {
    title: 'Watch on TV or Laptop',
    values: { super: true, premium: true },
  },
  {
    title: 'Ads free movies and shows (except sports)',
    values: { super: false, premium: true },
  },
  {
    title: 'Number of devices that can be logged in',
    values: { super: '2', premium: '4' },
  },
  {
    title: 'Max video quality',
    values: { super: 'Full HD 1080p', premium: '4K 2160p + Dolby Vision' },
  },
  {
    title: 'Max audio quality',
    subtitle: 'Atmos available on select titles only',
    values: { super: 'Dolby Atmos', premium: 'Dolby Atmos' },
  },
];

export function SubscriptionPage({ onProfileClick }: SubscriptionPageProps) {
  const [billingCycle, setBillingCycle] = useState<BillingCycle>('quarterly');
  const [selectedTier, setSelectedTier] = useState<Tier>('super');

  const cycleLabel = billingCycle === 'monthly' ? '1 Month' : billingCycle === 'quarterly' ? '3 Months' : '1 Year';

  return (
    <div className="min-h-screen bg-[#020202]">
      <div className="relative overflow-hidden">
        <div className="absolute inset-0 opacity-20 bg-[radial-gradient(circle_at_top_left,rgba(124,58,237,0.35),transparent_55%)]" />
        <div className="absolute inset-0 opacity-10 bg-[radial-gradient(circle_at_bottom_right,rgba(255,255,255,0.2),transparent_60%)]" />
        <div className="absolute inset-0 bg-[linear-gradient(180deg,rgba(2,2,2,0.2),rgba(2,2,2,0.9))]" />

        <main className="relative pt-[70px] pb-16">
          <div className="max-w-[1400px] mx-auto px-6 sm:px-8 lg:px-10">
            <div className="grid lg:grid-cols-[1.1fr_1.3fr] gap-12 items-start">
              {/* Left Intro */}
              <div>
                <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-white/10 text-white/80 text-xs font-medium">
                  <Sparkles className="w-3.5 h-3.5" />
                  theFlashx Premium
                </div>
                <h1 className="text-3xl sm:text-4xl lg:text-5xl font-semibold text-white mt-5 leading-tight">
                  Subscribe and enjoy unlimited movies, shows & live sports
                </h1>
                <p className="text-white/60 mt-4 max-w-xl">
                  Choose the plan that suits your viewing style. Upgrade anytime.
                </p>
              </div>

              {/* Right Features + Comparison */}
              <div>
                <div className="grid grid-cols-[1fr_auto_auto] gap-6">
                  <div className="space-y-6">
                    {features.map((feature) => (
                      <div key={feature.title}>
                        <div className="text-white font-medium">{feature.title}</div>
                        {feature.subtitle && (
                          <div className="text-white/50 text-sm">{feature.subtitle}</div>
                        )}
                      </div>
                    ))}
                  </div>

                  <div className="rounded-2xl bg-gradient-to-b from-white/10 to-transparent border border-white/10 px-6 py-6 text-center">
                    <div className="text-[#f6d365] font-semibold">Super</div>
                    <div className="mt-6 space-y-6">
                      {features.map((feature) => (
                        <div key={feature.title} className="text-white/80">
                          {typeof feature.values.super === 'boolean' ? (
                            feature.values.super ? <Check className="w-5 h-5 mx-auto" /> : <X className="w-5 h-5 mx-auto text-white/40" />
                          ) : (
                            <div className="text-sm">{feature.values.super}</div>
                          )}
                        </div>
                      ))}
                    </div>
                  </div>

                  <div className="rounded-2xl bg-white/5 border border-white/10 px-6 py-6 text-center">
                    <div className="text-white/70 font-semibold">Premium</div>
                    <div className="mt-6 space-y-6">
                      {features.map((feature) => (
                        <div key={feature.title} className="text-white/80">
                          {typeof feature.values.premium === 'boolean' ? (
                            feature.values.premium ? <Check className="w-5 h-5 mx-auto" /> : <X className="w-5 h-5 mx-auto text-white/40" />
                          ) : (
                            <div className="text-sm">{feature.values.premium}</div>
                          )}
                        </div>
                      ))}
                    </div>
                  </div>
                </div>

                {/* Billing Toggle */}
                <div className="mt-8 flex items-center justify-center">
                  <div className="inline-flex items-center gap-1 p-1 bg-white/5 rounded-full">
                    {(['monthly', 'quarterly', 'yearly'] as BillingCycle[]).map((cycle) => (
                      <button
                        key={cycle}
                        onClick={() => setBillingCycle(cycle)}
                        className={`px-4 py-2 rounded-full text-sm font-medium transition-all ${
                          billingCycle === cycle ? 'bg-white text-black' : 'text-white/60 hover:text-white'
                        }`}
                      >
                        {cycle === 'monthly' ? 'Monthly' : cycle === 'quarterly' ? 'Quarterly' : 'Yearly'}
                      </button>
                    ))}
                  </div>
                </div>

                {/* Plan Cards */}
                <div className="mt-6 grid sm:grid-cols-2 gap-4">
                  {(['super', 'premium'] as Tier[]).map((tier) => (
                    <button
                      key={tier}
                      onClick={() => setSelectedTier(tier)}
                      className={`relative text-left rounded-2xl border p-5 transition-all ${
                        selectedTier === tier
                          ? 'border-white/60 bg-white/5 shadow-[0_0_0_1px_rgba(255,255,255,0.15)]'
                          : 'border-white/10 bg-white/5 hover:border-white/20'
                      }`}
                    >
                      {selectedTier === tier && (
                        <div className="absolute -top-3 -right-3 w-8 h-8 rounded-full bg-[#2563eb] text-white flex items-center justify-center text-xs font-bold">
                          ✓
                        </div>
                      )}
                      <div className="text-white/60 text-xs uppercase">{tier === 'premium' ? 'Upgrade to' : 'Plan'}</div>
                      <div className="text-white font-semibold text-lg mt-1">{tier === 'premium' ? 'Premium' : 'Super'}</div>
                      <div className="text-white/70 text-sm mt-3">
                        <span className="text-white text-2xl font-semibold">₹{pricing[billingCycle][tier]}</span>/{cycleLabel}
                      </div>
                    </button>
                  ))}
                </div>

                <button className="mt-5 w-full py-3 rounded-xl bg-gradient-to-r from-[#1e3a8a] via-[#4c1d95] to-[#7e22ce] text-white font-semibold hover:brightness-110 transition-colors">
                  Continue with {selectedTier === 'super' ? 'Super' : 'Premium'}
                </button>
              </div>
            </div>
          </div>
        </main>
      </div>

      <Footer />
    </div>
  );
}
