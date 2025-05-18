create database project1;
use project1;

select * from scraped_books_data;


ALTER TABLE scraped_books_data
ADD COLUMN rating_category VARCHAR(20);


UPDATE scraped_books_data
SET rating_category = 
CASE
    WHEN rating >= 4 THEN 'Best Seller'
    WHEN rating = 3 THEN 'Moderate Seller'
    WHEN rating IN (1, 2) THEN 'Low Seller'
    WHEN rating IS NULL OR rating = 0 THEN 'Unrated'
    ELSE 'Other'
END;

/*QUERIES*/

-- 1. Find the number of books available in stock.
SELECT COUNT( * ) AS books_in_stock
FROM scraped_books_data;
-- Insight- Shows the number of books in stock.


-- 2. List the top 5 most expensive books.
SELECT title, price
FROM scraped_books_data
ORDER BY price DESC
LIMIT 5;
-- Insight-Highlights the 5 highest-priced books.

-- 3. Find the average rating of books.
SELECT round(AVG(rating),2) AS average_rating
FROM scraped_books_data;
-- Insight-The average rating reflects general customer satisfaction with the books.


-- 4. Retrieve the total number of books for each rating (e.g., 1-star, 2-star, etc.).
SELECT rating, COUNT(*) AS total_books
FROM scraped_books_data
GROUP BY rating
ORDER BY rating;
-- Insight-The count of books per rating reveals how ratings are distributed.

-- 5. Find the cheapest book in each rating category.
SELECT title, price, rating_category
FROM scraped_books_data AS s1
WHERE price = (
  SELECT MIN(price)
  FROM scraped_books_data AS s2
  WHERE s1.rating_category = s2.rating_category
);
-- Insight-The cheapest book in each category identifies budget options within each rating tier.

-- 6. Count how many books fall into each rating_category.
SELECT rating_category, COUNT(*) AS total_books
FROM scraped_books_data
GROUP BY rating_category
ORDER BY total_books DESC;
-- Insight-The number of books in each rating category shows which seller type is most common.

-- 7. Find the maximum and minimum prices for each rating (1–5).
SELECT rating, MAX(price) AS max_price, MIN(price) AS min_price
FROM scraped_books_data
GROUP BY rating
ORDER BY rating;
-- Insight-The price range for each rating shows how pricing varies with book quality.

-- 8. Find the top 3 most expensive books in the 'Low Seller' category.
SELECT title, price
FROM scraped_books_data
WHERE rating_category = 'Low Seller'
ORDER BY price DESC
LIMIT 3;
-- Insight-The most expensive 'Low Seller' books may be overpriced and underperforming.

-- 9. Find the Top Selling Books (Highest Ratings — 4 or 5)
SELECT title, rating, price, rating_category
FROM scraped_books_data
WHERE rating >= 4
ORDER BY rating DESC, price DESC;
-- Insight-Highly rated books (4–5 stars) are top sellers worth promoting.

-- 10. Find the Low Selling Books (Lowest Ratings — 1 or 2)
SELECT title, rating, price, rating_category
FROM scraped_books_data
WHERE rating IN (1, 2)
ORDER BY rating ASC, price DESC;
-- Insight-Low_rated books (1–2 stars) are underperformers that may need attention or discounts.
