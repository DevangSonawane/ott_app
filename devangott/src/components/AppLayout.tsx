import type { ReactNode } from 'react';
import { SideNav } from '@/components/SideNav';

interface AppLayoutProps {
  children: ReactNode;
}

export function AppLayout({ children }: AppLayoutProps) {
  return (
    <div className="min-h-screen bg-[#020202]">
      <SideNav />
      <div className="sm:pl-20">
        {children}
      </div>
    </div>
  );
}
