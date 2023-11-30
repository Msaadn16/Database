SET SQL_SAFE_UPDATES=0;
Use pet_assignment;

# 1. List the names of all pet owners along with the names of their pets.
Select concat(o.Name," ",o.Surname) as Owner_Name, p.name as Pet_Name
from petowners o
left Join pets p
on o.OwnerID=p.OwnerID;

# 2. List all pets and their owner names, including pets that don't have recorded owners.
Select p.name as Pet_Name,concat(o.Name," ",o.Surname) as Owner_Name
from pets p
left Join petowners o
on o.OwnerID=p.OwnerID;

# 3. Combine the information of pets and their owners, including those pets without owners and owners without
# pets. 
Select * from pets p
cross join petowners o
on o.OwnerID=p.OwnerID;

# 4. Find the names of pets along with their owners' names and the details of the procedures they have
# undergone. 
Select p.Name, concat(o.Name," ",o.Surname) as Owner_name, ph.procedureType as Procedure_Type, pd.Description as Procedure_Description,ph.date as Procedure_Date,Pd.Price
from pets p
left join petowners o
on o.ownerID=p.OwnerID
left join procedureshistory ph
on p.PetID=ph.PetID
left join proceduresdetails pd
on pd.procedureSubCode=ph.procedureSubCode
and pd.ProcedureType=ph.ProcedureType
where ph.procedureType is not null;

# 5. List all pet owners and the number of dogs they own. 
Select o.OwnerID,concat(o.Name," ",o.Surname) as Owner_Name, count(p.petID) as no_of_Dogs from petowners o
join pets p
on o.ownerID=p.ownerID
where p.Kind="Dog"
group by 1,2;

# 6. Identify pets that have not had any procedures. 
Select p.petid,p.Name,p.Kind,p.Gender,p.Age from pets p
left join procedureshistory ph
on p.petID=ph.petID
where ph.proceduretype is NULL
order by 5;

# 7. Find the name of the oldest pet.
Select * from pets
where Age=(Select max(Age) from pets); -- Three pets are the oldest having age 15

# 8. List all pets who had procedures that cost more than the average cost of all procedures. 
Select p.PetID,p.Name,p.Kind,p.Gender,p.Age, pd.Price as Procedure_Price
from pets p
join procedureshistory ph
on p.petID=ph.petID
join proceduresdetails pd
on ph.ProcedureSubCode=pd.ProcedureSubCode
and ph.ProcedureType=pd.ProcedureType
where pd.Price>(Select avg(pd2.price) from proceduresdetails pd2);

#9. Find the details of procedures performed on 'Cuddles'. 

Select ph.PetID,p.Name,p.Kind,p.Gender,p.Age,ph.Date,ph.ProcedureType,pd.Price
from procedureshistory ph
join pets p
on p.petID=ph.petID
join proceduresdetails pd
on ph.ProcedureSubCode=pd.ProcedureSubCode
and pd.Proceduretype=ph.Proceduretype
where p.Name like "%Cuddles%";

# 10. Create a list of pet owners along with the total cost they have spent on procedures and display only those
#  who have spent above the average spending. 

Select po.OwnerID,concat(po.Name," ",po.Surname) as Owner_Name ,sum(pd.Price) as Total_Spendings
from petowners po
left join pets p
on p.ownerid=po.ownerid
left join procedureshistory ph
on ph.petID=p.petID
left join proceduresdetails pd
on ph.ProcedureSubCode=pd.ProcedureSubCode
and pd.Proceduretype=ph.Proceduretype
group by 1,2
having sum(pd.Price)>(Select avg(pd2.price) from proceduresdetails pd2);

# 11. List the pets who have undergone a procedure called 'VACCINATIONS'.
Select p.Name,p.PetID,p.Gender,p.Kind
from pets p
left join procedureshistory ph
on ph.petID=p.petID
where ph.ProcedureType="VACCINATIONS";


# 12.Find the owners of pets who have had a procedure called 'EMERGENCY'. 
Select concat(po.Name," ",po.Surname) as Owner_Name,p.Name,p.Gender,p.Kind,pd.Description
from petowners po
join pets p
on p.ownerID=po.ownerID
join procedureshistory ph
on ph.petID=p.petID
join proceduresDetails pd
on pd.ProcedureType=ph.ProcedureType
and pd.ProcedureSubCode=ph.ProcedureSubCode
where pd.Description="Emergency";

