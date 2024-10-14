use music_store;

/* easy 1*/

select * from employee;

select TOP 1  * from employee
order by levels desc;

/* EASY2*/

SELECT * FROM INVOICE;

SELECT TOP 1 BILLING_COUNTRY AS COUNTRY,
COUNT(*) AS NUMBEROFINVOICE FROM INVOICE
GROUP BY (billing_country)
ORDER BY COUNT(BILLING_COUNTRY) DESC;

/*EASY3*/

SELECT * FROM invoice;

SELECT TOP 3 TOTAL FROM INVOICE
ORDER BY TOTAL DESC;

/*easy4*/

select * from invoice;

select top 3 sum(total) as invoice_total, billing_city
from invoice
group by billing_city
order by invoice_total desc ;

/*easy5*/
select * from invoice;

select * from customer;

select top 3  customer.customer_id, customer.first_name, sum(invoice.total)  as total_amt_spent
from customer 
join  invoice on customer.customer_id= invoice.customer_id
group by customer.customer_id
order by total_amt_spent desc;

/*MMODERATE1*/

SELECT * FROM CUSTOMER;

SELECT * FROM invoice;
SELECT * FROM genre;

SELECT * FROM ALBUM;

SELECT DISTINCT EMAIL,FIRST_NAME, LAST_NAME FROM CUSTOMER
JOIN INVOICE ON customer.customer_id=invoice.customer_id
JOIN invoice_line ON   invoice.invoice_id=invoice_line.invoice_id
WHERE invoice_line.TRACK_ID IN(
SELECT TRACK_ID FROM TRACK
JOIN GENRE ON TRACK.genre_id = GENRE.genre_id
WHERE GENRE.name='ROCK'
 ) order by email ;


 /*moderate2*/

 select * from artist;
  select * from track;
   select * from genre;
      select * from album;


   select top 10 artist.artist_id , artist.artist_name ,count(artist.artist_id) as num_songs from track
   join  album on album.album_id=track.album_id
   join artist on artist.artist_id= album.artist_id
   JOIN genre ON TRACK.genre_id = GENRE.genre_id
WHERE GENRE.name='ROCK'
group by artist.artist_id, artist.artist_name
order by num_songs desc;

/*MODERATE3*/

SELECT* FROM TRACK;

SELECT AVG(MILLISECONDS)AS AVG_TIME FROM TRACK;

SELECT NAME, MILLISECONDS  FROM track
WHERE MILLISECONDS > (
SELECT AVG(MILLISECONDS) AS AVG_LENGTH FROM track)
ORDER BY milliseconds DESC;

/*HARD1*/

SELECT * FROM CUSTOMER;
SELECT * FROM invoice;
SELECT * FROM invoice_line;
SELECT * FROM TRACK;
SELECT * FROM ALBUM;
SELECT * FROM artist;

with  best_selling_artist as(
select top 1 artist.artist_id as  artist_id,artist.artist_name as artist_name,
sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
from invoice_line
join track on track.track_id=invoice_line.track_id
JOIN album ON TRACK.album_id=ALBUM.album_id
JOIN artist ON ARTIST.artist_id=ALBUM.artist_id
    GROUP BY artist.artist_id, artist.artist_name
    ORDER BY total_sales DESC
)
select customer.customer_id, customer.first_name,customer.last_name,best_selling_artist.artist_name, sum(invoice_line.unit_price*invoice_line.quantity) as amt_spent
from invoice
join customer on customer.customer_id=invoice.customer_id
join invoice_line on invoice_line.invoice_id=invoice.invoice_id
join track on track.track_id=invoice_line.track_id
join album on album.album_id=track.album_id
join best_selling_artist on best_selling_artist.artist_id=album.artist_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name, best_selling_artist.artist_name
ORDER BY amt_spent DESC;


