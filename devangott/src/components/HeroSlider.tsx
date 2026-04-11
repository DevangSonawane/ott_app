import { useState, useEffect, useCallback } from 'react';
import { Play, Plus, ChevronLeft, ChevronRight, Info } from 'lucide-react';
import { heroSlides } from '@/data/content';

export function HeroSlider() {
  const [currentSlide, setCurrentSlide] = useState(0);
  const [isAnimating, setIsAnimating] = useState(false);
  const [mousePosition, setMousePosition] = useState({ x: 0, y: 0 });

  const goToSlide = useCallback((index: number) => {
    if (isAnimating) return;
    setIsAnimating(true);
    setCurrentSlide(index);
    setTimeout(() => setIsAnimating(false), 800);
  }, [isAnimating]);

  const nextSlide = useCallback(() => {
    goToSlide((currentSlide + 1) % heroSlides.length);
  }, [currentSlide, goToSlide]);

  const prevSlide = useCallback(() => {
    goToSlide((currentSlide - 1 + heroSlides.length) % heroSlides.length);
  }, [currentSlide, goToSlide]);

  useEffect(() => {
    const interval = setInterval(nextSlide, 8000);
    return () => clearInterval(interval);
  }, [nextSlide]);

  useEffect(() => {
    const handleMouseMove = (e: MouseEvent) => {
      const x = (e.clientX / window.innerWidth - 0.5) * 2;
      const y = (e.clientY / window.innerHeight - 0.5) * 2;
      setMousePosition({ x, y });
    };

    window.addEventListener('mousemove', handleMouseMove, { passive: true });
    return () => window.removeEventListener('mousemove', handleMouseMove);
  }, []);

  const slide = heroSlides[currentSlide];

  return (
    <section className="relative w-full h-screen overflow-hidden">
      {/* Background Images */}
      <div className="absolute inset-0">
        {heroSlides.map((s, index) => (
          <div
            key={s.id}
            className={`absolute inset-0 transition-all duration-1000 ${
              index === currentSlide
                ? 'opacity-100 scale-100'
                : 'opacity-0 scale-105'
            }`}
            style={{
              transform: `translate(${mousePosition.x * -10}px, ${mousePosition.y * -10}px) scale(${index === currentSlide ? 1 : 1.05})`,
              transition: index === currentSlide ? 'transform 0.3s ease-out, opacity 1s ease-out' : 'opacity 1s ease-out',
            }}
          >
            <img
              src={s.image}
              alt={s.title}
              className="w-full h-full object-cover"
            />
          </div>
        ))}

        {/* Gradient Overlays */}
        <div className="absolute inset-0 bg-gradient-to-r from-black/80 via-black/40 to-transparent" />
        <div className="absolute inset-0 bg-gradient-to-t from-[#020202] via-transparent to-black/40" />
      </div>

      {/* Content */}
      <div className="relative h-full flex items-center">
        <div className="max-w-[1400px] mx-auto px-4 sm:px-6 lg:px-10 w-full pt-20">
          <div className="max-w-2xl">
            {/* Meta */}
            <div
              key={`meta-${currentSlide}`}
              className="flex items-center gap-3 text-sm text-white/80 mb-4 animate-fade-in"
              style={{ animationDelay: '200ms' }}
            >
              <span className="text-[#7c3aed] font-semibold">theFlashx</span>
              <span className="w-1 h-1 bg-white/40 rounded-full" />
              <span>{slide.meta}</span>
            </div>

            {/* Title */}
            <h1
              key={`title-${currentSlide}`}
              className="text-4xl sm:text-5xl lg:text-6xl font-bold text-white mb-6 leading-tight"
              style={{
                fontFamily: 'Inter Tight, sans-serif',
                animation: 'slideUp 0.8s var(--ease-expo-out) forwards',
              }}
            >
              {slide.title}
            </h1>

            {/* Description */}
            <p
              key={`desc-${currentSlide}`}
              className="text-base sm:text-lg text-white/80 mb-8 line-clamp-3"
              style={{
                animation: 'fadeIn 0.6s var(--ease-smooth) 0.3s forwards',
                opacity: 0,
              }}
            >
              {slide.description}
            </p>

            {/* CTAs */}
            <div
              className="flex flex-wrap items-center gap-4"
              style={{
                animation: 'slideUp 0.5s var(--ease-expo-out) 0.5s forwards',
                opacity: 0,
              }}
            >
              <button className="flex items-center gap-2 px-6 py-3 bg-white text-black rounded font-semibold hover:bg-white/90 hover:scale-105 transition-all duration-300 group">
                <Play className="w-5 h-5 fill-black group-hover:rotate-[15deg] transition-transform" />
                Watch Now
              </button>
              <button className="flex items-center gap-2 px-6 py-3 bg-white/20 backdrop-blur-sm text-white rounded font-semibold hover:bg-white/30 hover:scale-105 transition-all duration-300">
                <Plus className="w-5 h-5" />
                Add to List
              </button>
              <button className="flex items-center gap-2 px-4 py-3 bg-transparent text-white/80 hover:text-white transition-colors">
                <Info className="w-5 h-5" />
                More Info
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Navigation Arrows */}
      <button
        onClick={prevSlide}
        className="absolute left-4 top-1/2 -translate-y-1/2 w-12 h-12 flex items-center justify-center bg-black/40 backdrop-blur-sm rounded-full text-white/70 hover:text-white hover:bg-black/60 hover:scale-110 transition-all duration-300"
      >
        <ChevronLeft className="w-6 h-6" />
      </button>
      <button
        onClick={nextSlide}
        className="absolute right-4 top-1/2 -translate-y-1/2 w-12 h-12 flex items-center justify-center bg-black/40 backdrop-blur-sm rounded-full text-white/70 hover:text-white hover:bg-black/60 hover:scale-110 transition-all duration-300"
      >
        <ChevronRight className="w-6 h-6" />
      </button>

      {/* Pagination Dots removed */}
    </section>
  );
}
