CREATE database case7db;

/*Q1*/
select ta.teacher_id, teacher_name, count(*) as numberofclasses
from teacher as t inner join teacher_allocation as ta on t.teacher_id = ta.teacher_id
group by ta.teacher_id;

/*Q2*/
select count(*) as numberofstudents, student_name, teacher_name
from teacher_allocation as ta
inner join teacher as t on ta.teacher_id = t.teacher_id
inner join student as s on ta.class_id = s.class_id
where t.teacher_name = s.student_name
group by ta.class_id;

/*Q3*/
select row_number() over (partition by class_id order by student_name asc) as uniquerollnumber, student_name, class_id
from student;

/*Q4*/
select boys.class_id, numberofboys, numberofgirls, numberofboys/numberofgirls as ratio
from (select count(*) as numberofboys, class_id
from student
where gender = "M"
group by class_id
order by class_id) as boys inner join (select count(*) as numberofgirls, class_id
from student
where gender = "F"
group by class_id
order by class_id) as girls on boys.class_id=girls.class_id; 

select count(*) as numberofgirls, class_id
from student
where gender = "F"
group by class_id
order by class_id;

/*Q5*/
select round(avg(yearsofexperience), 2) as avgexperienceinyears
from (select teacher_id, teacher_name, round(datediff(curdate(), newdoj)/365.25, 2) as yearsofexperience
from teacher) as temp;

/*Q6*/
select ep.student_id, student_name, exam_name, exam_subject, class_standard, marks, total_marks
from exam_paper as ep
inner join exam as e on ep.exam_id=e.exam_id 
inner join student as s on ep.student_id = s.student_id;

/*Q7*/
select ep.student_id, student_name, exam_name, exam_subject, class_standard, marks, total_marks, (marks/total_marks) * 100 as percentageofmarks
from exam_paper as ep
inner join exam as e on ep.exam_id=e.exam_id 
inner join student as s on ep.student_id = s.student_id
where exam_name = "Quarterly" and ep.student_id in (1,4,9,16,25);

/*Q8*/
select class_id, ep.student_id, student_name, exam_name, class_standard, sum(marks) as totalmarks, rank() over (partition by class_id order by sum(marks) desc) as rankofstudent
from exam_paper as ep
inner join exam as e on ep.exam_id=e.exam_id 
inner join student as s on ep.student_id = s.student_id
where exam_name = "Half yearly"
group by student_name;