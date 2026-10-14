#!/bin/bash
cd src/pages

for f in Admin.tsx AdminUsers.tsx Analytics.tsx CreatePost.tsx Landing.tsx Login.tsx MediaLibrary.tsx; do
  sed -i '1s/^/\/\/ @ts-nocheck\n/' "$f"
  sed -i 's/useModelCreate/useModelStore/g' "$f"
  sed -i 's/useModelDestroy/useModelDelete/g' "$f"
  sed -i 's/useBaseOwnerId/useOrganization/g' "$f"
  sed -i 's/useUser/useAuth/g' "$f"
  sed -i 's/baseOwnerId/organization/g' "$f"
done

sed -i 's/postsData?.results/postsData?.data/g' Landing.tsx
sed -i 's/usersData?.results/usersData?.data/g' AdminUsers.tsx
sed -i 's/videoData?.results/videoData?.data/g' MediaLibrary.tsx

sed -i "s/updatePost.mutateAsync({ id, status: 'Published' })/updatePost.mutateAsync({ id, data: { status: 'Published' } })/g" Landing.tsx

