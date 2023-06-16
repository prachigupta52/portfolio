Select * from moviesdb.movies
Join movie_actor
on movies.movie_id = moviesdb.movie_actor.movie_id
where release_year > 2013 
and (studio like "Warner Bros. %" or studio = "Marvel Studios" or studio = "Dharma Productions")
order by release_year desc, studio;

/*Temp table*/

Drop table if exists boxoffice;
Create temporary table boxoffice 
(language_id int, movie_id int, title text, release_year int, actor_id int, studio text);
insert into boxoffice
Select movies.language_id, movies.movie_id, movies.title, movies.release_year, movie_actor.actor_id, movies.studio
from moviesdb.movies
Join movie_actor
on movies.movie_id = moviesdb.movie_actor.movie_id
where release_year > 2013 
and (studio like "Warner Bros. %" or studio = "Marvel Studios" or studio = "Dharma Productions")
order by release_year desc;

/*Multi Joins*/

select boxoffice.studio, boxoffice.title as movie_name, 
actors.name as actor, boxoffice.release_year, languages.name as lang,
concat(financials.revenue," ",left(financials.unit, 4)," ",financials.currency) as returns
from boxoffice
Join actors
On boxoffice.actor_id = actors.actor_id
Join financials
on boxoffice.movie_id = financials.movie_id
Join languages
on boxoffice.language_id = languages.language_id;

/*Conversion*/

CREATE TABLE permanent LIKE boxoffice; 
INSERT INTO permanent SELECT * FROM boxoffice;


select boxoffice.studio, boxoffice.title, boxoffice.release_year,  
financials.revenue as returns, concat(left(financials.unit, 4)," ",financials.currency) as unit
from boxoffice
Join financials
on boxoffice.movie_id = financials.movie_id
group by boxoffice.title, boxoffice.release_year, boxoffice.studio, financials.revenue,
concat(left(financials.unit, 4)," ",financials.currency)
order by release_year desc ;


/*rolling returns - Window Function Aggregation*/

select studio, release_year, returns, 
concat(sum(returns) over (partition by studio order by release_year, studio)," ",unit ) as annual_returns
from studio_annual_revenue
order by studio
;

