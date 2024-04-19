SELECT *
FROM Portfolio.dbo.Nashville_Housing

-----Standadize Format
SELECT Sale_Date, SaleDate
FROM Portfolio.dbo.Nashville_Housing


ALTER TABLE Nashville_Housing
ADD Sale_Date Date

UPDATE Nashville_Housing
SET Sale_Date = CAST(SaleDate AS DATE)


--------Populate Property Address
SELECT *
FROM Portfolio.dbo.Nashville_Housing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Portfolio.dbo.Nashville_Housing a
JOIN Portfolio.dbo.Nashville_Housing b
ON	a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
--WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Portfolio.dbo.Nashville_Housing a
JOIN Portfolio.dbo.Nashville_Housing b
ON	a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL 



-----Break-Out The Address
SELECT *
FROM Portfolio.dbo.Nashville_Housing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS City
FROM Portfolio.dbo.Nashville_Housing

ALTER TABLE Nashville_Housing
ADD Address Nvarchar(255)

UPDATE Nashville_Housing
SET Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 


ALTER TABLE Nashville_Housing
ADD City Nvarchar(255)

UPDATE Nashville_Housing
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


SELECT OwnerAddress
FROM Portfolio.dbo.Nashville_Housing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3), 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM Portfolio.dbo.Nashville_Housing

ALTER TABLE Nashville_Housing
ADD Owner_Address Nvarchar(255)

UPDATE Nashville_Housing
SET Owner_Address = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) 


ALTER TABLE Nashville_Housing
ADD Owner_City Nvarchar(255)

UPDATE Nashville_Housing
SET Owner_City = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


ALTER TABLE Nashville_Housing
ADD Owner_State Nvarchar(255)

UPDATE Nashville_Housing
SET Owner_State = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


SELECT OwnerAddress, Owner_Address, Owner_City, Owner_State
FROM Portfolio.dbo.Nashville_Housing



-----Fix SoldAsVacant
--SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
--FROM Portfolio.dbo.Nashville_Housing
--GROUP BY SoldAsVacant
--ORDER BY 2

SELECT *,
       CASE SoldAsVacant
           WHEN 'Y' THEN 'Yes'
           WHEN 'N' THEN 'No'
           ELSE SoldAsVacant
       END AS SoldAsVacant_Replaced
FROM Portfolio.dbo.Nashville_Housing


ALTER TABLE Nashville_Housing
ADD SoldAsVacant_Replaced Nvarchar(255)

UPDATE Nashville_Housing
SET SoldAsVacant_Replaced = CASE SoldAsVacant
           WHEN 'Y' THEN 'Yes'
           WHEN 'N' THEN 'No'
           ELSE SoldAsVacant
       END 

SELECT SoldAsVacant_Replaced, SoldAsVacant
FROM Portfolio.dbo.Nashville_Housing

--SELECT DISTINCT(SoldAsVacant_Replaced), COUNT(SoldAsVacant_Replaced)
--FROM Portfolio.dbo.Nashville_Housing
--GROUP BY SoldAsVacant_Replaced
--ORDER BY 2



----Delete Columns Copies

ALTER TABLE Portfolio.dbo.Nashville_Housing
DROP COLUMN PropertyAddress, OwnerAddress, SaleDate, SoldAsVacant

SELECT *
FROM Portfolio.dbo.Nashville_Housing

--------Remove Duplicated
WITH RowNumCTE AS (
SELECT *, 
		ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					ORDER BY 
						UniqueID
						) row_num
FROM Portfolio.dbo.Nashville_Housing
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

----SELECT (DELETE)

------------------------------------------------------------------------------------------------------------------------------------

/*
General queries
*/

SELECT *
FROM Portfolio.dbo.Nashville_Housing

SELECT YEAR(Sale_Date) AS "Sale Year",
       SUM(SalePrice) AS "Total Sales"
FROM Portfolio.dbo.Nashville_Housing
GROUP BY YEAR(Sale_Date)
ORDER BY "Sale Year";



SELECT City, ROUND(AVG(SalePrice),2) AS "Average Sale Price"
FROM Portfolio.dbo.Nashville_Housing
WHERE City <> 'UNKNOWN'
GROUP BY City
ORDER BY "Average Sale Price"



SELECT LandUse, COUNT(SalePrice) AS "Count Of Different LandUse"
FROM Portfolio.dbo.Nashville_Housing
GROUP BY LandUse
ORDER BY "Count Of Different LandUse"



SELECT YEAR(Sale_Date) AS "Sale Year",
		MAX(SalePrice) AS "Maximum Sale",
		MIN(SalePrice) AS "Minimum Sale"
FROM Portfolio.dbo.Nashville_Housing
GROUP BY YEAR(Sale_Date)
ORDER BY "Sale Year"



SELECT City, 
		COUNT(Bedrooms) AS "Total Number Of Bedroom",
		COUNT(FullBath) AS "Total Number Of FullBath",
		COUNT(HalfBath) AS "Total Number Of HalfBath"
FROM Portfolio.dbo.Nashville_Housing
GROUP BY City
ORDER BY City





