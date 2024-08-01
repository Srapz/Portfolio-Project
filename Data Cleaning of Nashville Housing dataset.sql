--Cleaning Data in SQL Queries

SELECT *
FROM dbo.NashvilleHousing

--Standardize Data Format
 
 Select SaleDate, Convert(date, Saledate) AS SaleDate2
 FROM NashvilleHousing

 Alter table NashvilleHousing
 Add SaleDate2 date

 Update NashvilleHousing
 Set SaleDate2 = Convert(date, saledate)

--Populate Address Property Data

SELECT * 
FROM [dbo].[NashvilleHousing]
ORDER BY ParcelID

SELECT a1.ParcelID, a1.PropertyAddress, a2.ParcelID, a2.PropertyAddress, ISNULL(a1.PropertyAddress, a2.PropertyAddress)
FROM NashvilleHousing a1
JOIN NashvilleHousing a2
ON a1.ParcelID = a2.ParcelID
AND a1.[UniqueID ] <> a2.[UniqueID ]
WHERE a1.PropertyAddress is null

Update a1
SET PropertyAddress = ISNULL(a1.propertyAddress, a2.PropertyAddress)
FROM NashvilleHousing a1
JOIN NashvilleHousing a2
ON a1.ParcelID = a2.ParcelID
AND a1.[UniqueID ] <> a2.[UniqueID ]
WHERE a1.PropertyAddress IS Null

--Breaking out Address into individual columns

SELECT PropertyAddress
FROM NashvilleHousing
--Order By ParcelID

Select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS PropertySplitAddress,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS PropertySplitcity
FROM NashvilleHousing

Alter table NashvilleHousing
 Add PropertySplitAddress nvarchar(255);


 Update NashvilleHousing
 Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

 Alter table NashvilleHousing
 Add PropertySplitcity nvarchar(255);

 Update NashvilleHousing
 Set PropertySplitcity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT PropertySplitAddress FROM NashvilleHousing
SELECT PropertySplitcity FROM NashvilleHousing

--Remove Duplicates

WITH RowNumCTE AS
(
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY ParcelID,
				  PropertyAddress, 
                  SalePrice, 
				  Saledate,
				  LegalReference
				  ORDER BY UniqueID
				  ) row_num
FROM [dbo].[NashvilleHousing]
)
SELECT * 
FROM RowNumCTE
WHERE row_num > 1

-- Delete Unused Rows

SELECT *
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN  OwnerAddress

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate
