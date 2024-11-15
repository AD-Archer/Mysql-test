SELECT
	p.title AS project_title,
    p.description,
    p.github_url,
    p.live_url,
    GROUP_CONCAT(s.name ORDER BY s.name SEPARATOR ', ') AS skills_used
FROM projects p
INNER JOIN project_skills ps ON p.project_id = ps.project_id
INNER JOIN skills s on ps.skill_id = s.skill_id
GROUP BY p.project_id, p.title, p.description, p.github_url, p.live_url
ORDER BY p.title;