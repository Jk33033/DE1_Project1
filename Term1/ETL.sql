-- Analytical Layer
DROP PROCEDURE IF EXISTS CreateUWStudy;
DELIMITER //
CREATE PROCEDURE CreateUWStudy()
BEGIN
	DROP TABLE IF EXISTS uwperson; --make a table which is used to JOIN
	CREATE TABLE uwperson
	SELECT
		p.p_id,
        p.professor,
		p.student,
		p.inPhase,
		RIGHT(p.yearsInProgram, 1) AS years, -- the original variable is like "Year_2"
		a.p_id_dummy,
		t.course_id,
		RIGHT(c.courseLevel, 3) AS level -- the original variable is like "Level_500"
	FROM person p
	LEFT JOIN advisedBy a  ON (p.p_id = a.p_id) -- p_id is personal ID 
	LEFT JOIN taughtBy t ON (p.p_id = t.p_id)
	LEFT JOIN course c USING(course_id) -- course id can connect person and course level
	ORDER BY p_id;
END //
DELIMITER ;

CALL CreateUWStudy(); 

-- Create Data Marts
DROP PROCEDURE IF EXISTS DataMarts;
DELIMITER $$
CREATE PROCEDURE DataMarts()
BEGIN

DROP VIEW IF EXISTS Post_Generals;
CREATE VIEW Post_Generals AS
SELECT * FROM uwperson WHERE inPhase = 'Post_Generals'; --see the characteristic of Post_Generals

DROP VIEW IF EXISTS Level_500;
CREATE VIEW Level_500 AS
SELECT * FROM uwperson WHERE level = 500; --see the characteristic of level 500 course
END$$
DELIMITER ;

-- Create Event
DROP EVENT IF EXISTS UWStudyEvent;
DELIMITER $$
CREATE EVENT UWStudyEvent
ON SCHEDULE EVERY 1 MINUTE
STARTS CURRENT_TIMESTAMP
ENDS CURRENT_TIMESTAMP + INTERVAL 1 HOUR
DO
	BEGIN
		INSERT INTO messages SELECT CONCAT('current time:',NOW());
    		CALL CreateUWStudent();
            CALL DataMarts();
	END$$
DELIMITER ;