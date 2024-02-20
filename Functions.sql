SET SERVEROUTPUT ON;

/* Formatted on 02/02/2024 2:15:44 PM (QP5 v5.139.911.3011) */
-- This Function Used For Returning Yearly GPA For Specific Student (Takes Student ID and year and Returns its Yearly GPA)

CREATE OR REPLACE FUNCTION yearly_GPA (stud_id NUMBER, year_val NUMBER)
   RETURN NUMBER
IS
   total_hours_courses     NUMBER (6) := 0;
   courses_points          NUMBER (6) := 0;
   GPA                     NUMBER (8, 2);
   cours_credits           NUMBER (6);
   student_passed_course   BOOLEAN;
   student_course          BOOLEAN;

   CURSOR courses_cur
   IS
      SELECT course_id,
             student_id,
             year,
             course_grade
        FROM courses_info;
BEGIN
   student_course := FALSE;
   student_passed_course := FALSE;

   FOR x IN courses_cur
   LOOP
      IF x.student_id = stud_id AND x.year = year_val
      THEN
         student_course := TRUE;
         EXIT;
      ELSE
         student_course := FALSE;
      END IF;
   END LOOP;

   IF student_course = TRUE
   THEN
      FOR val IN courses_cur
      LOOP
         IF year_val = val.year AND val.student_id = stud_id
         THEN
            IF val.course_grade >= 60
            THEN
               student_passed_course := TRUE;

               IF val.student_id = stud_id
               THEN
                  SELECT course_credits
                    INTO cours_credits
                    FROM courses
                   WHERE course_id = val.course_id;

                  total_hours_courses := total_hours_courses + cours_credits;

                  IF cours_credits = 3
                  THEN
                     courses_points := courses_points + 9.9;
                  ELSIF cours_credits = 2
                  THEN
                     courses_points := courses_points + 8;
                  ELSE
                     courses_points := courses_points + 0;
                  END IF;
               END IF;
            ELSE
               student_passed_course := FALSE;
            END IF;
         END IF;
      END LOOP;
   END IF;

   IF student_course = FALSE
   THEN
      RETURN 1;
   ELSIF student_passed_course = FALSE
   THEN
      RETURN 0;
   ELSIF total_hours_courses > 0
   THEN
      GPA := courses_points / total_hours_courses;
      RETURN GPA;
   ELSE
      RETURN NULL;
   END IF;
END;

/* Formatted on 02/02/2024 2:15:34 PM (QP5 v5.139.911.3011) */
-- Calling Yearl GPA Function

DECLARE
   val   NUMBER (8, 2);
BEGIN
   val := Yearly_GPA (1, 2020);

   IF val = 0
   THEN
      DBMS_OUTPUT.
      put_line ('Sorry !! This Student Did not Pass in some courses');
   ELSIF val = 1
   THEN
      DBMS_OUTPUT.
      put_line (
         'Sorry !! This Student Did not Take or Complete some courses Belong To Year Entered');
   ELSE
      DBMS_OUTPUT.put_line (val);
   END IF;
END;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* Formatted on 04/02/2024 9:05:57 PM (QP5 v5.139.911.3011) */
--This Function Calculate Total GPA for a Student (Takes Student id only)

CREATE OR REPLACE FUNCTION total_gpa (id_val NUMBER)
   RETURN NUMBER
IS
   GPA_val   NUMBER (8, 2);
BEGIN
   SELECT AVG (ACCUMLATIVE_GPA)
     INTO GPA_val
     FROM academic_year_info
    WHERE student_id = id_val;

   IF GPA_val IS NULL
   THEN
      RAISE_APPLICATION_ERROR (-20002, 'There is No Data Found');
   END IF;

   RETURN GPA_val;
END;

/* Formatted on 04/02/2024 9:05:45 PM (QP5 v5.139.911.3011) */
-- Calling Total_GPA Function
set serveroutput on

DECLARE
   val   NUMBER (8, 2);
BEGIN
   val := total_gpa (2);
   DBMS_OUTPUT.put_line (val);
END;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* Formatted on 02/02/2024 10:41:07 AM (QP5 v5.139.911.3011) */
--This Function Takes Student ID and Returns The Department Which This Student Belongs To

