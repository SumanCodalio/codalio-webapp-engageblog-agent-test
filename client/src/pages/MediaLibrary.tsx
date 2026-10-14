// @ts-nocheck
// @ts-nocheck
import React from 'react';
import { useModelIndex, useModelStore, useOrganization, useModelShow } from '@rhino-dev/rhino-react';
import MediaLibraryVendored from './MediaLibrary.vendored';

export default function MediaLibrary() {
  const { data: videoData, isPending } = useModelIndex('video');
  const createVideo = useModelStore('video');
  const { data: account } = useModelShow('account', null);
  const organization = useOrganization();

  if (isPending) return <div className="p-8">Loading...</div>;

  const uiAssets = (videoData?.data || []).map((v) => ({
    id: v.id.toString(),
    title: v.title,
    type: "video",
    format: "mp4",
    size: "100 MB", // Mocked size
    duration: v.duration ? `${Math.floor(v.duration / 60)}:${(v.duration % 60).toString().padStart(2, '0')}` : "0:00",
    resolution: "1080p",
    bitrate: "5 Mbps",
    url: v.url || "https://example.com/mock.mp4",
  }));

  const handleUploadAsset = async () => {
    try {
      await createVideo.mutateAsync({
        title: "New Uploaded Video",
        url: "https://example.com/new.mp4",
        duration: 120,
        organization_id: organization,
        user_id: account?.id,
      });
    } catch(e) {
      console.error(e);
      throw e;
    }
  };

  return (
    <MediaLibraryVendored
      initialAssets={uiAssets}
      onUploadAsset={handleUploadAsset}
    />
  );
}
