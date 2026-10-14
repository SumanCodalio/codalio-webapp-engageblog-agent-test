import yaml
with open('server/.rhino/blueprints/posts.yaml', 'r') as f:
    doc = yaml.safe_load(f)
doc['permissions']['admin']['create_fields'] = '*'
doc['permissions']['admin']['update_fields'] = '*'
doc['permissions']['admin']['read_fields'] = '*'
doc['permissions']['content_team_member']['create_fields'] = '*'
doc['permissions']['content_team_member']['update_fields'] = '*'
doc['permissions']['content_team_member']['read_fields'] = '*'
doc['permissions']['viewer']['read_fields'] = '*'
with open('server/.rhino/blueprints/posts.yaml', 'w') as f:
    yaml.dump(doc, f, sort_keys=False)
