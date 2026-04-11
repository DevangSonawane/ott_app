import { useState } from 'react';
import { Footer } from '@/components/Footer';
import { User, Mail, Lock, Bell, Globe, CreditCard, Calendar, Shield } from 'lucide-react';

interface AccountSettingsPageProps {
  onProfileClick: () => void;
}

const accountData = {
  name: 'Alex Johnson',
  username: 'alexj',
  email: 'alex.johnson@example.com',
  phone: '+91 98765 43210',
  plan: '3 Months',
  planPrice: 499,
  planPeriod: '3 months',
  status: 'Active',
  lastPaymentDate: '02 Apr 2026',
  nextBillingDate: '02 Jul 2026',
  paymentMethod: 'Visa •••• 4242',
  billingAddress: '12, MG Road, Bengaluru, KA 560001',
};

export function AccountSettingsPage({ onProfileClick }: AccountSettingsPageProps) {
  const [emailNotifications, setEmailNotifications] = useState(true);
  const [language, setLanguage] = useState('English');

  return (
    <div className="min-h-screen bg-[#020202]">
      <main className="pt-[90px] pb-16">
        <div className="max-w-[1100px] mx-auto px-4 sm:px-6 lg:px-8">
          <div className="mb-10">
            <h1 className="text-3xl sm:text-4xl font-bold text-white">Account Settings</h1>
            <p className="text-white/60 mt-2">Everything about your account, subscription, and preferences.</p>
          </div>

          <div className="grid gap-6">
            {/* Account Overview */}
            <section className="bg-white/5 border border-white/10 rounded-2xl p-6">
              <div className="flex items-center gap-3 mb-4">
                <div className="w-10 h-10 rounded-lg bg-[#7c3aed]/20 flex items-center justify-center">
                  <User className="w-5 h-5 text-[#7c3aed]" />
                </div>
                <h2 className="text-xl font-semibold text-white">Account Overview</h2>
              </div>
              <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-4">
                <div className="bg-white/5 rounded-lg p-4">
                  <p className="text-xs text-white/50">Full Name</p>
                  <p className="text-white font-medium">{accountData.name}</p>
                </div>
                <div className="bg-white/5 rounded-lg p-4">
                  <p className="text-xs text-white/50">Username</p>
                  <p className="text-white font-medium">@{accountData.username}</p>
                </div>
                <div className="bg-white/5 rounded-lg p-4">
                  <p className="text-xs text-white/50">Account Status</p>
                  <p className="text-white font-medium">{accountData.status}</p>
                </div>
                <div className="bg-white/5 rounded-lg p-4">
                  <p className="text-xs text-white/50">Email</p>
                  <p className="text-white font-medium">{accountData.email}</p>
                </div>
                <div className="bg-white/5 rounded-lg p-4">
                  <p className="text-xs text-white/50">Phone</p>
                  <p className="text-white font-medium">{accountData.phone}</p>
                </div>
                <div className="bg-white/5 rounded-lg p-4">
                  <p className="text-xs text-white/50">Billing Address</p>
                  <p className="text-white font-medium">{accountData.billingAddress}</p>
                </div>
              </div>
            </section>

            {/* Subscription */}
            <section className="bg-white/5 border border-white/10 rounded-2xl p-6">
              <div className="flex items-center gap-3 mb-4">
                <div className="w-10 h-10 rounded-lg bg-[#7c3aed]/20 flex items-center justify-center">
                  <Calendar className="w-5 h-5 text-[#7c3aed]" />
                </div>
                <h2 className="text-xl font-semibold text-white">Subscription</h2>
              </div>
              <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-4">
                <div className="bg-white/5 rounded-lg p-4">
                  <p className="text-xs text-white/50">Current Plan</p>
                  <p className="text-white font-medium">{accountData.plan}</p>
                </div>
                <div className="bg-white/5 rounded-lg p-4">
                  <p className="text-xs text-white/50">Price</p>
                  <p className="text-white font-medium">₹{accountData.planPrice}/{accountData.planPeriod}</p>
                </div>
                <div className="bg-white/5 rounded-lg p-4">
                  <p className="text-xs text-white/50">Last Payment</p>
                  <p className="text-white font-medium">{accountData.lastPaymentDate}</p>
                </div>
                <div className="bg-white/5 rounded-lg p-4">
                  <p className="text-xs text-white/50">Next Billing</p>
                  <p className="text-white font-medium">{accountData.nextBillingDate}</p>
                </div>
              </div>
              <div className="mt-4 flex flex-wrap gap-3">
                <button className="px-4 py-2 btn-gradient text-sm font-semibold rounded-lg transition-colors">
                  Manage Plan
                </button>
                <button className="px-4 py-2 btn-gradient text-sm font-semibold rounded-lg transition-colors">
                  View Billing History
                </button>
              </div>
            </section>

            {/* Payment Method */}
            <section className="bg-white/5 border border-white/10 rounded-2xl p-6">
              <div className="flex items-center gap-3 mb-4">
                <div className="w-10 h-10 rounded-lg bg-[#7c3aed]/20 flex items-center justify-center">
                  <CreditCard className="w-5 h-5 text-[#7c3aed]" />
                </div>
                <h2 className="text-xl font-semibold text-white">Payment Method</h2>
              </div>
              <div className="flex items-center justify-between bg-white/5 rounded-lg p-4">
                <div>
                  <p className="text-white font-medium">{accountData.paymentMethod}</p>
                  <p className="text-white/50 text-sm">Primary payment method</p>
                </div>
                <button className="px-4 py-2 btn-gradient text-sm font-semibold rounded-lg transition-colors">
                  Update
                </button>
              </div>
            </section>

            {/* Contact */}
            <section className="bg-white/5 border border-white/10 rounded-2xl p-6">
              <div className="flex items-center gap-3 mb-4">
                <div className="w-10 h-10 rounded-lg bg-[#7c3aed]/20 flex items-center justify-center">
                  <Mail className="w-5 h-5 text-[#7c3aed]" />
                </div>
                <h2 className="text-xl font-semibold text-white">Contact</h2>
              </div>
              <div className="grid sm:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm text-white/60 mb-2">Email Address</label>
                  <input
                    type="email"
                    defaultValue={accountData.email}
                    className="w-full px-4 py-3 bg-white/5 border border-white/10 rounded-lg text-white placeholder:text-white/30 focus:outline-none focus:border-[#7c3aed]"
                  />
                </div>
                <div>
                  <label className="block text-sm text-white/60 mb-2">Phone Number</label>
                  <input
                    type="tel"
                    defaultValue={accountData.phone}
                    className="w-full px-4 py-3 bg-white/5 border border-white/10 rounded-lg text-white placeholder:text-white/30 focus:outline-none focus:border-[#7c3aed]"
                  />
                </div>
              </div>
            </section>

            {/* Security */}
            <section className="bg-white/5 border border-white/10 rounded-2xl p-6">
              <div className="flex items-center gap-3 mb-4">
                <div className="w-10 h-10 rounded-lg bg-[#7c3aed]/20 flex items-center justify-center">
                  <Lock className="w-5 h-5 text-[#7c3aed]" />
                </div>
                <h2 className="text-xl font-semibold text-white">Security</h2>
              </div>
              <div className="grid sm:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm text-white/60 mb-2">New Password</label>
                  <input
                    type="password"
                    placeholder="••••••••"
                    className="w-full px-4 py-3 bg-white/5 border border-white/10 rounded-lg text-white placeholder:text-white/30 focus:outline-none focus:border-[#7c3aed]"
                  />
                </div>
                <div>
                  <label className="block text-sm text-white/60 mb-2">Confirm Password</label>
                  <input
                    type="password"
                    placeholder="••••••••"
                    className="w-full px-4 py-3 bg-white/5 border border-white/10 rounded-lg text-white placeholder:text-white/30 focus:outline-none focus:border-[#7c3aed]"
                  />
                </div>
              </div>
              <div className="mt-4">
                <button className="px-4 py-2 btn-gradient text-sm font-semibold rounded-lg transition-colors">
                  Update Password
                </button>
              </div>
            </section>

            {/* Notifications */}
            <section className="bg-white/5 border border-white/10 rounded-2xl p-6">
              <div className="flex items-center gap-3 mb-4">
                <div className="w-10 h-10 rounded-lg bg-[#7c3aed]/20 flex items-center justify-center">
                  <Bell className="w-5 h-5 text-[#7c3aed]" />
                </div>
                <h2 className="text-xl font-semibold text-white">Notifications</h2>
              </div>
              <div className="flex items-center justify-between bg-white/5 rounded-lg px-4 py-3">
                <div>
                  <p className="text-white">Email updates</p>
                  <p className="text-white/50 text-sm">New releases, account alerts, and offers.</p>
                </div>
                <button
                  onClick={() => setEmailNotifications((prev) => !prev)}
                  className={`w-12 h-7 rounded-full transition-colors ${
                    emailNotifications ? 'bg-[#7c3aed]' : 'bg-white/20'
                  }`}
                >
                  <span
                    className={`block w-5 h-5 bg-white rounded-full transform transition-transform ${
                      emailNotifications ? 'translate-x-6' : 'translate-x-1'
                    }`}
                  />
                </button>
              </div>
            </section>

            {/* Preferences */}
            <section className="bg-white/5 border border-white/10 rounded-2xl p-6">
              <div className="flex items-center gap-3 mb-4">
                <div className="w-10 h-10 rounded-lg bg-[#7c3aed]/20 flex items-center justify-center">
                  <Globe className="w-5 h-5 text-[#7c3aed]" />
                </div>
                <h2 className="text-xl font-semibold text-white">Preferences</h2>
              </div>
              <div className="grid sm:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm text-white/60 mb-2">Language</label>
                  <select
                    value={language}
                    onChange={(e) => setLanguage(e.target.value)}
                    className="w-full px-4 py-3 bg-white/5 border border-white/10 rounded-lg text-white focus:outline-none focus:border-[#7c3aed]"
                  >
                    <option>English</option>
                    <option>Hindi</option>
                    <option>Tamil</option>
                    <option>Telugu</option>
                  </select>
                </div>
                <div>
                  <label className="block text-sm text-white/60 mb-2">Parental Controls</label>
                  <button className="w-full px-4 py-3 btn-gradient font-semibold rounded-lg transition-colors flex items-center justify-center gap-2">
                    <Shield className="w-4 h-4" />
                    Configure
                  </button>
                </div>
              </div>
            </section>

            <div className="flex justify-end">
              <button className="px-6 py-3 btn-gradient font-semibold rounded-lg transition-colors">
                Save Changes
              </button>
            </div>
          </div>
        </div>
      </main>

      <Footer />
    </div>
  );
}
