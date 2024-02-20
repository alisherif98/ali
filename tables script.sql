/* Formatted on 30/01/2024 7:17:24 PM (QP5 v5.139.911.3011) */
--Students Table Creation

CREATE TABLE students
(
   student_id    NUMBER (10) NOT NULL,
   ssn           NUMBER (10) NOT NULL,
   firs_Name     VARCHAR2 (40),
   middle_Name   VARCHAR2 (40),
   last_Name     VARCHAR2 (40),
   sex           CHAR (4),
   DOB           DATE,
   city          VARCHAR2 (40),
   region        VARCHAR2 (40),
   street        VARCHAR2 (60),
   email         VARCHAR2 (40),
   age           NUMBER (4),
   Total_GPA     NUMBER (4, 2),
   CONSTRAINT PK_ID PRIMARY KEY (student_id),
   CONSTRAINT unique_SSN UNIQUE (ssn)
);


/* Formatted on 30/01/2024 7:29:28 PM (QP5 v5.139.911.3011) */
--Students Phones Table Creation

CREATE TABLE students_Phones
(
   student_Phone   NUMBER (20) NOT NULL,
   student_id      NUMBER (10),
   CONSTRAINT FK_student_id FOREIGN KEY
      (student_id)
       REFERENCES students (student_id),
   CONSTRAINT PK_composite PRIMARY KEY (student_Phone, student_id)
);


/* Formatted on 30/01/2024 7:29:16 PM (QP5 v5.139.911.3011) */
-- Academic_Year_Info Table Creation

CREATE TABLE Academic_Year_Info
(
   year              NUMBER (4) NOT NULL,
   student_id        NUMBER (10) NOT NULL,
   accumlative_GPA   NUMBER (4, 2),
   CONSTRAINT FK_student_id_academic FOREIGN KEY
      (student_id)
       REFERENCES students (student_id),
   CONSTRAINT PK_Academic_Year_Info PRIMARY KEY (year, student_id)
);


/* Formatted on 30/01/2024 7:42:45 PM (QP5 v5.139.911.3011) */
-- Courses Info Table Creation

CREATE TABLE courses_info
(
   course_id      NUMBER (10) NOT NULL,
   year           NUMBER (4),
   student_id     NUMBER (10),
   course_name    VARCHAR2 (40),
   course_grade   NUMBER (4),
   CONSTRAINT PK_courses_info PRIMARY KEY (course_id, year,student_id),
   CONSTRAINT FK_courses_info FOREIGN KEY
      (year, student_id)
       REFERENCES Academic_Year_Info (year, student_id)
);




  
/* Formatted on 30/01/2024 8:41:26 PM (QP5 v5.139.911.3011) */
-- Instructors Table Creation

CREATE TABLE Instructors
(
   instructor_id   NUMBER (10) NOT NULL,
   ssn             NUMBER (10) NOT NULL,
   firs_Name       VARCHAR2 (40),
   middle_Name     VARCHAR2 (40),
   last_Name       VARCHAR2 (40),
   sex             CHAR (4),
   DOB             DATE,
   city            VARCHAR2 (40),
   region          VARCHAR2 (40),
   street          VARCHAR2 (60),
   email           VARCHAR2 (40),
   age             NUMBER (4),
   CONSTRAINT PK_ID_instructors PRIMARY KEY (instructor_id),
   CONSTRAINT unique_SSN_instructors UNIQUE (ssn)
);

/* Formatted on 30/01/2024 8:43:30 PM (QP5 v5.139.911.3011) */
-- Departments Table Creation

CREATE TABLE departments
(
   department_id     NUMBER (10) NOT NULL,
   department_name   VARCHAR2 (40),
   CONSTRAINT PK_ID_Departments PRIMARY KEY (department_id)
);



/* Formatted on 30/01/2024 8:45:48 PM (QP5 v5.139.911.3011) */
-- Courses Table Creation

CREATE TABLE courses
(
   course_id        NUMBER (10) NOT NULL,
   course_name      VARCHAR2 (40),
   course_credits   NUMBER (4),
   CONSTRAINT PK_courses PRIMARY KEY (course_id)
);


/* Formatted on 30/01/2024 8:49:22 PM (QP5 v5.139.911.3011) */
-- Students have Courses Table Creation (M:N Relationship)

CREATE TABLE students_courses
(
   student_id   NUMBER (10),
   course_id    NUMBER (10),
   CONSTRAINT FK_students_courses FOREIGN KEY
      (student_id)
       REFERENCES students (student_id),
   CONSTRAINT FK_courses_students FOREIGN KEY
      (course_id)
       REFERENCES courses (course_id)
);

/* Formatted on 30/01/2024 8:53:22 PM (QP5 v5.139.911.3011) */
-- Alter Courses Table to add constraint of Instructors FK(instructor_id)(1 instructor teaches many courses)
ALTER TABLE courses ADD instructor_id NUMBER(10);
ALTER TABLE courses ADD CONSTRAINT FK_instructors_id FOREIGN KEY (instructor_id) REFERENCES instructors (instructor_id);

/* Formatted on 30/01/2024 8:58:14 PM (QP5 v5.139.911.3011) */
-- Alter Departments Table add constraint FK (1 department managed by 1 instructor)
ALTER TABLE departments ADD instructor_id_manage NUMBER(10);
ALTER TABLE departments ADD CONSTRAINT FK_instructor_id_dep FOREIGN KEY (instructor_id_manage) REFERENCES instructors (instructor_id);


/* Formatted on 30/01/2024 9:02:07 PM (QP5 v5.139.911.3011) */
-- Alter Instructors Table add constraint FK(1 deparment contains many instructors)
ALTER TABLE instructors ADD department_id NUMBER(10);
ALTER TABLE instructors ADD CONSTRAINT FK_dep_id_instructors FOREIGN KEY (department_id) REFERENCES departments (department_id);


/* Formatted on 31/01/2024 9:59:14 AM (QP5 v5.139.911.3011) */
-- Alter table students add department_ID (1 to M Relationship) (Many Students Assigned in 1 department )
ALTER TABLE students ADD department_id NUMBER(10);
ALTER TABLE students ADD CONSTRAINT FK_department_id_students FOREIGN KEY (department_id) REFERENCES departments (department_id);

/* Formatted on 31/01/2024 5:57:23 PM (QP5 v5.139.911.3011) */
--Alter Table Courses add Department_id (1 to M Relationship)
ALTER TABLE courses ADD department_id NUMBER(10);
ALTER TABLE courses ADD CONSTRAINT FK_department_id_courses FOREIGN KEY (department_id) REFERENCES departments (department_id);


