-- Complex join to show project details with skills, images, and categories
SELECT 
    p.title AS project_title,
    p.description,
    p.github_url,
    p.live_url,
    u.username AS project_owner,
    GROUP_CONCAT(DISTINCT s.name ORDER BY s.name SEPARATOR ', ') AS skills_used,
    GROUP_CONCAT(DISTINCT pi.image_url SEPARATOR ';') AS project_images,
    pc.project_category_name
FROM projects p
INNER JOIN users u ON p.user_id = u.user_id
LEFT JOIN project_skills ps ON p.project_id = ps.project_id
LEFT JOIN skills s ON ps.skill_id = s.skill_id
LEFT JOIN project_images pi ON p.project_id = pi.project_id
LEFT JOIN project_categories pc ON p.category_id = pc.category_id
GROUP BY 
    p.project_id, 
    p.title, 
    p.description, 
    p.github_url, 
    p.live_url,
    u.username,
    pc.project_category_name
ORDER BY p.title;

-- Join to show user skills with proficiency
SELECT 
    u.username,
    s.name AS skill_name,
    us.proficiency_level,
    s.category AS skill_category
FROM users u
INNER JOIN user_skills us ON u.user_id = us.user_id
INNER JOIN skills s ON us.skill_id = s.skill_id
ORDER BY u.username, s.category, s.name;