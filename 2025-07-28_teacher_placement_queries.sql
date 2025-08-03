-- Teacher Placement Analytics - Portfolio Project
-- This project demonstrates SQL skills including JOINs, GROUP BY, CASE statements,
-- subqueries, and window functions using a fictional teacher placement dataset.
-- Created: 2025-07-28

-- Query 1: List all students with placement details
SELECT
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.program_major,
    sc.school_name,
    m.mentor_name,
    sup.supervisor_name
FROM students AS s
INNER JOIN placements AS p ON s.student_id = p.student_id
INNER JOIN schools AS sc ON p.school_id = sc.school_id
INNER JOIN mentors AS m ON p.mentor_id = m.mentor_id
INNER JOIN supervisors AS sup ON p.supervisor_id = sup.supervisor_id;

-- Query 2: Count placements by district and term
SELECT
    sc.district,
    p.placement_term,
    COUNT(*) AS total_placements
FROM placements AS p
INNER JOIN schools AS sc ON p.school_id = sc.school_id
GROUP BY sc.district, p.placement_term
ORDER BY sc.district, p.placement_term;

-- Query 3: Find students with final evaluation score above 90
SELECT
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.program_major,
    sc.school_name,
    m.mentor_name,
    p.final_eval_score,
    p.placement_term
FROM students AS s
INNER JOIN placements AS p ON s.student_id = p.student_id
INNER JOIN schools AS sc ON p.school_id = sc.school_id
INNER JOIN mentors AS m ON p.mentor_id = m.mentor_id
WHERE p.final_eval_score > 90
ORDER BY p.final_eval_score DESC;

-- Query 4: Average GPA by program major for placed students
SELECT
    s.program_major,
    ROUND(AVG(s.gpa), 2) AS avg_gpa
FROM students AS s
INNER JOIN placements AS p ON s.student_id = p.student_id
GROUP BY s.program_major
ORDER BY s.program_major;

-- Query 5: Mentor with the most students supervised
SELECT
    m.mentor_name,
    COUNT(*) AS number_of_students
FROM placements AS p
INNER JOIN mentors AS m ON p.mentor_id = m.mentor_id
GROUP BY m.mentor_name
ORDER BY number_of_students DESC;

-- Query 6: Placements that are still "In Progress"
SELECT
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    sc.school_name,
    m.mentor_name,
    p.placement_term
FROM students AS s
INNER JOIN placements AS p ON s.student_id = p.student_id
INNER JOIN schools AS sc ON p.school_id = sc.school_id
INNER JOIN mentors AS m ON p.mentor_id = m.mentor_id
WHERE p.status = 'In Progress';

-- Query 7: Top 3 schools with highest average final evaluation scores
SELECT
    s.school_name,
    ROUND(AVG(p.final_eval_score), 2) AS avg_score
FROM schools AS s
INNER JOIN placements AS p ON s.school_id = p.school_id
WHERE p.status = 'Completed'
GROUP BY s.school_name
ORDER BY avg_score DESC
LIMIT 3;

-- Query 8: Count placements per supervisor per term
SELECT
    s.supervisor_name,
    p.placement_term,
    COUNT(*) AS count_per_term
FROM placements AS p
INNER JOIN supervisors AS s ON p.supervisor_id = s.supervisor_id
GROUP BY s.supervisor_name, p.placement_term
ORDER BY s.supervisor_name, p.placement_term;

-- Query 9: Categorize supervisors into High Load / Low Load
SELECT
    s.supervisor_name,
    COUNT(*) AS total_placements,
    CASE 
        WHEN COUNT(*) >= 2 THEN 'High Load'
        ELSE 'Low Load'
    END AS load_category
FROM placements AS p
INNER JOIN supervisors AS s ON p.supervisor_id = s.supervisor_id
GROUP BY s.supervisor_name
ORDER BY total_placements DESC;

-- Query 10: Students scoring above the average final evaluation score
SELECT
    s.first_name || ' ' || s.last_name AS student_name,
    p.final_eval_score
FROM students AS s
INNER JOIN placements AS p ON s.student_id = p.student_id
WHERE p.final_eval_score > (
    SELECT AVG(final_eval_score)
    FROM placements
    WHERE final_eval_score IS NOT NULL
);

-- Query 11: Rank schools by total placements
SELECT
    school_name,
    total_placements,
    RANK() OVER (ORDER BY total_placements DESC) AS placement_rank
FROM (
    SELECT s.school_name, COUNT(*) AS total_placements
    FROM placements AS p
    INNER JOIN schools AS s ON p.school_id = s.school_id
    GROUP BY s.school_name
) AS sub;

-- Query 12: Rank schools by average score within each district
WITH davg AS (
    SELECT
        sc.school_name,
        sc.district,
        AVG(p.final_eval_score) AS avg_score
    FROM schools AS sc
    INNER JOIN placements AS p ON sc.school_id = p.school_id
    WHERE p.final_eval_score IS NOT NULL
    GROUP BY sc.school_name, sc.district
)
SELECT
    school_name,
    district,
    avg_score,
    RANK() OVER (PARTITION BY district ORDER BY avg_score DESC) AS rank_in_district
FROM davg;
