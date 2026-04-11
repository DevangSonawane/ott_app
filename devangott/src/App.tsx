import { useState } from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { Home } from '@/pages/Home';
import { GenrePage } from '@/pages/GenrePage';
import { ProfilePage } from '@/pages/ProfilePage';
import { SubscriptionPage } from '@/pages/SubscriptionPage';
import { AccountSettingsPage } from '@/pages/AccountSettingsPage';
import { LoginPage } from '@/pages/LoginPage';
import { SignupPage } from '@/pages/SignupPage';
import { ProfileSettingsPage } from '@/pages/ProfileSettingsPage';
import { AppLayout } from '@/components/AppLayout';
import { profiles } from '@/data/content';
import './App.css';

function App() {
  const [selectedProfile, setSelectedProfile] = useState<typeof profiles[0]>(profiles[0]);
  const [showProfileModal, setShowProfileModal] = useState(false);

  const handleProfileClick = () => {
    setShowProfileModal(true);
  };

  const handleSelectProfile = (profile: typeof profiles[0]) => {
    setSelectedProfile(profile);
    setShowProfileModal(false);
  };

  // Profile Selection Modal
  if (showProfileModal) {
    return (
      <BrowserRouter>
        <ProfilePage
          onProfileClick={handleProfileClick}
          onSelectProfile={handleSelectProfile}
          selectedProfile={selectedProfile}
        />
      </BrowserRouter>
    );
  }

  // Initial profile selection is skipped; default profile is used.

  return (
    <BrowserRouter>
      <AppLayout>
        <Routes>
          <Route path="/" element={<Home onProfileClick={handleProfileClick} />} />
          <Route path="/genre/:genreId" element={<GenrePage onProfileClick={handleProfileClick} />} />
          <Route path="/subscription" element={<SubscriptionPage onProfileClick={handleProfileClick} />} />
          <Route path="/account" element={<AccountSettingsPage onProfileClick={handleProfileClick} />} />
          <Route path="/profilesettings" element={<ProfileSettingsPage />} />
          <Route path="/login" element={<LoginPage onProfileClick={handleProfileClick} />} />
          <Route path="/signup" element={<SignupPage onProfileClick={handleProfileClick} />} />
          <Route path="/profiles" element={
            <ProfilePage
              onProfileClick={handleProfileClick}
              onSelectProfile={handleSelectProfile}
              selectedProfile={selectedProfile}
            />
          } />
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </AppLayout>
    </BrowserRouter>
  );
}

export default App;
