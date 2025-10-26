create table books(
	book_id int,
	book_name varchar(250),
	author varchar(150),
	publisher varchar(200),
	publishing_year date,
	language_code varchar(20),
	genre varchar(50)
);

alter table books alter column publishing_year type varchar(20);


create table book_ratings(
	book_id	int primary key,
	author_rating numeric(5,2),
	book_average_rating numeric(5,2),
	book_ratings_count numeric,
	gross_sales numeric,
	publisher_revenue numeric,
	sale_price numeric(5,2),
	units_sold int
);

select * from book_ratings;
select * from books;

-- 1. Top-Selling Books by Gross Sales

select
	b.book_name,
	sum(r.gross_sales) tota_gross_sale
from books b
join book_ratings r
on b.book_id = r.book_id
group by b.book_name
order by tota_gross_sale desc limit 5;

-- 2. Average Rating by Genre

select 
	b.genre,
	round(avg(r.book_average_rating),2) avg_rating
from books b
join book_ratings r
on b.book_id = r.book_id
group by b.genre
order by avg_rating desc limit 5;

-- 3. Publishers with Highest Revenue

select
	b.publisher,
	sum(r.publisher_revenue) total_revenue,
	rank() over(order by sum(r.publisher_revenue) desc) publisher_ranking
from books b
join book_ratings r
on b.book_id = r.book_id
group by b.publisher

-- 4. High-Rated Books Published in 2012.

select 
	b.book_name,
	b.publishing_year,
	r.book_average_rating
from books b 
join book_ratings r
on b.book_id = r.book_id
where b.publishing_year = '2012' and r.book_average_rating > 4.0
order by r.book_average_rating desc;

-- 5. Prolific Authors and Their Ratings

select 
	distinct b.author,
	count(b.book_id) total_books,
	round(avg(r.book_average_rating),2) avg_rating
from books b
join book_ratings r
on b.book_id = r.book_id
group by b.author
order by total_books desc;

-- 6. Hidden Gems: High Rating, Low Sales

with gem as (
select
	b.book_name,
	sum(r.units_sold) total_sold,
	round(avg(r.book_average_rating),2) avg_rating
from books b
join book_ratings r
on b.book_id = r.book_id
group by b.book_name
)
select * from gem
where total_sold < 1000 and avg_rating > 4.0;

-- 7. Profit Margin per Book

select 
	b.book_name,
	sum(r.gross_sales) total_sales,
	sum(r.publisher_revenue) revenue,
	round((sum(r.publisher_revenue) / sum(r.gross_sales)*100),2) profit_margin_pct
from books b
join book_ratings r
on b.book_id = r.book_id
group by b.book_name;

-- 8. Most Rated English Books

select * from book_ratings;

select 
	b.book_name,
	b.language_code,
	r.book_average_rating
from books b
join book_ratings r
on b.book_id = r.book_id 
where b.language_code = 'en'
order by r.book_average_rating desc limit 5 ;

-- 9. Sales by Publishing Year

select 
	b.publishing_year,
	sum(r.units_sold) total_sold,
	sum(r.gross_sales) total_revenue
from books b
join book_ratings r
on b.book_id = r.book_id
group by b.publishing_year
order by b.publishing_year;

-- 10. Author Rating > Book Rating

select * from book_ratings;

select
	b.book_name,
	r.author_rating,
	r.book_average_rating
from books b
join book_ratings r
on b.book_id = r.book_id
where r.author_rating > r.book_average_rating;