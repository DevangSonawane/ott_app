import { ArrowRight, Check } from 'lucide-react';

export function CTASection() {
  return (
    <section className="relative py-24 overflow-hidden">
      {/* Background Image */}
      <div className="absolute inset-0">
        <img
          src="/cta-background.jpg"
          alt="Entertainment collage"
          className="w-full h-full object-cover opacity-40"
        />
        <div className="absolute inset-0 bg-gradient-to-r from-[#020202] via-[#020202]/80 to-[#020202]/60" />
        <div className="absolute inset-0 bg-gradient-to-t from-[#020202] via-transparent to-[#020202]" />
      </div>

      {/* Content */}
      <div className="relative max-w-[1400px] mx-auto px-4 sm:px-6 lg:px-8">
        <div className="max-w-2xl mx-auto text-center">
          <h2 
            className="text-3xl sm:text-4xl lg:text-5xl font-bold text-white mb-4 text-shadow-3d"
            style={{ fontFamily: 'Inter Tight, sans-serif' }}
          >
            Unlimited Entertainment,{' '}
            <span className="text-[#7c3aed]">One Price</span>
          </h2>
          
          <p className="text-lg text-white/70 mb-8">
            Watch anywhere. Cancel anytime. Start your free trial today.
          </p>

          {/* Features */}
          <div className="flex flex-wrap justify-center gap-4 mb-8">
            {[
              'No ads, ever',
              'Download & watch offline',
              'Watch on any device',
              'Cancel anytime'
            ].map((feature) => (
              <div key={feature} className="flex items-center gap-2 text-white/80">
                <Check className="w-4 h-4 text-[#7c3aed]" />
                <span className="text-sm">{feature}</span>
              </div>
            ))}
          </div>

          {/* CTA Button */}
          <button 
            className="group relative inline-flex items-center gap-2 px-8 py-4 bg-[#7c3aed] text-white font-semibold rounded-lg overflow-hidden transition-all duration-300 hover:scale-105 hover:shadow-[0_0_40px_rgba(124,58,237,0.5)]"
            style={{
              animation: 'pulse 2s ease-in-out infinite',
            }}
          >
            <span className="relative z-10">Start Your Free Trial</span>
            <ArrowRight className="w-5 h-5 relative z-10 group-hover:translate-x-1 transition-transform" />
            <div className="absolute inset-0 bg-gradient-to-r from-[#7c3aed] to-[#8b5cf6] opacity-0 group-hover:opacity-100 transition-opacity" />
          </button>

          <p className="mt-4 text-sm text-white/50">
            No commitment, cancel anytime. Free trial for new members.
          </p>
        </div>
      </div>

      <style>{`
        @keyframes pulse {
          0%, 100% { box-shadow: 0 0 0 0 rgba(124, 58, 237, 0.4); }
          50% { box-shadow: 0 0 20px 10px rgba(124, 58, 237, 0.2); }
        }
      `}</style>
    </section>
  );
}
