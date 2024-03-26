SELECT *
FROM Portfolio.dbo.NashvilleHousing_Analysis

SELECT YEAR(SaleDate) AS SaleYear,
       SUM(SalePrice) AS TotalSales
FROM Portfolio.dbo.NashvilleHousing_Analysis
GROUP BY YEAR(SaleDate)
ORDER BY SaleYear DESC;


SELECT PropertyCity,
       AVG(SalePrice) AS AvgSalePrice
FROM Portfolio.dbo.NashvilleHousing_Analysis
GROUP BY PropertyCity
ORDER BY AvgSalePrice;



SELECT LandUse,
       COUNT(SalePrice) AS SalesCount
FROM Portfolio.dbo.NashvilleHousing_Analysis
GROUP BY LandUse
ORDER BY SalesCount



SELECT PropertyCity,
       MAX(SalePrice) AS MaxSalePrice
FROM Portfolio.dbo.NashvilleHousing_Analysis
GROUP BY PropertyCity
ORDER BY MaxSalePrice;




SELECT YEAR(SaleDate) AS SaleYear,
       MIN(SalePrice) AS MinSalePrice,
       MAX(SalePrice) AS MaxSalePrice
FROM Portfolio.dbo.NashvilleHousing_Analysis
GROUP BY YEAR(SaleDate)
ORDER BY SaleYear;




SELECT *
FROM Portfolio.dbo.NashvilleHousing_Analysis

SELECT PropertyCity, 
		COUNT(Bedrooms) AS "Total Number Of Bedroom",
		COUNT(FullBath) AS "Total Number Of FullBath",
		COUNT(HalfBath) AS "Total Number Of HalfBath"
FROM Portfolio.dbo.NashvilleHousing_Analysis
GROUP BY PropertyCity
