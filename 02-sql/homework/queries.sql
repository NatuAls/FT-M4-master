-- 1) peliculas en el anio en el que naci
SELECT name, year FROM movies WHERE year=1998;

-- 2) hay 4597 peliculas del anio 1982
SELECT COUNT(*) FROM movies WHERE year=1982;

-- 3) Buscá actores que tengan el substring stack en su apellido.
SELECT * FROM actors WHERE last_name LIKE '%stack%';

-- 4) Buscá los 10 nombres y apellidos más populares entre los actores. Cuantos actores tienen cada uno de esos nombres y apellidos?
SELECT fist_name, last_name, COUNT(*) AS Total 
FROM actors 
GROUP BY LOWER(first_name), LOWER(last_name)
ORDER BY Total DESC
LIMIT 10;

-- 5) Listá el top 100 de actores más activos junto con el número de roles que haya realizado.
SELECT actors.first_name, actors.last_name, COUNT(*) AS total
FROM actors JOIN roles ON actors.id = roles.actor_id
GROUP BY LOWER(first_name), LOWER(last_name)
ORDER BY total DESC
LIMIT 100;

-- 6) Cuantas películas tiene IMDB por género? Ordená la lista por el género menos popular.
SELECT genre, COUNT(*) AS total
FROM movies_genres
GROUP BY genre
ORDER BY total ASC;

-- 7) Listá el nombre y apellido de todos los actores que trabajaron en la película "Braveheart" de 1995, ordená la lista alfabéticamente por apellido.
SELECT actors.first_name, actors.last_name
FROM actors 
JOIN roles ON roles.actor_id = actors.id
JOIN movies ON roles.movie_id = movies.id 
WHERE movies.name='Braveheart' AND movies.year=1995
ORDER BY actors.last_name, actors.first_name;

-- 8) Leap Noir
SELECT directors.first_name, directors.last_name, movies.name, movies.year
FROM directors
JOIN movies_directors ON directors.id = movies_directors.director_id
JOIN movies ON movies_directors.movie_id = movies.id
JOIN movies_genres ON movies.id = movies_genres.movie_id
WHERE movies_genres.genre = 'Film-Noir' AND movies.year%4 = 0
ORDER BY movies.name;

-- 9) Listá todos los actores que hayan trabajado con Kevin Bacon en películas de Drama (incluí el título de la peli). Excluí al señor Bacon de los resultados.
SELECT actors.first_name, actors.last_name, movies.name
FROM actors
JOIN roles ON actors.id = roles.actor_id
JOIN movies ON roles.movie_id = movies.id
JOIN movies_genres ON movies.id = movies_genres.movie_id
WHERE movies_genres.genre = 'Drama' AND movies.id IN (
    SELECT roles.movie_id
    FROM roles
    JOIN actors ON actors.id = roles.actor_id
    WHERE actors.first_name = 'Kevin' AND actors.last_name = 'Bacon'
) AND (actors.first_name || ' ' || actors.last_name != 'Kevin Bacon');

-- 10) Qué actores actuaron en una película antes de 1900 y también en una película después del 2000?
SELECT *
FROM actors
WHERE id IN (
SELECT roles.actor_id
FROM roles
JOIN movies ON roles.movie_id = movies.id
WHERE movies.year < 1900
) AND id IN (
SELECT roles.actor_id
FROM roles
JOIN movies ON roles.movie_id = movies.id
WHERE movies.year > 2000
);

-- 11) Busy Filming
SELECT actors.first_name, actors.last_name, movies.name, COUNT(DISTINCT(role)) AS total
FROM actors
JOIN roles ON actors.id = roles.actor_id
JOIN movies ON roles.movie_id = movies.id
WHERE movies.year > 1990
GROUP BY actor_id, movie_id
HAVING total > 5;

-- 12) Para cada año, contá el número de películas en ese años que sólo tuvieron actrices femeninas.
SELECT year, COUNT(DISTINCT(id)) AS total
FROM movies
WHERE id NOT IN (
    SELECT roles.movie_id
    FROM roles
    JOIN actors ON roles.actor_id = actors.id
    WHERE actors.gender = 'M'
)
GROUP BY year;