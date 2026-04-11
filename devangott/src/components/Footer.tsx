import { Twitter, Instagram, Facebook, Youtube, Globe } from 'lucide-react';

export function Footer() {
  const footerLinks = {
    browse: [
      { label: 'Home', href: '/' },
      { label: 'TV Shows', href: '/genre/drama' },
      { label: 'Movies', href: '/genre/action' },
      { label: 'Originals', href: '/genre/scifi' },
      { label: 'New & Popular', href: '/' },
    ],
    help: [
      { label: 'Account', href: '#' },
      { label: 'Support Center', href: '#' },
      { label: 'Privacy', href: '#' },
      { label: 'Terms of Use', href: '#' },
      { label: 'Contact Us', href: '#' },
    ],
    legal: [
      { label: 'Cookie Preferences', href: '#' },
      { label: 'Corporate Information', href: '#' },
      { label: 'Legal Notices', href: '#' },
      { label: 'Accessibility', href: '#' },
    ],
  };

  const socialLinks = [
    { icon: Twitter, href: '#', label: 'Twitter' },
    { icon: Instagram, href: '#', label: 'Instagram' },
    { icon: Facebook, href: '#', label: 'Facebook' },
    { icon: Youtube, href: '#', label: 'YouTube' },
  ];

  return (
    <footer className="bg-[#020202] border-t border-white/5 pt-16 pb-8">
      <div className="max-w-[1400px] mx-auto px-4 sm:px-6 lg:px-8">
        {/* Social Links */}
        <div className="flex items-center gap-4 mb-8">
          {socialLinks.map((social) => (
            <a
              key={social.label}
              href={social.href}
              className="w-10 h-10 rounded-full bg-white/5 flex items-center justify-center text-white/60 hover:text-white hover:bg-white/10 hover:scale-110 hover:rotate-[10deg] transition-all duration-250"
              aria-label={social.label}
            >
              <social.icon className="w-5 h-5" />
            </a>
          ))}
        </div>

        {/* Links Grid */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-8 mb-12">
          {/* Browse */}
          <div>
            <h3 className="text-white font-semibold mb-4">Browse</h3>
            <ul className="space-y-3">
              {footerLinks.browse.map((link) => (
                <li key={link.label}>
                  <a
                    href={link.href}
                    className="text-white/60 text-sm hover:text-white hover:translate-x-1 inline-block transition-all duration-200"
                  >
                    {link.label}
                  </a>
                </li>
              ))}
            </ul>
          </div>

          {/* Help */}
          <div>
            <h3 className="text-white font-semibold mb-4">Help</h3>
            <ul className="space-y-3">
              {footerLinks.help.map((link) => (
                <li key={link.label}>
                  <a
                    href={link.href}
                    className="text-white/60 text-sm hover:text-white hover:translate-x-1 inline-block transition-all duration-200"
                  >
                    {link.label}
                  </a>
                </li>
              ))}
            </ul>
          </div>

          {/* Legal */}
          <div>
            <h3 className="text-white font-semibold mb-4">Legal</h3>
            <ul className="space-y-3">
              {footerLinks.legal.map((link) => (
                <li key={link.label}>
                  <a
                    href={link.href}
                    className="text-white/60 text-sm hover:text-white hover:translate-x-1 inline-block transition-all duration-200"
                  >
                    {link.label}
                  </a>
                </li>
              ))}
            </ul>
          </div>

          {/* Newsletter */}
          <div>
            <h3 className="text-white font-semibold mb-4">Stay Updated</h3>
            <p className="text-white/60 text-sm mb-4">
              Get the latest updates on new releases and exclusive content.
            </p>
            <div className="flex gap-2">
              <input
                type="email"
                placeholder="Enter your email"
                className="flex-1 h-10 px-3 bg-white/5 border border-white/10 rounded text-sm text-white placeholder:text-white/40 focus:outline-none focus:border-[#7c3aed] focus:ring-1 focus:ring-[#7c3aed] transition-all"
              />
              <button className="h-10 px-4 bg-[#7c3aed] text-white text-sm font-medium rounded hover:bg-[#8b5cf6] transition-colors">
                Subscribe
              </button>
            </div>
          </div>
        </div>

        {/* Bottom Bar */}
        <div className="flex flex-col sm:flex-row items-center justify-between gap-4 pt-8 border-t border-white/5">
          <div className="flex items-center gap-2">
            <span className="text-xl font-bold">
              <span className="text-[#7c3aed]">the</span>Flashx
            </span>
            <span className="text-white/40 text-sm">Entertainment without limits</span>
          </div>

          <div className="flex items-center gap-6">
            <button className="flex items-center gap-2 text-white/60 text-sm hover:text-white transition-colors">
              <Globe className="w-4 h-4" />
              English
            </button>
            <span className="text-white/40 text-sm">
              &copy; 2024 theFlashx. All rights reserved.
            </span>
          </div>
        </div>
      </div>
    </footer>
  );
}
