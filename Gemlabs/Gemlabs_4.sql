use gemlabs
go

--[ IF EXISTS DROP ]----------------

if exists(select * from INFORMATION_SCHEMA.TABLES t where t.TABLE_NAME = 'parcelStation')
begin
	drop table parcelStation
end
go
if exists(select * from INFORMATION_SCHEMA.TABLES t where t.TABLE_NAME = 'station')
begin
	drop table station
end
go
if exists(select * from INFORMATION_SCHEMA.TABLES t where t.TABLE_NAME = 'stone')
begin
	drop table stone
end
go
create table dbo.stone(
iStonelId		 int			  not null identity primary key,
iParcelId		 int			  not null constraint f_parcel_stone foreign key references parcel(iParcelId),
iStoneTypeId	 int			  not null constraint f_stoneType_stone foreign key references stoneType(iStoneTypeId),
iStoneShapeId	 int			  not null constraint f_stoneShape_stone foreign key references stoneShape(iStoneShapeId),
iStoneNum		 int			  not null,
uStoneId         uniqueidentifier not null default newid(),
dDate			 date             not null default getdate(),
mPrice			 money
)

go
create table dbo.station(
iStationId	int	       not null identity primary key,
vchStation	varchar(20)   not null constraint Station_cannot_be_empty check(vchStation <> '')
							       constraint u_Station_should_be_unique unique(vchStation),
iSequence	int            not null
)
go
create table dbo.parcelStation(
iParcelStationId int			  not null identity primary key,
iStationId		 int			  not null constraint f_station_parcelStation foreign key references station(iStationId),
iParcelId		 int			  not null constraint f_parcel_parcelStation foreign key references parcel(iParcelId),
iEmployeeId	     int			  not null constraint f_employee_parcelStation foreign key references employee(iEmployeeId),
dDate			 date             not null default getdate()
)
go
--[ INSERT ]---------------

--stone
insert stone(iParcelId, iStoneTypeId, iStoneShapeId, iStoneNum)--select * from parcel p
select p.iParcelId, t.iStoneTypeId, s.iStoneShapeId, 1
	from parcel p
	join stoneType t
	on t.vchStoneType = 'Colored Diamond'
	join stoneShape s
	on s.vchStoneShape = 'Baguette'
	where p.iParcelId = 1
union select p.iParcelId, t.iStoneTypeId, s.iStoneShapeId, 2
	from parcel p
	join stoneType t
	on t.vchStoneType = 'Colored Diamond'
	join stoneShape s
	on s.vchStoneShape = 'Cushion Rect'
	where p.iParcelId = 1

union select p.iParcelId, t.iStoneTypeId, s.iStoneShapeId, 1
	from parcel p
	join stoneType t
	on t.vchStoneType = 'Colored Diamond'
	join stoneShape s
	on s.vchStoneShape = 'Cushion Rect'
	where p.iParcelId = 2

--station
insert station(vchStation, iSequence)

	  select 'measuring', 1
union select 'color'	, 2
union select 'clearity'	, 3
union select 'pick up'	, 4
union select 'picked up', 5

--parcelStation
insert parcelStation(iStationId, iParcelId, iEmployeeId, dDate)
select s.iStationId, p.iParcelId, e.iEmployeeId, '2/6/2020'
from station s
join parcel p 
on p.iParcelId = 1
join employee e
on e.vchName = 'anda'
where s.vchStation = 'measuring'
union select s.iStationId, p.iParcelId, e.iEmployeeId, '2/7/2020'
from station s
join parcel p 
on p.iParcelId = 1
join employee e
on e.vchName = 'astick'
where s.vchStation = 'color'

union select s.iStationId, p.iParcelId, e.iEmployeeId, '2/8/2020'
from station s
join parcel p 
on p.iParcelId = 1
join employee e
on e.vchName = 'brick'
where s.vchStation = 'clearity'

union select s.iStationId, p.iParcelId, e.iEmployeeId, '2/9/2020'
from station s
join parcel p 
on p.iParcelId = 1
join employee e
on e.vchName = 'mcbeam'
where s.vchStation = 'pick up'

