CREATE TABLE Students(
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    program_major VARCHAR(100),
    cohort_year INT,
    gpa NUMERIC(3,2)
);

CREATE TABLE Schools (
    school_id SERIAL PRIMARY KEY,
    school_name VARCHAR(100),
    district VARCHAR(100),
    grade_levels VARCHAR(20)
);

CREATE TABLE Mentors (
    mentor_id SERIAL PRIMARY KEY,
    mentor_name VARCHAR(100),
    subject_area VARCHAR(50),
    years_experience INT
);

CREATE TABLE Supervisors (
    supervisor_id SERIAL PRIMARY KEY,
    supervisor_name VARCHAR(100),
    department VARCHAR(50)
);

CREATE TABLE Placements (
    placement_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES Students(student_id),
    school_id INT REFERENCES Schools(school_id),
    mentor_id INT REFERENCES Mentors(mentor_id),
    supervisor_id INT REFERENCES Supervisors(supervisor_id),
    placement_term VARCHAR(20),
    status VARCHAR(20),
    final_eval_score NUMERIC(4,1),
    start_date DATE,
    end_date DATE
);



INSERT INTO Students (first_name, last_name, program_major, cohort_year, gpa) VALUES
('Alice','Johnson','Elementary Education',2022,3.5),
('Brian','Smith','Secondary Math',2023,3.8),
('Chloe','Lee','Special Education',2021,3.2),
('David','Martinez','Secondary English',2023,3.6),
('Ella','Nguyen','Elementary Education',2022,3.9);

INSERT INTO Schools (school_name, district, grade_levels) VALUES
('Oakwood Elementary','Metro Nashville','K-5'),
('Riverside Middle','Rutherford County','6-8'),
('Franklin High','Williamson County','9-12'),
('Maple Grove Elementary','Metro Nashville','K-5');

INSERT INTO Mentors (mentor_name, subject_area, years_experience) VALUES
('Karen Thompson','Math',10),
('Michael Adams','English',15),
('Sarah Patel','Special Education',7),
('John Carter','Elementary',5);

INSERT INTO Supervisors (supervisor_name, department) VALUES
('Dr. Wilson','Education'),
('Prof. Brooks','Special Education'),
('Dr. Bennett','English');

INSERT INTO Placements (student_id, school_id, mentor_id, supervisor_id, placement_term, status, final_eval_score, start_date, end_date) VALUES
(1,1,4,1,'Fall 2024','Completed',92.5,'2024-08-15','2024-12-10'),
(2,3,1,1,'Fall 2024','Completed',88.0,'2024-08-20','2024-12-12'),
(3,2,3,2,'Spring 2024','Completed',85.5,'2024-01-10','2024-04-25'),
(4,3,2,3,'Fall 2024','In Progress',NULL,'2024-08-20','2024-12-12'),
(5,4,4,1,'Fall 2024','Completed',95.0,'2024-08-18','2024-12-10');

SELECT * FROM Students;
SELECT * FROM Schools;
SELECT * FROM Mentors;
SELECT * FROM Supervisors;
SELECT * FROM Placements;