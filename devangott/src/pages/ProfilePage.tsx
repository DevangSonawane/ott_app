import { useState } from 'react';
import { Link } from 'react-router-dom';
import { Navigation } from '@/components/Navigation';
import { Footer } from '@/components/Footer';
import { profiles } from '@/data/content';
import { Pencil, Plus, Settings, UserX, Check, X } from 'lucide-react';

interface ProfilePageProps {
  onProfileClick: () => void;
  onSelectProfile: (profile: typeof profiles[0]) => void;
  selectedProfile: typeof profiles[0] | null;
}

export function ProfilePage({ onProfileClick, onSelectProfile, selectedProfile }: ProfilePageProps) {
  const [isEditMode, setIsEditMode] = useState(false);
  const [editingProfile, setEditingProfile] = useState<typeof profiles[0] | null>(null);
  const [editName, setEditName] = useState('');

  const handleEdit = (profile: typeof profiles[0]) => {
    setEditingProfile(profile);
    setEditName(profile.name);
  };

  const handleSave = () => {
    if (editingProfile) {
      // In a real app, this would save to the backend
      editingProfile.name = editName;
      setEditingProfile(null);
    }
  };

  const handleCancel = () => {
    setEditingProfile(null);
    setEditName('');
  };

  return (
    <div className="min-h-screen bg-[#020202]">
      <Navigation onProfileClick={onProfileClick} />

      <main className="pt-[100px] pb-20">
        <div className="max-w-[1000px] mx-auto px-4 sm:px-6 lg:px-8">
          {/* Header */}
          <div className="text-center mb-12">
            <h1 
              className="text-3xl sm:text-4xl font-bold text-white mb-4"
              style={{ fontFamily: 'Inter Tight, sans-serif' }}
            >
              Who&apos;s watching?
            </h1>
            <button
              onClick={() => setIsEditMode(!isEditMode)}
              className="text-white/60 hover:text-white transition-colors text-sm uppercase tracking-wider"
            >
              {isEditMode ? 'Done' : 'Manage Profiles'}
            </button>
          </div>

          {/* Profiles Grid */}
          <div className="flex flex-wrap justify-center gap-6 sm:gap-8">
            {profiles.map((profile, index) => (
              <div
                key={profile.id}
                className="group relative"
                style={{
                  animation: `scaleIn 0.5s var(--ease-expo-out) ${index * 100}ms forwards`,
                  opacity: 0,
                }}
              >
                {editingProfile?.id === profile.id ? (
                  // Edit Mode
                  <div className="flex flex-col items-center gap-4">
                    <div className="w-24 h-24 sm:w-32 sm:h-32 rounded-lg overflow-hidden border-2 border-[#7c3aed]">
                      <img
                        src={profile.avatar}
                        alt={profile.name}
                        className="w-full h-full object-cover"
                      />
                    </div>
                    <input
                      type="text"
                      value={editName}
                      onChange={(e) => setEditName(e.target.value)}
                      className="w-32 px-3 py-2 bg-white/10 border border-white/20 rounded text-white text-center text-sm focus:outline-none focus:border-[#7c3aed]"
                      autoFocus
                    />
                    <div className="flex gap-2">
                      <button
                        onClick={handleSave}
                        className="p-2 bg-[#7c3aed] rounded-full hover:bg-[#8b5cf6] transition-colors"
                      >
                        <Check className="w-4 h-4 text-white" />
                      </button>
                      <button
                        onClick={handleCancel}
                        className="p-2 bg-white/10 rounded-full hover:bg-white/20 transition-colors"
                      >
                        <X className="w-4 h-4 text-white" />
                      </button>
                    </div>
                  </div>
                ) : (
                  // View Mode
                  <>
                    <button
                      onClick={() => !isEditMode && onSelectProfile(profile)}
                      className={`flex flex-col items-center gap-4 transition-all duration-300 ${
                        selectedProfile?.id === profile.id && !isEditMode
                          ? 'scale-105'
                          : 'group-hover:scale-105'
                      }`}
                    >
                      <div className={`relative w-24 h-24 sm:w-32 sm:h-32 rounded-lg overflow-hidden transition-all duration-300 ${
                        selectedProfile?.id === profile.id && !isEditMode
                          ? 'ring-4 ring-[#7c3aed]'
                          : 'group-hover:ring-4 group-hover:ring-white/50'
                      }`}>
                        <img
                          src={profile.avatar}
                          alt={profile.name}
                          className="w-full h-full object-cover"
                        />
                        {isEditMode && (
                          <div className="absolute inset-0 bg-black/60 flex items-center justify-center">
                            <Pencil className="w-8 h-8 text-white" />
                          </div>
                        )}
                      </div>
                      <span className={`text-lg ${
                        selectedProfile?.id === profile.id && !isEditMode
                          ? 'text-[#7c3aed]'
                          : 'text-white/70 group-hover:text-white'
                      } transition-colors`}>
                        {profile.name}
                      </span>
                    </button>

                    {isEditMode && (
                      <button
                        onClick={() => handleEdit(profile)}
                        className="absolute -top-2 -right-2 w-8 h-8 bg-white/10 rounded-full flex items-center justify-center hover:bg-white/20 transition-colors"
                      >
                        <Pencil className="w-4 h-4 text-white" />
                      </button>
                    )}
                  </>
                )}
              </div>
            ))}

            {/* Add Profile */}
            {!isEditMode && (
              <button
                className="flex flex-col items-center gap-4 group"
                style={{
                  animation: `scaleIn 0.5s var(--ease-expo-out) ${profiles.length * 100}ms forwards`,
                  opacity: 0,
                }}
              >
                <div className="w-24 h-24 sm:w-32 sm:h-32 rounded-lg border-2 border-white/20 flex items-center justify-center group-hover:border-white/50 transition-colors">
                  <Plus className="w-12 h-12 text-white/40 group-hover:text-white/70 transition-colors" />
                </div>
                <span className="text-lg text-white/40 group-hover:text-white/70 transition-colors">
                  Add Profile
                </span>
              </button>
            )}
          </div>

          {/* Settings */}
          {selectedProfile && !isEditMode && (
            <div 
              className="mt-16 flex flex-col sm:flex-row items-center justify-center gap-4"
              style={{
                animation: 'fadeIn 0.5s var(--ease-expo-out) 0.5s forwards',
                opacity: 0,
              }}
            >
              <Link
                to="/"
                className="flex items-center gap-2 px-6 py-3 bg-[#7c3aed] text-white rounded-lg font-medium hover:bg-[#8b5cf6] transition-colors"
              >
                Continue as {selectedProfile.name}
              </Link>
              <button className="flex items-center gap-2 px-6 py-3 bg-white/10 text-white rounded-lg font-medium hover:bg-white/20 transition-colors">
                <Settings className="w-5 h-5" />
                Profile Settings
              </button>
            </div>
          )}

          {/* Edit Mode Actions */}
          {isEditMode && (
            <div 
              className="mt-16 flex items-center justify-center gap-4"
              style={{
                animation: 'fadeIn 0.5s var(--ease-expo-out) 0.3s forwards',
                opacity: 0,
              }}
            >
              <button className="flex items-center gap-2 px-6 py-3 bg-white/10 text-white rounded-lg font-medium hover:bg-white/20 transition-colors">
                <UserX className="w-5 h-5" />
                Delete Profile
              </button>
            </div>
          )}
        </div>
      </main>

      <Footer />
    </div>
  );
}
