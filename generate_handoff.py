import json

handoff = {
  "pages": [
    {
      "name": "Landing",
      "prototype_route": "/",
      "rhino_route": "/",
      "auth": "authenticated",
      "roles": ["content_team_member", "admin"],
      "is_landing": False,
      "source_path": ".codalio/ui-prototype/files/pages/Landing.tsx",
      "page_file": "client/src/components/dashboard/Landing.tsx",
      "primary_model": "post",
      "hooks": ["useModelIndex('post')", "api.get('/api/analytics/summary')"],
      "data_contract": {
        "list_endpoint": "GET /api/posts",
        "list_response_keys": ["id", "title", "category", "readTime", "hasVideo", "videoDuration", "status", "views", "date"],
        "list_fixture_quote": [
          {
            "id": "post-1",
            "title": "How We Scaled Next-Gen Serverless Video Transcoding to 50k Concurrent Streams",
            "category": "Engineering",
            "readTime": "6 min read",
            "hasVideo": True,
            "videoDuration": "08:45",
            "status": "Published",
            "views": "48,290",
            "date": "May 14, 2025"
          }
        ],
        "notes": "Analytics summary injected via custom endpoint."
      },
      "section_type": "dashboard",
      "action_contract": [
        {
          "trigger": "Filter posts",
          "intent": "search or filter posts",
          "backend_op": "useModelIndex('post', { filter })",
          "payload_keys": [],
          "required_fks": {},
          "success": "list updates",
          "error": "show error",
          "satisfies_ac": "AC-1"
        }
      ]
    },
    {
      "name": "Login",
      "prototype_route": "/login",
      "rhino_route": "/login",
      "auth": "public",
      "roles": [],
      "is_landing": False,
      "source_path": ".codalio/ui-prototype/files/pages/Login.tsx",
      "page_file": "client/src/components/auth/Login.tsx",
      "primary_model": None,
      "hooks": ["useSignInAction()"],
      "section_type": "marketing",
      "notes": "Login page"
    },
    {
      "name": "CreatePost",
      "prototype_route": "/create-post",
      "rhino_route": "/create-post",
      "auth": "authenticated",
      "roles": ["content_team_member", "admin"],
      "is_landing": False,
      "source_path": ".codalio/ui-prototype/files/pages/CreatePost.tsx",
      "page_file": "client/src/components/post/CreatePost.tsx",
      "primary_model": "post",
      "hooks": ["useModelCreate('post')", "useModelUpdate('post')"],
      "section_type": "form",
      "action_contract": [
        {
          "trigger": "Save Draft / Publish",
          "intent": "create or update post",
          "backend_op": "useModelCreate('post') or useModelUpdate('post')",
          "payload_keys": ["title", "content", "status", "category", "read_time", "published_at"],
          "required_fks": { "organization_id": "useBaseOwnerId()", "user_id": "useUser()?.id" },
          "success": "navigate to /",
          "error": "show form errors",
          "satisfies_ac": "AC-1"
        }
      ]
    },
    {
      "name": "MediaLibrary",
      "prototype_route": "/media-library",
      "rhino_route": "/media-library",
      "auth": "authenticated",
      "roles": ["content_team_member", "admin"],
      "is_landing": False,
      "source_path": ".codalio/ui-prototype/files/pages/MediaLibrary.tsx",
      "page_file": "client/src/components/media/MediaLibrary.tsx",
      "primary_model": "video",
      "hooks": ["useModelIndex('video')", "useModelCreate('video')"],
      "data_contract": {
        "list_endpoint": "GET /api/videos",
        "list_response_keys": ["id", "title", "type", "format", "size", "duration", "resolution", "bitrate", "url", "thumbnail", "uploadedBy", "uploadedAt"],
        "list_fixture_quote": [
          {
            "id": "media-1",
            "title": "Keynote 2025 Architecture Walkthrough",
            "type": "video",
            "format": "mp4",
            "size": "184.2 MB",
            "duration": "12:40",
            "resolution": "4K UHD (3840x2160)",
            "bitrate": "12.4 Mbps",
            "url": "https://cdn.contentreach.io/hls/v1/keynote-2025/master.m3u8",
            "thumbnail": "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=500&q=80",
            "uploadedBy": "Sarah Chen",
            "uploadedAt": "May 14, 2025",
            "associatedPosts": 1
          }
        ],
        "notes": ""
      },
      "section_type": "list",
      "action_contract": [
        {
          "trigger": "Upload video",
          "intent": "create video",
          "backend_op": "useModelCreate('video')",
          "payload_keys": ["title", "url", "format", "size", "duration", "resolution", "bitrate", "thumbnail"],
          "required_fks": { "organization_id": "useBaseOwnerId()", "user_id": "useUser()?.id" },
          "success": "invalidate query",
          "error": "show error",
          "satisfies_ac": "AC-3"
        }
      ]
    },
    {
      "name": "Analytics",
      "prototype_route": "/analytics",
      "rhino_route": "/analytics",
      "auth": "authenticated",
      "roles": ["content_team_member", "admin"],
      "is_landing": False,
      "source_path": ".codalio/ui-prototype/files/pages/Analytics.tsx",
      "page_file": "client/src/components/analytics/Analytics.tsx",
      "primary_model": None,
      "hooks": ["api.get('/api/analytics/summary')"],
      "section_type": "dashboard",
      "action_contract": [
        {
          "trigger": "Filter date",
          "intent": "refresh analytics",
          "backend_op": "api.get('/api/analytics/summary')",
          "payload_keys": ["dateRange"],
          "required_fks": {},
          "success": "update chart",
          "error": "show error",
          "satisfies_ac": "AC-9"
        }
      ]
    },
    {
      "name": "Admin",
      "prototype_route": "/admin",
      "rhino_route": "/admin",
      "auth": "authenticated",
      "roles": ["admin"],
      "is_landing": False,
      "source_path": ".codalio/ui-prototype/files/pages/Admin.tsx",
      "page_file": "client/src/components/admin/Admin.tsx",
      "primary_model": None,
      "hooks": ["api.get('/api/admin/system_summary')"],
      "section_type": "dashboard",
      "action_contract": [
        {
          "trigger": "View metrics",
          "intent": "load admin dashboard",
          "backend_op": "api.get('/api/admin/system_summary')",
          "payload_keys": [],
          "required_fks": {},
          "success": "render",
          "error": "error",
          "satisfies_ac": "AC-18"
        }
      ]
    },
    {
      "name": "AdminUsers",
      "prototype_route": "/admin/users",
      "rhino_route": "/admin/users",
      "auth": "authenticated",
      "roles": ["admin"],
      "is_landing": False,
      "source_path": ".codalio/ui-prototype/files/pages/AdminUsers.tsx",
      "page_file": "client/src/components/admin/AdminUsers.tsx",
      "primary_model": "user",
      "hooks": ["useModelIndex('user')", "useModelCreate('user')", "useModelUpdate('user')", "useModelDestroy('user')"],
      "section_type": "list",
      "action_contract": [
        {
          "trigger": "Add User",
          "intent": "create user",
          "backend_op": "useModelCreate('user')",
          "payload_keys": ["email", "first_name", "last_name", "password"],
          "required_fks": { "organization_id": "useBaseOwnerId()" },
          "success": "invalidate query",
          "error": "show error",
          "satisfies_ac": "AC-6"
        }
      ]
    },
    {
      "name": "AdminApiIntegrations",
      "prototype_route": "/admin/api-integrations",
      "rhino_route": "/admin/api-integrations",
      "auth": "authenticated",
      "roles": ["admin"],
      "is_landing": False,
      "source_path": ".codalio/ui-prototype/files/pages/AdminApiIntegrations.tsx",
      "page_file": "client/src/components/admin/AdminApiIntegrations.tsx",
      "primary_model": None,
      "hooks": [],
      "section_type": "form",
      "action_contract": [
        {
          "trigger": "Save API Key",
          "intent": "update integration",
          "backend_op": "null",
          "payload_keys": [],
          "required_fks": {},
          "success": "show toast",
          "error": "error",
          "satisfies_ac": "AC-10"
        }
      ]
    },
    {
      "name": "AdminSystemSettings",
      "prototype_route": "/admin/system-settings",
      "rhino_route": "/admin/system-settings",
      "auth": "authenticated",
      "roles": ["admin"],
      "is_landing": False,
      "source_path": ".codalio/ui-prototype/files/pages/AdminSystemSettings.tsx",
      "page_file": "client/src/components/admin/AdminSystemSettings.tsx",
      "primary_model": None,
      "hooks": [],
      "section_type": "form",
      "action_contract": [
        {
          "trigger": "Save Settings",
          "intent": "update system config",
          "backend_op": "null",
          "payload_keys": [],
          "required_fks": {},
          "success": "toast",
          "error": "error",
          "satisfies_ac": "AC-17"
        }
      ]
    },
    {
      "name": "AdminSystemReports",
      "prototype_route": "/admin/system-reports",
      "rhino_route": "/admin/system-reports",
      "auth": "authenticated",
      "roles": ["admin"],
      "is_landing": False,
      "source_path": ".codalio/ui-prototype/files/pages/AdminSystemReports.tsx",
      "page_file": "client/src/components/admin/AdminSystemReports.tsx",
      "primary_model": None,
      "hooks": [],
      "section_type": "list",
      "action_contract": [
        {
          "trigger": "Download Report",
          "intent": "generate report",
          "backend_op": "null",
          "payload_keys": [],
          "required_fks": {},
          "success": "download starts",
          "error": "error",
          "satisfies_ac": "AC-17"
        }
      ]
    }
  ],
  "shared": {
    "routing_scheme": "flat",
    "layout": "client/src/components/layout/AppLayout.tsx",
    "auth_redirect": "_authenticated route guard",
    "role_gate": "Pages with non-empty `roles` are gated by useRoles()",
    "roles_source": "server/.rhino/blueprints/_roles.yaml",
    "design_tokens_source": "./.codalio/ui-prototype/files/styles.css"
  }
}

with open('.codalio/ui-handoff.json', 'w') as f:
    json.dump(handoff, f, indent=2)

