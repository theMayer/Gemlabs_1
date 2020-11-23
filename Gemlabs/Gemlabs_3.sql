use gemlabs

--[ IF EXISTS DROP ]----------------

go
if exists(select * from INFORMATION_SCHEMA.TABLES t where t.TABLE_NAME = 'parcel')
begin
	drop table parcel
end
 


go
create table dbo.parcel(
iParcelId		 int not null identity primary key,
iCustomerId		 int not null constraint customer_iCustomerId foreign key references customer(iCustomerId),
iEmployeeId		 int not null constraint f_employee_iEmployeeId foreign key references employee(iEmployeeId),
uParcelId		 uniqueidentifier not null default newid(),
dDate			 date             not null default getdate()
)	
go


--employee	
insert employee(iEmployeeTypeId, vchName, iLabId, iRank )
select e.iEmployeeTypeId, 'joen', l.iLabId, null
from employeeType e
join labs l
on l.iGemlabsNum = 1
where e.vchEmployeeTypeDesc = 'cachier'
union select e.iEmployeeTypeId, 'mcbeam', l.iLabId, null
from employeeType e
join labs l
on l.iGemlabsNum = 1
where e.vchEmployeeTypeDesc = 'acount rep'
union select e.iEmployeeTypeId, 'rosten', l.iLabId, 1
from employeeType e
join labs l
on l.iGemlabsNum = 1
where e.vchEmployeeTypeDesc = 'gemologist'
union select e.iEmployeeTypeId, 'cainmain', l.iLabId, 3
from employeeType e
join labs l
on l.iGemlabsNum = 1
where e.vchEmployeeTypeDesc = 'gemologist'
union select e.iEmployeeTypeId, 'astick', l.iLabId, 2
from employeeType e
join labs l
on l.iGemlabsNum = 1
where e.vchEmployeeTypeDesc = 'gemologist'
union select e.iEmployeeTypeId, 'anda', l.iLabId, 1
from employeeType e
join labs l
on l.iGemlabsNum = 1
where e.vchEmployeeTypeDesc = 'gemologist'
union select e.iEmployeeTypeId, 'brick', l.iLabId, 4
from employeeType e
join labs l
on l.iGemlabsNum = 1
where e.vchEmployeeTypeDesc = 'gemologist'

--parcel
insert parcel(iCustomerId, iEmployeeId)
select c.iCustomerId, e.iEmployeeId
from customer c
join employee e
on e.iEmployeeId = 2
where c.vchTelephoneNum = '9427890678'
union select c.iCustomerId, e.iEmployeeId
from customer c
join employee e
on e.iEmployeeId = 2
where c.vchTelephoneNum = '6287364824'



