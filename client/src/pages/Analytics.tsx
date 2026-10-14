// @ts-nocheck
// @ts-nocheck
import React from 'react';
import { useQuery } from '@tanstack/react-query';
import { api, useOrganization } from '@rhino-dev/rhino-react';
import AnalyticsVendored from './Analytics.vendored';
import { Eye, Clock, TrendingUp, Users } from 'lucide-react';

export default function Analytics() {
  const organization = useOrganization();

  const { data, isLoading } = useQuery({
    queryKey: ['analytics_summary', organization],
    queryFn: async () => {
      const res = await api.get('/api/analytics/summary');
      return res.data;
    }
  });

  if (isLoading) return <div className="p-8">Loading analytics...</div>;

  const initialCards = data ? [
    {
      label: "Total Impressions",
      value: data.views?.toLocaleString() || "0",
      change: "+0.0%",
      detail: "vs previous period",
      icon: Eye,
    },
    {
      label: "Audience Watch Time",
      value: "0 hrs", // Mapped from missing backend data, fallback to mock
      change: "+0.0%",
      detail: "3.2 mins avg per session",
      icon: Clock,
    },
    {
      label: "Engagement Rate",
      value: data.shares ? ((data.shares / (data.views || 1)) * 100).toFixed(1) + "%" : "0%",
      change: "+0.0%",
      detail: "4.8% video conversion",
      icon: TrendingUp,
    },
    {
      label: "Unique Readers",
      value: data.unique_visitors?.toLocaleString() || "0",
      change: "+0.0%",
      detail: "Organic search & social",
      icon: Users,
    }
  ] : null;

  return (
    <AnalyticsVendored initialCards={initialCards} />
  );
}
