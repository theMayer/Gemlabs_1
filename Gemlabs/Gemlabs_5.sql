use gemlabs
go

--[ IF EXISTS DROP ]----------------

if exists(select * from INFORMATION_SCHEMA.TABLES t where t.TABLE_NAME = 'gradeColor')
begin
	drop table gradeColor
end
go 
if exists(select * from INFORMATION_SCHEMA.TABLES t where t.TABLE_NAME = 'gradeClarity')
begin
	drop table gradeClarity
end
go 
if exists(select * from INFORMATION_SCHEMA.TABLES t where t.TABLE_NAME = 'gradeWeight')
begin
	drop table gradeWeight
end
 
 --[ CREATE TABLE ]-------------------------

go
create table dbo.gradeWeight(
iGradeWeightId int			  not null identity primary key,
iStonelId		 int			  not null constraint stone_iStonelId foreign key references stone(iStonelId),
iEmployeeId	     int			  not null constraint employee_iEmployeeId foreign key references employee(iEmployeeId),
dCarat			 decimal(4,2)	  not null constraint Carat_cannot_be_0_or_more_then_10_point_00 check(dCarat > 0.00 and dCarat < 10.01),
dDate			 date             not null default getdate()
)
go
create table dbo.gradeColor(
iGradeColorId    int  not null identity primary key,
iStonelId		 int  not null constraint sstone_iStonelId foreign key references stone(iStonelId),
iEmployeeId	     int  not null constraint eemployee_iEmployeeId foreign key references employee(iEmployeeId),
iColorId		 int  not null constraint color_iColorId foreign key references color(iColorId),
dDate			 date not null default getdate()
)
go
create table dbo.gradeClarity(
iGradeClarityId  int  not null identity primary key,
iStonelId		 int  not null constraint ssstone_iStonelId foreign key references stone(iStonelId),
iEmployeeId	     int  not null constraint eeemployee_iEmployeeId foreign key references employee(iEmployeeId),
iClarityId		 int  not null constraint clarity_iClarityId foreign key references clarity(iClarityId),
dDate			 date not null default getdate()
)
go


--[ INSERT ]---------------


go
--gradeWeight
insert gradeWeight(iStonelId, iEmployeeId, dCarat)--select * from parcel p
select n.iStonelId, e.iEmployeeId, 1.90
from stone n
join employee e
on e.vchName = 'anda'
where n.iStonelId = 1
union select n.iStonelId, e.iEmployeeId, 3.00
from stone n
join employee e
on e.vchName = 'anda'
where n.iStonelId = 2

--gradeColor  
 insert gradeColor(iStonelId, iEmployeeId, iColorId)--select * from parcel p
select n.iStonelId, e.iEmployeeId, c.iColorId
from stone n
join employee e
on e.vchName = 'astick'
join color c
on c.vchColor = 'M'
where n.iStonelId = 1
union select n.iStonelId, e.iEmployeeId, c.iColorId
from stone n
join employee e
on e.vchName = 'astick'
join color c
on c.vchColor = 'L'
where n.iStonelId = 2

--gradeClarity  
 insert gradeClarity(iStonelId, iEmployeeId, iClarityId)--select * from parcel p
select n.iStonelId, e.iEmployeeId, c.iClarityId
from stone n
join employee e
on e.vchName = 'brick'
join clarity c
on c.vchClarity = 'SI1'
where n.iStonelId = 1
union select n.iStonelId, e.iEmployeeId, c.iClarityId
from stone n
join employee e
on e.vchName = 'brick'
join clarity c
on c.vchClarity = 'VS1'
where n.iStonelId = 2

