 use  portfolio;

select * from housingData;

/* date format i.e time not needed*/

select SaleDate from housingData;

select SaleDate, convert(Date,SaleDate) as Date_new from housingData;

update housingData set SaleDate_new= convert(Date,SaleDate);

alter table housingData add SaleDate_new date;

select SaleDate_new from housingData;


/* property address*/

select * from housingData 
where PropertyAddress is null;


select * from housingData order by ParcelID;

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress) as new_a_Address
from housingData a join housingData b
on a.ParcelID=b.ParcelID
 and a.[UniqueID ]<>b.[UniqueID ]
 where a.PropertyAddress is null;


 update a
 set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
 from housingData a join housingData b
on a.ParcelID=b.ParcelID
 and a.[UniqueID ]<>b.[UniqueID ]
 where a.PropertyAddress is null;

/*devide property address into city, state*/
 
  select   top 3 PropertyAddress
 from housingData;

 select SUBSTRING( PropertyAddress,1,charindex(', ',PropertyAddress) -1) as Address from housingData;

  select SUBSTRING( PropertyAddress,charindex(', ',PropertyAddress) +1, len(PropertyAddress)) as Address from housingData;


  
 select SUBSTRING( PropertyAddress,1,charindex(',',PropertyAddress) -1) as addresscode,
 SUBSTRING( PropertyAddress,charindex(',',PropertyAddress) +1, len(PropertyAddress)) as Addresscity from housingData;


 alter table housingData
 add PropertysplitAddress varchar(500); -- address with code
 alter table housingData
 add PropertysplitCity varchar(500);-- address city

 update housingData
 set PropertysplitAddress=SUBSTRING( PropertyAddress,1,charindex(',',PropertyAddress) -1);

 
 update housingData
 set PropertysplitCity=SUBSTRING( PropertyAddress,charindex(',',PropertyAddress) +1, len(PropertyAddress));
 /*owner address*/

 select OwnerAddress from housingData;
  select * from housingData;
 select 
 PARSENAME(replace(OwnerAddress,',','.'),3),
  PARSENAME(replace(OwnerAddress,',','.'),2),
  PARSENAME(replace(OwnerAddress,',','.'),1)  from housingData;

  alter table housingData
 add ownersplitAddress varchar(500); -- owner with code
 alter table housingData
 add ownersplitCity varchar(500);-- owner city
  alter table housingData
 add ownersplitState varchar(500);-- owner city

 update housingData
 set ownersplitAddress= PARSENAME(replace(OwnerAddress,',','.'),3);

  update housingData
 set ownersplitCity= PARSENAME(replace(OwnerAddress,',','.'),2);

 update housingData
 set ownersplitState=PARSENAME(replace(OwnerAddress,',','.'),1);


 select *from housingData where SalePrice is null;
  select *from housingData where LegalReference is null;

    select distinct  SoldAsVacant,count(SoldAsVacant) from housingData
	group by SoldAsVacant;


select SoldAsVacant ,
case when SoldAsVacant ='Y' then 'Yes'
when SoldAsVacant ='N' then 'No'
else SoldAsVacant
end
from housingData;

update housingData
set SoldAsVacant=case when SoldAsVacant ='Y' then 'Yes'
when SoldAsVacant ='N' then 'No'
else SoldAsVacant
end
from housingData;


/* remove duplicates*/

with RowNumCTE as(
select *, ROW_NUMBER() over (
partition by ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			order by UniqueID) row_num
from housingData)
delete from RowNumCTE
where row_num>1
;

with RowNumCTE as(
select *, ROW_NUMBER() over (
partition by ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			order by UniqueID) row_num
from housingData)
select * from RowNumCTE
where row_num>1;


/* removing unnecessary columns*/

select * from housingData;

alter table housingData
drop column PropertyAddress,OwnerAddress;


alter table housingData
drop column SaleDate,TaxDistrict;