import json
with open('.codalio/acceptance-criteria.json', 'r') as f:
    data = json.load(f)

for ac in data['criteria']:
    if "admin" in ac['name'].lower() or "admin" in ac['user_story'].lower():
        ac['subtasks'] = ["client/src/components/admin/Admin.tsx + route in client/src/routes/custom.jsx"]
    elif "video" in ac['name'].lower() or "video" in ac['user_story'].lower():
        ac['subtasks'] = ["client/src/components/media/MediaLibrary.tsx + route in client/src/routes/custom.jsx"]
    elif "post" in ac['name'].lower() or "post" in ac['user_story'].lower():
        ac['subtasks'] = ["client/src/components/post/CreatePost.tsx + route in client/src/routes/custom.jsx"]
    elif "analytic" in ac['name'].lower() or "analytic" in ac['user_story'].lower() or "performance" in ac['name'].lower():
        ac['subtasks'] = ["client/src/components/analytics/Analytics.tsx + route in client/src/routes/custom.jsx"]
    elif "logout" in ac['name'].lower() or "login" in ac['name'].lower():
        ac['subtasks'] = ["client/src/components/auth/Login.tsx + route in client/src/routes/custom.jsx"]
    elif "backup" in ac['name'].lower():
        ac['subtasks'] = ["server/lib/tasks/backup.rake"]
    elif "role" in ac['name'].lower() or "access" in ac['name'].lower():
        ac['subtasks'] = ["client/src/routes/custom.jsx (useRoles guard)"]
    elif "data model" in ac['name'].lower():
        ac['subtasks'] = ["server/.rhino/blueprints/posts.yaml"]
    elif "Virtual attributes" in ac['name']:
        ac['subtasks'] = ["server/app/serializers/post_serializer.rb"]
    elif "Analytics Summary API" in ac['name']:
        ac['subtasks'] = ["server/app/controllers/api/analytics_controller.rb"]
    elif "Admin System Endpoints" in ac['name']:
        ac['subtasks'] = ["server/app/controllers/api/admin/system_controller.rb"]
    else:
        ac['subtasks'] = ["client/src/routes/custom.jsx"]

    # Also fix some specific ones to match concrete anchors
    if "data model stores" in ac['name']:
        ac['subtasks'] = ["server/.rhino/blueprints/posts.yaml (or respective model)"]

with open('.codalio/acceptance-criteria.json', 'w') as f:
    json.dump(data, f, indent=2)
