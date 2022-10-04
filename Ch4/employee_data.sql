drop table project_team_members;
drop table employees;
drop table departments;
drop table projects;


create table departments(
 id int primary key,
 department_name varchar(100)
);

create table employees (
 id int primary key,
 first_name varchar(50), 
 last_name varchar(50),
 department_id int,
 CONSTRAINT fk_department FOREIGN KEY (department_id)
 REFERENCES departments(id)
);

create table projects (
 id int primary key,
 project_name varchar(100)
);

create table project_team_members(
 employee_id int,
 project_id int,
 CONSTRAINT fk_employee FOREIGN KEY (employee_id)
  REFERENCES employees(id),
 CONSTRAINT fk_project FOREIGN KEY (project_id)
  REFERENCES projects(id)
);



insert into departments values (1, 'Sales');
insert into departments values (2, 'Marketing');
insert into departments values (3, 'Engineering');
insert into departments values (4, 'Product Support');
commit;

-- sales
insert into employees values (1, 'Jim', 'Dunn', 1 );
insert into employees values (2, 'Susan', 'Smith', 1 );
insert into employees values (3, 'Don', 'Draper', 1 );


-- marketing
insert into employees values (4, 'Bobby', 'Briggs', 2 );
insert into employees values (5, 'Laura', 'Palmer', 2 );
insert into employees values (6, 'Dale', 'Cooper', 2 );

-- engineering
insert into employees values (7, 'Geordi', 'La Forge', 3 );
insert into employees values (8, 'Zack', 'Morris', 3 );
insert into employees values (9, 'Daveed', 'Diggs', 3 );

-- product support
insert into employees values (10, 'Hasan', 'Minaj', 4 );
insert into employees values (11, 'Nikki', 'Minaj', 4 );
insert into employees values (12, 'Lin', 'Miranda', 4 );

insert into projects values (1, 'CRM Implementation' );
insert into project_team_members values (7, 1 );
insert into project_team_members values (12, 1 );
insert into project_team_members values (5, 1 );
insert into project_team_members values (1, 1 );

insert into projects values (2, 'Security Assessment' );
insert into project_team_members values (7, 2 );
insert into project_team_members values (8, 2 );
insert into project_team_members values (9, 2 );
insert into project_team_members values (10, 2 );

commit;


select e.first_name, e.last_name, d.department_name
from employees e 
inner join departments d 
on ( d.id = e.department_id )
and d.department_name = 'Sales';


-- get everyone on project 2 (Security Assessment)
select e.first_name, e.last_name, d.department_name
from employees e 
inner join departments d 
on ( d.id = e.department_id )
inner join project_team_members m
on ( m.employee_id = e.id )
inner join projects p
on ( p.id = m.project_id )
where p.id = 2;

