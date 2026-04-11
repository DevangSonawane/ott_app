import { useParams, Link } from 'react-router-dom';
import { Footer } from '@/components/Footer';
import { HeroSlider } from '@/components/HeroSlider';
import { ContentRow } from '@/components/ContentRow';
import { genres, genreContent, indianWebSeries } from '@/data/content';
import { ArrowLeft } from 'lucide-react';

interface GenrePageProps {
  onProfileClick: () => void;
}

export function GenrePage({ onProfileClick }: GenrePageProps) {
  const { genreId } = useParams<{ genreId: string }>();

  const genre = genres.find(g => g.id === genreId);
  const isTvPage = genreId === 'drama';
  const contents = isTvPage
    ? [...(genreContent.drama || []), ...indianWebSeries]
    : (genreContent[genreId || ''] || []);

  return (
    <div className="min-h-screen bg-[#020202]">
      {/* Hero */}
      <HeroSlider />

      {/* Content */}
      <main className="max-w-[1400px] mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Back Link */}
        <div className="flex flex-wrap items-center justify-between gap-4 mb-8">
          <Link
            to="/"
            className="flex items-center gap-2 text-white/70 hover:text-white transition-colors"
          >
            <ArrowLeft className="w-5 h-5" />
            Back to Home
          </Link>
        </div>

        {/* Genre Tags */}
        <div className="flex flex-wrap gap-2 mb-8">
          <Link
            to="/genre/action"
            className={`px-4 py-2 rounded-full text-sm font-medium transition-all ${
              genreId === 'action'
                ? 'bg-[#7c3aed] text-white'
                : 'bg-white/10 text-white/70 hover:bg-white/20 hover:text-white'
            }`}
          >
            Action
          </Link>
          <Link
            to="/genre/romance"
            className={`px-4 py-2 rounded-full text-sm font-medium transition-all ${
              genreId === 'romance'
                ? 'bg-[#7c3aed] text-white'
                : 'bg-white/10 text-white/70 hover:bg-white/20 hover:text-white'
            }`}
          >
            Romance
          </Link>
          <Link
            to="/genre/scifi"
            className={`px-4 py-2 rounded-full text-sm font-medium transition-all ${
              genreId === 'scifi'
                ? 'bg-[#7c3aed] text-white'
                : 'bg-white/10 text-white/70 hover:bg-white/20 hover:text-white'
            }`}
          >
            Sci-Fi
          </Link>
          <Link
            to="/genre/drama"
            className={`px-4 py-2 rounded-full text-sm font-medium transition-all ${
              genreId === 'drama'
                ? 'bg-[#7c3aed] text-white'
                : 'bg-white/10 text-white/70 hover:bg-white/20 hover:text-white'
            }`}
          >
            Drama
          </Link>
          <Link
            to="/genre/thriller"
            className={`px-4 py-2 rounded-full text-sm font-medium transition-all ${
              genreId === 'thriller'
                ? 'bg-[#7c3aed] text-white'
                : 'bg-white/10 text-white/70 hover:bg-white/20 hover:text-white'
            }`}
          >
            Thriller
          </Link>
          <Link
            to="/genre/horror"
            className={`px-4 py-2 rounded-full text-sm font-medium transition-all ${
              genreId === 'horror'
                ? 'bg-[#7c3aed] text-white'
                : 'bg-white/10 text-white/70 hover:bg-white/20 hover:text-white'
            }`}
          >
            Horror
          </Link>
          <Link
            to="/genre/comedy"
            className={`px-4 py-2 rounded-full text-sm font-medium transition-all ${
              genreId === 'comedy'
                ? 'bg-[#7c3aed] text-white'
                : 'bg-white/10 text-white/70 hover:bg-white/20 hover:text-white'
            }`}
          >
            Comedy
          </Link>
        </div>

        {/* Content Grid */}
        {contents.length > 0 ? (
          <div className="-mx-4 sm:-mx-6 lg:-mx-8">
            <ContentRow
              title={genre?.name || 'Browse'}
              subtitle={isTvPage ? 'Drama picks and Indian originals' : 'Binge-worthy picks'}
              contents={contents}
              variant="default"
            />
          </div>
        ) : (
          <div className="text-center py-20">
            <p className="text-white/60 text-lg">No content available in this genre yet.</p>
            <Link
              to="/"
              className="inline-block mt-4 px-6 py-3 bg-[#7c3aed] text-white rounded-lg font-medium hover:bg-[#8b5cf6] transition-colors"
            >
              Browse All Content
            </Link>
          </div>
        )}
      </main>

      <Footer />
    </div>
  );
}
