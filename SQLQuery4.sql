-- Data Exploration


Select * from
[Portfolio Project].dbo.NHousing;

Select *
from [Portfolio Project].dbo.NHousing
--where PropertyAddress is Null
order by ParcelID;

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Portfolio Project].dbo.NHousing a
join [Portfolio Project].dbo.NHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ] 
where a.PropertyAddress is Null;

update a 
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Portfolio Project].dbo.NHousing a
join [Portfolio Project].dbo.NHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ] 
where a.PropertyAddress is Null;

Select PropertyAddress from [Portfolio Project].dbo.NHousing
where PropertyAddress is Null;

---------------------------------------------------------------------------------------------

-- Breaking PropertyAddress into 2 columns

Select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as City 
from [Portfolio Project].dbo.NHousing;

Alter table [Portfolio Project].dbo.NHousing
ADD PAddress Nvarchar(255);

Update [Portfolio Project].dbo.NHousing
Set PAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1);

Alter table [Portfolio Project].dbo.NHousing
ADD PCity Nvarchar(255);

Update [Portfolio Project].dbo.NHousing
Set PCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

Select * from [Portfolio Project].dbo.NHousing

---------------------------------------------------------------------------------------------------

--Splitting OwnerAddress using Parsename function into 3 columns

select 
PARSENAME(replace(OwnerAddress,',','.'),1),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),3)
from [Portfolio Project].dbo.NHousing;



Alter table [Portfolio Project].dbo.NHousing
ADD OAddress Nvarchar(255);

Update [Portfolio Project].dbo.NHousing
Set OAddress = PARSENAME(replace(OwnerAddress,',','.'),3);



Alter table [Portfolio Project].dbo.NHousing
ADD OCity Nvarchar(255);

Update [Portfolio Project].dbo.NHousing
Set OCity = PARSENAME(replace(OwnerAddress,',','.'),2);



Alter table [Portfolio Project].dbo.NHousing
ADD OState Nvarchar(255);

Update [Portfolio Project].dbo.NHousing
Set OState = PARSENAME(replace(OwnerAddress,',','.'),1);

--------------------------------------------------------------------------

--Cleaning 'SoldAsVacant' column, changing Y and N to Yes and No

Select SoldAsVacant, Count(SoldAsVacant)
from [Portfolio Project].dbo.NHousing
group by SoldAsVacant;


Select SoldAsVacant,
Case When SoldAsVacant = 'Y' then 'Yes'
When SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
from [Portfolio Project].dbo.NHousing


Update [Portfolio Project].dbo.NHousing
set SoldAsVacant = Case When SoldAsVacant = 'Y' then 'Yes'
When SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end


-------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NNHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProject.dbo.NHousing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From PortfolioProject.dbo.NHousing


ALTER TABLE PortfolioProject.dbo.NHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


