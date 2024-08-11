import gitlab
import csv
import warnings

# Hardcoded GitLab token
GL_TOKEN = "glpat-t6TnrxhRanaLFYuS8h4S"
GL_DOMAIN = "https://gitlab.com/api/v4/"  # GitLab URL

warnings.filterwarnings("ignore")

print("START-- GITLAB CONNECTION")

# Initialize GitLab connection
gl = gitlab.Gitlab(url=GL_DOMAIN, private_token=GL_TOKEN, ssl_verify=False)
gl.auth()

print("ESTABLISHED GITLAB CONNECTION")

print("GETTING GROUPS")

# Fetch all groups
groups = gl.groups.list(all=True)

# Write group and project details to CSV file
with open('GitlabSaaS_Report1_group-project_tmp.csv', 'w', encoding='UTF-8') as pfile:
    writer2 = csv.writer(pfile)
    writer2.writerow(["Group ID", "Group path", "Project ID", "Project Name"])
    
    for grp in groups:
        print(f"Processing group: {grp.full_path} (ID: {grp.id})")
        projects = grp.projects.list(include_subgroups=True, all=True)
        
        for project in projects:
            nm = project.namespace
            print(f"{grp.id}, {nm['full_path']}, {project.id}, {project.name}")
            writer2.writerow([grp.id, nm['full_path'], project.id, project.name])

print("Finished writing to CSV file.")