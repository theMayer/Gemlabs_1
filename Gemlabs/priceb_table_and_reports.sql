use gemlabs
go

alter table price add iPriceId int identity(1,1)

go

delete e
--select * 
from price e 
where e.iPriceId in
(
select
min(p.iPriceId)
from price p
group by  p.clarity, p.color, p.weight_from, p.weight_to
having count(*)>1
)
go
if exists(select * from INFORMATION_SCHEMA.TABLES t where t.TABLE_NAME = 'priceb')
begin
	drop table priceb
end
go 
create table dbo.priceb(
iPricebId	 int            not null identity primary key,
iColorId	 int			not null constraint color_priceb foreign key references color(iColorId),
iClarityId	 int			not null constraint clarity_priceb foreign key references clarity(iClarityId),
weight_from	 decimal(4,2)   not null constraint ck_weight_from_cannot_be_0_or_more_then_10_point_00 check(weight_from > 0.00 and weight_from < 10.01),
weight_to	 decimal(4,2)   not null,-- constraint ck_weight_to_cannot_be_0_or_more_then_10_point_00 check(weight_to > 0.00 and weight_to < 10.01),
mPrice		 money			not null
constraint u_unique unique(weight_from,weight_to,iColorId,iClarityId),constraint ck_weight_from_should_be_less_then_weight_to check(weight_from < weight_to )
)
go
insert priceb(iColorId, iClarityId, weight_from, weight_to, mPrice)
select r.iColorId, c.iClarityId, p.weight_from, p.weight_to, p.price
from price p
join clarity c
on c.vchClarity = p.clarity
join color r
on r.vchColor = p.color

--the select below can be used to insert the mPrice column in the stone table
--s/a/u/t/o/w/g/c/r/y/e
select u.vchFirstName, u.vchLastName, t.vchStoneType, o.vchStoneShape, w.dCarat, r.vchColor,y.vchClarity, e.mPrice --*, p.vchStoneType, n.vchStoneShape, w.dCarat, r.vchColor, y.vchClarity  
from stone s
join parcel a
on a.iParcelId = s.iParcelId
join customer u
on u.iCustomerId = a.iCustomerId
join stoneType t
on t.iStoneTypeId = s.iStoneTypeId
join stoneShape o
on o.iStoneShapeId = s.iStoneShapeId
join gradeWeight w
on w.iStonelId = s.iStonelId
join gradeColor g
on g.iStonelId = s.iStonelId
join gradeClarity c
on c.iStonelId = s.iStonelId
join color r
on g.iColorId = r.iColorId
join clarity y
on y.iClarityId = c.iClarityId
join priceb e
on e.iClarityId =  y.iClarityId and e.iColorId = r.iColorId and e.weight_from <= w.dCarat and e.weight_to >= w.dCarat
--StoneType / stone shape / carat / color / clearity
go

--1---------------------------------------------------------

--where stones  are at the current moment [i.e. 8 stones at color]

go
create or alter function dbo.lastStation(@iStoneId int)
returns varchar(90)
as
begin 
	declare @station varchar(90)

select top 1 @station = concat('customer Name: ', c.vchLastName,' ', c.vchFirstName,', Stone Id: ', s.iStonelId,', Station: ',isnull(n.vchStation,m.vchEmployeeTypeDesc),',')--, isnull(n.vchStation,)--, dbo.lastStation(s.iStonelId)
from customer c
join parcel p
on c.iCustomerId = p.iCustomerId
join stone s
on s.iParcelId = p.iParcelId
left join parcelStation t
on t.iParcelId = p.iParcelId
left join station n
on n.iStationId = t.iStationId
join employee d
on d.iEmployeeId = p.iEmployeeId
join employeeType m
on m.iEmployeeTypeId = d.iEmployeeTypeId
where s.iStonelId = @iStoneId --and v.dDate = 
--group by  e.vchStation ,v.dDate, l.vchFirstName, e.vchStation	 
order by isnull(t.dDate,p.dDate) desc

return @station
end
go


select dbo.lastStation(3)

--2--------------------------------------------------------

--how long does it take to get from 1 station to another
--this function you put in stoneId and stationId and returns how long it was at station 
go
create or alter function dbo.stationTime(@iStoneId int, @iSequence int)
returns varchar(200)
as
begin 

	declare @days varchar(200)

select @days =
concat('the stone with the Id ', s.uStoneId
,' was at '
,isnull(n.vchStation,'cashier')
,' from '
, v.dDate)
+case
when cc.dDate is null then concat(' stone is still at station. number of days = ', datediff(day,v.dDate,getdate()))
when cc.dDate is not null then 
concat(
' till '
,cc.dDate
,' number of days = '
, datediff(day,v.dDate,cc.dDate))--, z.	
end
from stone s						
join  parcel p							 							
on p.iParcelId = s.iParcelId		
left join parcelStation v				
on v.iParcelId = s.iParcelId
left join station n
on n.iStationId = v.iStationId
left join station z
on z.iSequence = @iSequence + 1
left join parcelStation cc
on cc.iStationId = z.iStationId
where s.iStonelId = @iStoneId and  n.iSequence =  @iSequence

return isnull(@days,'the stone is at the cashier or was never at this station')

end
go

select dbo.stationTime(3,2)
---
select vchMeasuringToClarity = dbo.stationTime(s.iStonelId, 1), vchColorToClarity= dbo.stationTime(s.iStonelId, 2),
	   vchToColor = dbo.stationTime(s.iStonelId, 3), ClarityToPickUp= dbo.stationTime(s.iStonelId, 4)
from stone s
--1)the stone with the Id 1 was at color from 2020-02-07 till 2020-02-08 number of days = 1
--2)the stone with the Id 1 was at pick up from 2020-02-09 stone is still at station. number of days = 158
--3)the stone is at the cashier or was never at this station
go





