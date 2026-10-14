// @ts-nocheck
import React from 'react';
import { useModelStore, useOrganization, useModelShow } from '@rhino-dev/rhino-react';
import CreatePostVendored from './CreatePost.vendored';

export default function CreatePost() {
  const createPost = useModelStore('post');
  const { data: account } = useModelShow('account', null);
  const organization = useOrganization();

  const handleSave = async (data) => {
    try {
      await createPost.mutateAsync({
        ...data,
        organization_id: organization,
        user_id: account?.id,
        published_at: data.status === 'Published' ? new Date().toISOString() : null,
      });
    } catch(e) {
      console.error(e);
      throw e;
    }
  };

  return (
    <CreatePostVendored
      onSaveDraft={handleSave}
      onPublish={handleSave}
    />
  );
}