CREATE OR REPLACE FUNCTION getting_student_dep (student_id_val NUMBER)
   RETURN VARCHAR2
IS
   departmnet_val   VARCHAR2 (40);
BEGIN
   SELECT department_name
     INTO departmnet_val
     FROM    departments
          INNER JOIN
             students
          ON departments.department_id = Students.department_id
    WHERE student_id = student_id_val;

   RETURN departmnet_val;
END;

/* Formatted on 04/02/2024 5:09:19 PM (QP5 v5.139.911.3011) */
-- Calling Getting Student Department Function
set serveroutput on

DECLARE
   val   VARCHAR2 (40);
BEGIN
   val := getting_student_dep (3);
   DBMS_OUTPUT.put_line (val);
END;
        
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Formatted on 04/02/2024 5:08:53 PM (QP5 v5.139.911.3011) */
-- This function creates email for any one which is eathier instructor or student (Takes Id and Type as its student or instructor)

CREATE OR REPLACE FUNCTION email_val (id_val NUMBER, type_val VARCHAR2)
   RETURN VARCHAR2
IS
   first_na      VARCHAR2 (40);
   last_na       VARCHAR2 (40);
   email_value   VARCHAR2 (100);                  -- Increased size for safety
BEGIN
   IF type_val = 'student'
   THEN
      BEGIN
         SELECT firs_name, last_name
           INTO first_na, last_na
           FROM students
          WHERE student_id = id_val;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            first_na := 'No data';
            last_na := 'No data';
      END;
   ELSIF type_val = 'instructor'
   THEN
      BEGIN
         SELECT firs_name, last_name
           INTO first_na, last_na
           FROM instructors
          WHERE instructor_id = id_val;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            first_na := 'No data';
            last_na := 'No data';
      END;
   ELSE
      RETURN 'Invalid type provided';
   END IF;

   IF first_na IN ('No data') OR last_na IN ('No data')
   THEN
      RETURN 'Error: ' || first_na || ' ' || last_na;
   ELSE
      IF type_val = 'student'
      THEN
         email_value :=
            first_na || '-' || last_na || id_val || '@stud-modern.com';
      ELSIF type_val = 'instructor'
      THEN
         email_value :=
            first_na || '-' || last_na || id_val || '@instr-modern.com';
      END IF;
   END IF;

   RETURN email_value;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN 'Unexpected error occurred';
END;


/* Formatted on 04/02/2024 5:08:45 PM (QP5 v5.139.911.3011) */
-- Calling email value function
set serveroutput on

DECLARE
   x   VARCHAR2 (60);
BEGIN
   x := email_val (8, 'student');

   DBMS_OUTPUT.put_line (x);
END;


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/* Formatted on 04/02/2024 9:50:44 PM (QP5 v5.139.911.3011) */
-- This Function Calculate Age for both instructor or student

CREATE OR REPLACE FUNCTION age_calc (id_val NUMBER, type_val VARCHAR2)
   RETURN NUMBER
IS
   months_val   NUMBER (8, 2);
   years        NUMBER (6);
BEGIN
   IF type_val = 'student'
   THEN
      BEGIN
         SELECT MONTHS_BETWEEN (SYSDATE, DOB)
           INTO months_val
           FROM students
          WHERE student_id = id_val;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RAISE_APPLICATION_ERROR (-20004, 'There is No Data Found !!');
      END;
   ELSIF type_val = 'instructor'
   THEN
      BEGIN
         SELECT MONTHS_BETWEEN (SYSDATE, DOB)
           INTO months_val
           FROM instructors
          WHERE instructor_id = id_val;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RAISE_APPLICATION_ERROR (-20004, 'There is No Data Found !!');
      END;
   ELSE
      RAISE_APPLICATION_ERROR (
         -20005,
         'Error, The entered id or entered type are unknown !');
   END IF;

   years := TRUNC (months_val / 12);
   RETURN years;
END;

/* Formatted on 04/02/2024 9:50:52 PM (QP5 v5.139.911.3011) */
-- calling age_calc function

set serveroutput on

DECLARE
   val   NUMBER (6);
BEGIN
   val := age_calc (458, 'student');
   DBMS_OUTPUT.put_line (val);
END;


