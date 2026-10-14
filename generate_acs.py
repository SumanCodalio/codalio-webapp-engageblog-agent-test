import json

with open('../prd.json', 'r') as f:
    prd = json.load(f)

ac_list = []
counter = 1

# M: PRD ACs
for story in prd.get('user_stories', []):
    title = story.get('title', '')
    phase = story.get('phase', '')
    for ac in story.get('acceptance_criteria', []):
        ac_list.append({
            "id": f"AC-{counter}",
            "name": ac,
            "user_story": title,
            "phase": phase,
            "status": "pending",
            "subtasks": ["client/src/components/... (to be refined by develop)"]
        })
        counter += 1

# K: Extras
extras = [
    {
        "name": "Needs virtual attributes views, hasVideo, videoDuration, and date on Post.",
        "user_story": "Extra: Virtual attributes on Post",
        "phase": "Extras"
    },
    {
        "name": "A custom endpoint to aggregate content performance metrics for the Dashboard and Analytics pages.",
        "user_story": "Extra: Analytics Summary API",
        "phase": "Extras"
    },
    {
        "name": "Custom endpoints for fetching system performance metrics and settings for Admin screens.",
        "user_story": "Extra: Admin System Endpoints",
        "phase": "Extras"
    }
]
for extra in extras:
    ac_list.append({
        "id": f"AC-{counter}",
        "name": extra["name"],
        "user_story": extra["user_story"],
        "phase": extra["phase"],
        "status": "pending",
        "subtasks": ["server/app/... (to be refined by develop)"]
    })
    counter += 1

# G: Gaps
gaps = [
    {
        "name": "Admin viewing system settings and generating system reports is functional and accessible from the sidebar.",
        "user_story": "Gap compensation: Admin System Settings & Reports (SITEMAP_PAGE_NO_AC)",
        "phase": "Gap Compensation",
        "compensated_from_gap": "SITEMAP_PAGE_NO_AC"
    },
    {
        "name": "Admin Dashboard overview is functional and provides navigation/summary for the admin.",
        "user_story": "Gap compensation: Admin Dashboard Overview (SITEMAP_PAGE_NO_AC)",
        "phase": "Gap Compensation",
        "compensated_from_gap": "SITEMAP_PAGE_NO_AC"
    }
]
for gap in gaps:
    ac_list.append({
        "id": f"AC-{counter}",
        "name": gap["name"],
        "user_story": gap["user_story"],
        "phase": gap["phase"],
        "status": "pending",
        "compensated_from_gap": gap["compensated_from_gap"],
        "subtasks": ["client/src/components/... (to be refined by develop)"]
    })
    counter += 1

output = {
    "criteria": ac_list,
    "updated_at": "2023-10-26T00:00:00Z"
}

with open('.codalio/acceptance-criteria.json', 'w') as f:
    json.dump(output, f, indent=2)

