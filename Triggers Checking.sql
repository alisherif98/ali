/* Formatted on 31/01/2024 7:45:05 PM (QP5 v5.139.911.3011) */
--This Trigger Checks Whether The Insertion of The Student Courses and its ID into the Table of
-- Students_courses if this student belongs to the Department which

CREATE OR REPLACE TRIGGER check_courses_students
   BEFORE INSERT
   ON students_courses
   FOR EACH ROW
DECLARE
   stud_id    NUMBER (10);
   cour_id    NUMBER (10);
   stud_dep   NUMBER (10);
   cour_dep   NUMBER (10);
BEGIN
   stud_id := :NEW.student_id;
   cour_id := :NEW.course_id;

   SELECT department_id
     INTO stud_dep
     FROM students
    WHERE student_id = stud_id;

   SELECT department_id
     INTO cour_dep
     FROM courses
    WHERE course_id = cour_id;

   IF stud_dep != cour_dep
   THEN
      RAISE_APPLICATION_ERROR (
         -20001,
         'The Student Does not belong to the same department which is related to this subject');
   END IF;
END;


CREATE OR REPLACE TRIGGER updating_courses_students
   BEFORE update
   ON students_courses
   FOR EACH ROW
DECLARE
   stud_id    NUMBER (10);
   cour_id    NUMBER (10);
   stud_dep   NUMBER (10);
   cour_dep   NUMBER (10);
BEGIN
   stud_id := :NEW.student_id;
   cour_id := :NEW.course_id;

   SELECT department_id
     INTO stud_dep
     FROM students
    WHERE student_id = stud_id;

   SELECT department_id
     INTO cour_dep
     FROM courses
    WHERE course_id = cour_id;

   IF stud_dep != cour_dep
   THEN
      RAISE_APPLICATION_ERROR (
         -20001,
         'The Student Does not belong to the same department which is related to this subject');
   END IF;
END;




/* Formatted on 31/01/2024 7:44:56 PM (QP5 v5.139.911.3011) */
-- This Triger Checks For Update of Instructor Managment on Department
-- As If the Instructor Doesn't Belong To The Department Which Iis Going To Manage it Raises an Error

CREATE OR REPLACE TRIGGER check_head_update
   BEFORE UPDATE
   ON departments
   FOR EACH ROW
DECLARE
   instr_id    NUMBER (10);
   instr_dep   NUMBER (10);
BEGIN
   instr_id := :new.INSTRUCTOR_ID_MANAGE;

   SELECT department_id
     INTO instr_dep
     FROM instructors
    WHERE instructor_id = instr_id;

   IF :new.department_id != instr_dep
   THEN
      RAISE_APPLICATION_ERROR (
         -20001,
         'This Instructor cannot be Manager for That Department');
   END IF;
END;



/* Formatted on 31/01/2024 7:44:48 PM (QP5 v5.139.911.3011) */
-- This Trigger Checks The Insertion of Sudent Academic Profile whether This Sudent tooked This Course or Not

CREATE OR REPLACE TRIGGER checking_student_course
   BEFORE INSERT
   ON courses_info
   FOR EACH ROW

DECLARE
   cours_id         NUMBER (10);
   stud_id          NUMBER (10);

   CURSOR students_cur
   IS
      SELECT * FROM students_courses;

   checking_exist   BOOLEAN;
BEGIN
   checking_exist := FALSE;
   cours_id := :new.course_id;
   stud_id := :new.student_id;

   FOR val IN students_cur
   LOOP
      IF val.student_id = stud_id
      THEN
         IF val.course_id = cours_id
         THEN
            checking_exist := TRUE;
            EXIT;
         END IF;
      ELSE
         checking_exist := FALSE;
      END IF;
   END LOOP;

   IF checking_exist = FALSE
   THEN
      RAISE_APPLICATION_ERROR (-20001,
                               'This Student did not Study This Course');
   END IF;
END;



/* Formatted on 31/01/2024 11:53:55 PM (QP5 v5.139.911.3011) */
-- This Trigger Checks The insertion of Data in Courses Table Whether the inserted instructor and the department
-- Belongs To each other or not

CREATE OR REPLACE TRIGGER check_course_insertion
   BEFORE INSERT
   ON courses
   FOR EACH ROW
DECLARE
   instr_id    NUMBER (10);
   instr_dep   NUMBER (10);
BEGIN
   instr_id := :new.instructor_id;

   SELECT department_id
     INTO instr_dep
     FROM instructors
    WHERE instructor_id = instr_id;

   IF :new.department_id != instr_dep
   THEN
      RAISE_APPLICATION_ERROR (
         -20001,
         'This Instructor did not belong to Course department inserted');
   END IF;
END;



