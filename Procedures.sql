/* Formatted on 31/01/2024 8:11:37 PM (QP5 v5.139.911.3011) */
--This Procedure For updating Specific subject for specific student as it takes parameters of student_id and old subject_id and new subject_id

CREATE OR REPLACE PROCEDURE update_subject (stud_id          NUMBER,
                                            old_course_id    NUMBER,
                                            new_course_id    NUMBER)
IS
BEGIN
   UPDATE students_courses
      SET course_id = new_course_id
    WHERE student_id = stud_id AND course_id = old_course_id;
END;


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/* Formatted on 31/01/2024 8:12:44 PM (QP5 v5.139.911.3011) */
-- This Procedure for insertion New Data about student and its subject studying
-- As it takes the student_id and subject_id

CREATE OR REPLACE PROCEDURE insert_subject_student (stud_id     NUMBER,
                                                    cours_id    NUMBER)
IS
BEGIN
   INSERT INTO students_courses (student_id, course_id)
        VALUES (stud_id, cours_id);
END;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/* Formatted on 31/01/2024 10:29:42 PM (QP5 v5.139.911.3011) */
-- This Procedure Updates The Head of Department (Instructor)

CREATE OR REPLACE PROCEDURE update_head_dep (instr_id NUMBER, dep_id NUMBER)
IS
BEGIN
   UPDATE departments
      SET INSTRUCTOR_ID_MANAGE = instr_id
    WHERE department_id = dep_id;
END;

/* Formatted on 31/01/2024 10:29:47 PM (QP5 v5.139.911.3011) */
--Calling Update head department procedure 
DECLARE
BEGIN
   update_head_dep (4, 5);
END;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* Formatted on 31/01/2024 11:55:33 PM (QP5 v5.139.911.3011) */
-- This Procedue for Insertion of New Course Data

CREATE OR REPLACE PROCEDURE insertion_courses (cours_id         NUMBER,
                                               coursename       VARCHAR2,
                                               coursecredits    NUMBER,
                                               instructorid     NUMBER,
                                               departmentid     NUMBER)
IS
BEGIN
   INSERT INTO courses (COURSE_ID,
                        COURSE_NAME,
                        COURSE_CREDITS,
                        INSTRUCTOR_ID,
                        DEPARTMENT_ID)
        VALUES (cours_id,
                coursename,
                coursecredits,
                instructorid,
                departmentid);
END;

/* Formatted on 04/02/2024 9:11:56 PM (QP5 v5.139.911.3011) */
-- Calling insertion courses procedure

BEGIN
   insertion_courses (32,
                      'Linear Algebra',
                      3,
                      5,
                      3);
END;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* Formatted on 04/02/2024 9:09:08 PM (QP5 v5.139.911.3011) */
-- This Procedure insert into Academic Year Info Table sime values as it takes two parameters student id and year wanted to insert in its value
-- This procedure uses function called yearly_GPA which calculate accumulative yearly GPA
CREATE OR REPLACE PROCEDURE Aca_year_info_insert (stud_id     NUMBER,
                                                  year_val    NUMBER)
IS
BEGIN
   INSERT INTO academic_year_info (year, student_id, ACCUMLATIVE_GPA)
        VALUES (year_val, stud_id, yearly_GPA (stud_id, year_val));
END;

BEGIN
   Aca_year_info_insert (1, 2020);
END;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Formatted on 05/02/2024 11:00:42 AM (QP5 v5.139.911.3011) */
-- This Procedure is used for insertion of new instructor

CREATE OR REPLACE PROCEDURE insertion_instructor (id_value         NUMBER,
                                                  ssn_val          NUMBER,
                                                  first_na         VARCHAR2,
                                                  midd_na          VARCHAR2,
                                                  last_na          VARCHAR2,
                                                  sex_val          VARCHAR,
                                                  DOB_val          VARCHAR2,
                                                  city_val         VARCHAR2,
                                                  region_val       VARCHAR2,
                                                  street_val       VARCHAR2,
                                                  depart_id_val    NUMBER)
IS
   months_val   NUMBER (8, 2);
BEGIN
   months_val := MONTHS_BETWEEN (SYSDATE, TO_DATE (DOB_val, 'DD/MM/YYYY'));

   INSERT INTO instructors (INSTRUCTOR_ID,
                            SSN,
                            FIRS_NAME,
                            MIDDLE_NAME,
                            LAST_NAME,
                            SEX,
                            DOB,
                            CITY,
                            REGION,
                            STREET,
                            EMAIL,
                            AGE,
                            DEPARTMENT_ID)
        VALUES (
           id_value,
           ssn_val,
           first_na,
           midd_na,
           last_na,
           sex_val,
           TO_DATE (DOB_val, 'DD/MM/YYYY'),
           city_val,
           region_val,
           street_val,
           first_na || '-' || last_na || id_value || '@instr-modern.com',
           TRUNC (months_val / 12),
           depart_id_val);
END;


/* Formatted on 05/02/2024 11:01:08 AM (QP5 v5.139.911.3011) */
-- calling insertion_instructor procedure

BEGIN
   insertion_instructor (30,
                         14587,
                         'Ahmed',
                         'Mohamed',
                         'Ebrahim',
                         'M',
                         '25/09/1980',
                         'cairo',
                         'zamalek',
                         'anything',
                         3);
END;


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* Formatted on 05/02/2024 11:00:19 AM (QP5 v5.139.911.3011) */
-- This Procedure is used for insertion of new student

CREATE OR REPLACE PROCEDURE insertion_student (id_value         NUMBER,
                                               ssn_val          NUMBER,
                                               first_na         VARCHAR2,
                                               midd_na          VARCHAR2,
                                               last_na          VARCHAR2,
                                               sex_val          VARCHAR,
                                               DOB_val          VARCHAR2,
                                               city_val         VARCHAR2,
                                               region_val       VARCHAR2,
                                               street_val       VARCHAR2,
                                               depart_id_val    NUMBER)
IS
   months_val   NUMBER (8, 2);
BEGIN
   months_val := MONTHS_BETWEEN (SYSDATE, TO_DATE (DOB_val, 'DD/MM/YYYY'));

   INSERT INTO students (STUDENT_ID,
                         SSN,
                         FIRS_NAME,
                         MIDDLE_NAME,
                         LAST_NAME,
                         SEX,
                         DOB,
                         CITY,
                         REGION,
                         STREET,
                         EMAIL,
                         AGE,
                         DEPARTMENT_ID)
        VALUES (id_value,
                ssn_val,
                first_na,
                midd_na,
                last_na,
                sex_val,
                TO_DATE (DOB_val, 'DD/MM/YYYY'),
                city_val,
                region_val,
                street_val,
                first_na || '-' || last_na || id_value || '@stud-modern.com',
                TRUNC (months_val / 12),
                depart_id_val);
END;

/* Formatted on 05/02/2024 11:00:11 AM (QP5 v5.139.911.3011) */
-- calling insertion_student procedure

BEGIN
   insertion_student (30,
                      14587,
                      'Ahmed',
                      'Mohamed',
                      'Ebrahim',
                      'M',
                      '25/09/2000',
                      'cairo',
                      'zamalek',
                      'anything',
                      3);
END;
