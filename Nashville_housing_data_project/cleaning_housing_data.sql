/*

Cleaning the data Using SQL queries

*/

SELECT *
FROM Housing_Data_project.dbo.housing_data


-------------------------------------------------------------------------------------------------------------------

-- Standardize Data format

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM Housing_Data_project.dbo.housing_data

UPDATE housing_data
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE housing_data
ADD SaleDateConverted Date;

UPDATE housing_data
SET SaleDateConverted = CONVERT(Date, SaleDate)







------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

SELECT *
FROM Housing_Data_project.dbo.housing_data
-- WHERE PropertyAddress IS NULL
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Housing_Data_project.dbo.housing_data a
JOIN Housing_Data_project.dbo.housing_data b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Housing_Data_project.dbo.housing_data a
JOIN Housing_Data_project.dbo.housing_data b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


------------------------------------------------------------------------------------------------------------------------

-- Breaking Address into Individual Columns (Address, City, State)


SELECT PropertyAddress
FROM Housing_Data_project.dbo.housing_data

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS City
FROM Housing_Data_project.dbo.housing_data

ALTER TABLE housing_data
ADD PropertySplitAddress nvarchar(255);

UPDATE housing_data
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE housing_data
ADD PropertySplitCity nvarchar(255);

UPDATE housing_data
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

SELECT *
FROM Housing_Data_project.dbo.housing_data




SELECT OwnerAddress
FROM Housing_Data_project.dbo.housing_data


SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM Housing_Data_project.dbo.housing_data




ALTER TABLE housing_data
ADD OwnerSplitAddress nvarchar(255);

UPDATE housing_data
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

ALTER TABLE housing_data
ADD OwnerSplitCity nvarchar(255);

UPDATE housing_data
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE housing_data
ADD OwnerSplitState nvarchar(255);

UPDATE housing_data
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)





SELECT *
FROM Housing_Data_project.dbo.housing_data





---------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" Field


SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM Housing_Data_project.dbo.housing_data
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM Housing_Data_project.dbo.housing_data
WHERE SoldAsVacant = 'Y'
OR SoldAsVacant = 'N'


UPDATE housing_data
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END



---------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH Row_Num_CTE AS
(
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


FROM Housing_Data_project.dbo.housing_data
-- ORDER BY ParcelID
)
SELECT *
FROM Row_Num_CTE
WHERE row_num > 1






------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



SELECT *
FROM Housing_Data_project.dbo.housing_data


ALTER TABLE Housing_Data_project.dbo.housing_data
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate





