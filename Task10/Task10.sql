create table if not exists students (
	id integer generated always as identity primary key,
	name text,
	total_score integer default 0,
    scholarship integer default 0
);


create table if not exists activity_scores (
	student_id integer references students,
	activity_types text,
	score integer
);

-- 1.
create or replace function calculate_scholarship() returns trigger
language plpgsql as $$
declare
	sum_score integer := 0;
	scholarship1 integer;
begin
	select sum(score) into sum_score
	from activity_scores
	where student_id = new.student_id;
	if sum_score < 80 then
		scholarship1 := 0;
	elsif sum_score >= 80 and sum_score < 90 then
		scholarship1 := 500;
	else
		scholarship1 := 1000;
	end if;

	update students
	set scholarship = scholarship1
	where id = new.student_id;

	return new;
end;
$$

create trigger update_scholarship_trigger
after insert on activity_scores
for each row execute function calculate_scholarship();


select * from students;
select * from activity_scores;

--2.
create or replace function update_total_score() returns trigger
language plpgsql as $$
declare
	sum_score integer := 0;
	score_ integer;
begin
	for score_ in
		select score
		from activity_scores
		where student_id = new.student_id
	loop
		sum_score := sum_score + score_;
	end loop;

	update students
	set total_score = sum_score
	where id = new.student_id;

	return new;
end;
$$

create trigger update_total_score_trigger
after insert on activity_scores
for each row execute function update_total_score();

insert into activity_scores
values (2, 'Exam', 53);

select * from students;

insert into activity_scores
values (2, 'Homework', 39),
(1, 'Exam', 90),
(4, 'Homework', 61),
(5, 'Exam', 79);

select * from students;