# 13. Calculate the total cost spent by each pet owner on procedures. 
Select po.OwnerID,concat(po.Name," ",po.Surname) as Owner_Name ,sum(pd.Price) as Total_Spendings
from petowners po
left join pets p
on p.ownerid=po.ownerid
left join procedureshistory ph
on ph.petID=p.petID
left join proceduresdetails pd
on ph.ProcedureSubCode=pd.ProcedureSubCode
and pd.Proceduretype=ph.Proceduretype
group by 1,2
order by 3;

# 14. Count the number of pets of each kind. 
Select kind, count(*) as Pet_Count from pets
group by 1;

# 15.Group pets by their kind and gender and count the number of pets in each group. 
Select Kind as Pet,Gender, count(*) as Pet_Count from pets
group by 1,2;

# 16.Show the average age of pets for each kind, but only for kinds that have more than 5 pets. 

Select Kind,round(avg(Age),2) as Avg_Age from pets
group by 1
having count(kind)>5;

# 17 .Find the types of procedures that have an average cost greater than $50. 

Select ProcedureType, round(avg(Price),2) as Avg_Price from proceduresdetails
group by 1
having avg(Price)>50;

# 18. Classify pets as 'Young', 'Adult', or 'Senior' based on their age. Age less then 3 Young, Age between 3
# and 8 Adult, else Senior.

Select PetID,Name,Kind,Age,
	Case
		When Age<3 THEN "Young"
        WHEN AGE>8 THEN "Senior"
        ELSE "Adult"
	END as "Age Status"
from pets;

# 19. Calculate the total spending of each pet owner on procedures, labeling them as 'Low Spender' for
# spending under $100, 'Moderate Spender' for spending between $100 and $500, and 'High Spender' for
# spending over $500.
Select po.OwnerID, concat(po.Name," ",po.Surname) as Owner_Name, sum(pd.price) as Total_spending,
	Case
		WHEN sum(pd.price) is NULL THEN "No History yet"
        When sum(pd.price)<100 THEN "Low Spender"
        WHEN sum(pd.price)>500 THEN "High Spender"
        ELSE "Moderate Spender"
	END AS "Owner Spending Status"
from
petowners po
left join pets p
on po.ownerID=p.ownerID
left join procedureshistory ph
on p.PetID=ph.PetID
left join proceduresdetails pd
on ph.ProcedureSubCode=pd.ProcedureSubCode
and ph.ProcedureType=pd.ProcedureType
group by 1,2
order by 3;

# 20. Show the gender of pets with a custom label ('Boy' for male, 'Girl' for female). 
SELECT
  PetID,
  Name,
  Kind,
  CASE
    WHEN Gender = 'Male' THEN 'Boy'
    WHEN Gender = 'Female' THEN 'Girl'
    ELSE 'Unknown'
  END AS Gender_Label
FROM pets;

# 21.For each pet, display the pet's name, the number of procedures they've had, and a status label: 'Regular'
# for pets with 1 to 3 procedures, 'Frequent' for 4 to 7 procedures, and 'Super User' for more than 7 procedures. 

Select p.PetID,p.Name, count(ph.PetID) as Procedure_Count,
	CASE
		WHEN count(ph.PetID)>3 THEN "Frequent"
        WHEN count(ph.PetID)>7 THEN "Super User"
        WHEN count(ph.PetID)<=0 THEN "No History"
        ELSE "Regular"
	END as Status
from pets p
left join procedureshistory ph
on p.PetID=ph.PetID
left join proceduresdetails pd
on ph.ProcedureSubCode=pd.ProcedureSubCode
and ph.ProcedureType=pd.ProcedureType
group by 1,2
Order by 3;

# 22. Rank pets by age within each kind.
Select p.*,
Rank() Over(Partition by p.Kind order by p.Age desc) as rank_age
from pets p;

# 23. Assign a dense rank to pets based on their age, regardless of kind.

Select p.*,
dense_rank() Over(Order by p.Age desc) as rank_age
from pets p;


# 24. For each pet, show the name of the next and previous pet in alphabetical order. 
Select p.*,
lead(p.Name) over(order by p.Name) as Next_Pet,
lag(p.Name) over(order by p.Name) as Previous_Pet
from pets p;

# 25. Show the average age of pets, partitioned by their kind. 
Select p.Name,p.Kind,p.Age,
Avg(p.Age) over (partition by p.Kind) as Avg_Age_Kind
from Pets p;


# 26.Create a CTE that lists all pets, then select pets older than 5 years from the CTE. 

With allpets as (Select * from pets)
Select * from allpets where age>5
order by 5 desc;
