// @ts-nocheck
// @ts-nocheck
import React from 'react';
import { useModelIndex, useModelUpdate, useModelDelete } from '@rhino-dev/rhino-react';
import LandingVendored from './Landing.vendored';

export default function Landing() {
  const { data: postsData, isPending } = useModelIndex('post');
  const updatePost = useModelUpdate('post');
  const destroyPost = useModelDelete('post');

  if (isPending) return <div className="p-8">Loading...</div>;

  const uiPosts = (postsData?.data || []).map((p) => ({
    id: p.id.toString(),
    title: p.title,
    category: p.category || 'General',
    readTime: p.read_time || '5 min read',
    hasVideo: p.videos && p.videos.length > 0,
    videoDuration: p.videos && p.videos[0] ? String(p.videos[0].duration) + "s" : "",
    status: p.status,
    views: p.views || "0",
    date: p.published_at ? new Date(p.published_at).toLocaleDateString() : 'Draft'
  }));

  const handleDeletePost = async (id) => {
    try {
      await destroyPost.mutateAsync(id);
    } catch(e) {
      console.error(e);
    }
  };

  const handleBatchDelete = async (ids) => {
    for (const id of ids) {
      await handleDeletePost(id);
    }
  };

  const handleBatchPublish = async (ids) => {
    for (const id of ids) {
      try {
        await updatePost.mutateAsync({ id, data: { status: 'Published' } });
      } catch (e) {
        console.error(e);
      }
    }
  };

  return (
    <LandingVendored
      initialPosts={uiPosts}
      onDeletePost={handleDeletePost}
      onBatchDelete={handleBatchDelete}
      onBatchPublish={handleBatchPublish}
    />
  );
}
