
use master
if not exists(select * from sys.databases d where d.name = 'gemlabs')
	begin
		create database gemlabs 
	end
go
use gemlabs
go 

--drop database gemlabs



--[ IF EXISTS DROP ]----------------

if exists(select * from INFORMATION_SCHEMA.TABLES t where t.TABLE_NAME = 'clarity')
begin
	drop table clarity
end
go 
if exists(select * from INFORMATION_SCHEMA.TABLES t where t.TABLE_NAME = 'color')
begin
	drop table color
end
go 
if exists(select * from INFORMATION_SCHEMA.TABLES t where t.TABLE_NAME = 'stoneShape')
begin
	drop table stoneShape
end
go 
if exists(select * from INFORMATION_SCHEMA.TABLES t where t.TABLE_NAME = 'stoneType')
begin
	drop table stoneType
end
go 
if exists(select * from INFORMATION_SCHEMA.TABLES t where t.TABLE_NAME = 'customer')
begin
	drop table customer
end
go 
if exists(select * from INFORMATION_SCHEMA.TABLES t where t.TABLE_NAME = 'employee')
begin
	drop table employee
end
go 
if exists(select * from INFORMATION_SCHEMA.TABLES t where t.TABLE_NAME = 'employeeType')
begin
	drop table employeeType
end
go 
if exists(select * from INFORMATION_SCHEMA.TABLES t where t.TABLE_NAME = 'labs')
begin
	drop table labs
end
go
if exists(select * from INFORMATION_SCHEMA.TABLES t where t.TABLE_NAME = 'states')
begin
	drop table states
end

--[ CREATE TABLE ]-------------------------

	create table dbo.states(
	iStateId	   int		   not null identity primary key,
	vchstateName   varchar(15) not null  constraint ck_stateName_should_not_be_empty check(vchstateName <> ''),
	--YM To simplify check len = 2
	chstateCode    char(2)     not null  constraint ck_stateCode_should_not_be_empty check(chstateCode <> '' and len(chstateCode)=2)

	)
go
create table dbo.labs(
iLabId	     int not null identity primary key,
iStateId	 int		  not null constraint f_states_labs foreign key references states(iStateId),
iGemlabsNum	 int not null constraint u_GemlabsNum_must_be_unique unique,
)--All the labs have the same name gemlabs
go
create table dbo.employeeType(
iEmployeeTypeId	     int		  not null identity primary key,
vchEmployeeTypeDesc	 varchar(20)  not null constraint EmployeeTypeDesc_cannot_be_empty check(vchEmployeeTypeDesc <> ''),
bRankValid			 bit          not null,
)
go
create table dbo.employee(
iEmployeeId	     int              not null identity primary key,
iEmployeeTypeId	 int		      not null constraint f_employeeType_employee foreign key references employeeType(iEmployeeTypeId),
iLabId			 int		      not null constraint f_labs_employee foreign key references labs(iLabId),
vchName			 varchar(35)      not null constraint Name_cannot_be_empty check(vchName <> ''),
uEmployeeCode	 uniqueidentifier not null default newid(),
iRank			 int  null constraint ck_Rank_must_be_between_1_and_4 check(iRank between 1 and 4),
)
go
create table dbo.customer(
iCustomerId		    int			not null identity primary key,
iLabId	    		int			not null constraint f_labs_customer foreign key references labs(iLabId),
iStateId		    int         not null constraint f_states_customer foreign key references states(iStateId),
vchFirstName		varchar(35) not null constraint FirstName_cannot_be_empty check(vchFirstName <> ''),
vchLastName			varchar(35) not null constraint LastName_cannot_be_empty check(vchLastName <> ''),
vchAddress			varchar(35) not null constraint Address_cannot_be_empty check(vchAddress <> ''),
vchTelephoneNum		varchar(10) not null constraint TelephoneNum_cannot_be_empty_or_exceed_10_numbers 
										 check(vchTelephoneNum <> '' and  len(vchTelephoneNum)<11 and  len(vchTelephoneNum) = 10),
)
go


create table dbo.stoneType(
iStoneTypeId	     int not null identity primary key,
vchStoneType	     varchar(20) not null constraint StoneType_cannot_be_empty check(vchStoneType <> '') 
					 constraint u_StoneType_should_be_unique unique(vchStoneType) 
)
go
create table dbo.stoneShape(
iStoneShapeId	     int not null identity primary key,
vchStoneShape	     varchar(20) not null constraint StoneShape_cannot_be_empty check(vchStoneShape <> '')
					 constraint u_StoneShape_should_be_unique unique(vchStoneShape) 
)
create table dbo.color(
iColorId	     int not null identity primary key,
vchColor	     varchar(10) not null constraint Color_cannot_be_empty check(vchColor <> '')
				 constraint u_Color_should_be_unique unique(vchColor) 				 
)
create table dbo.clarity(
iClarityId	     int not null identity primary key,
vchClarity	     varchar(10) not null constraint Clarity_cannot_be_empty check(vchClarity <> '')
				 constraint u_clarity_should_be_unique unique(vchClarity) 				 
)									 	

--[ INSERT ]---------------



insert states(vchStateName, chStateCode)
 select 'California', 'CA'		
 union select 'Texas', 	'TX'		
 union select 'Florida', 'FL'		
 union select 'New York', 'NY'		
 union select 'Illinois', 'IL'		
 union select 'Pennsylvania','PA'	
 union select 'Ohio', 'OH'			
 union select 'Georgia', 'GA'		
 union select 'North Carolina', 'NC'
 union select 'Michigan', 'MI'		
 union select 'New Jersey', 'NJ'	
 union select 'Virginia', 'VA'		
 union select 'Washington', 'WA'	
 union select 'Massachusetts', 'MA'	
 union select 'Arizona', 'AZ'		
 union select 'Indiana', 'IN'		
 union select 'Tennessee', 'TN'		
 union select 'Missouri', 'MO'		
 union select 'Maryland', 'MD'		
 union select 'Wisconsin', 'WI'		
 union select 'Minnesota', 'MN'		
 union select 'Colorado', 'CO'		
 union select 'Alabama', 'AL'		
 union select 'South Carolina', 'SC'
 union select 'Louisiana', 'LA'		
 union select 'Kentucky', 'KY'		
 union select 'Oregon', 'OR'		
 union select 'Oklahoma', 'OK'		
 union select 'Connecticut', 'CT'	
 union select 'Iowa', 'IA'			
 union select 'Arkansas','AR'		
 union select 'Mississippi','MS'	
 union select 'Utah', 'UT'			
 union select 'Kansas', 'KS'		
 union select 'Nevada', 'NV'		
 union select 'New Mexico', 'NM'	
 union select 'Nebraska', 'NE'		
 union select 'West Virginia', 'WV'	
 union select 'Idaho', 'ID'			
 union select 'Hawaii', 'HI'		
 union select 'Maine', 'ME'			
 union select 'New Hampshire','NH'	
 union select 'Rhode Island', 'RI'	
 union select 'Montana', 'MT'		
 union select 'Delaware', 'DE'		
 union select 'South Dakota', 'SD'	
 union select 'North Dakota', 'ND'	
 union select 'Alaska', 'AK'		
 union select 'Vermont', 'VT'		
 union select 'Wyoming', 'WY'		
order by 1



--labs
insert labs(iStateId, iGEMLABSnum) 	
		select s.iStateId  ,1
		from states s		  
		where s.chStateCode  =  'FL'   
		union	
		select s.iStateId  ,2
		from states s		  
		where s.chStateCode  =  'NY'   
		union	 
		select s.iStateId  ,3
		from states s		  
		where s.chStateCode  =  'NJ' 

--employeeType
insert employeeType(vchEmployeeTypeDesc, bRankValid)
select 'cachier',0
union select 'acount rep', 0
union select 'gemologist', 1

--customer
insert customer(iLabId, vchFirstName, vchLastName, vchAddress, vchTelephoneNum, iStateId )
select l.iLabId, 'muster', 'feld', '56 verbel street', '9427890678', s.iStateId
from labs l
join states s
on s.chstateCode = 'FL'
where l.iGemlabsNum = 1
union select l.iLabId, 'yemhem', 'kenter', '32 salt street', '6287364824', s.iStateId
from labs l
join states s
on s.chstateCode = 'FL'
where l.iGemlabsNum = 1

--stoneType
insert stoneType(vchStoneType)
      select 'White Diamond'
union select 'Colored Diamond'
union select 'Gemstone MINOR'
union select 'Gemstone MAJOR'
union select 'Pearl'
union select 'Synthetic Stone'
union select 'Rough Diamond'

--stoneShape
insert stoneShape(vchStoneShape)
      select 'Round Brilliant'
union select 'Pear'
union select 'Princess Sq'
union select 'Cushion Rect'
union select 'Emerald'
union select 'Oval'
union select 'Radiant'
union select 'Marquise'
union select 'Heart'
union select 'Old European'
union select 'Old Mine'
union select 'Transition'
union select 'Princess Rect'
union select 'Trademark'
union select 'Trapezoid'
union select 'Half Moon'
union select 'Mixed'
union select 'Crown of Light®'
union select 'Emerald Sq'
union select 'Baguette'
union select 'Kite'
union select 'Cushion Sq'
union select 'CCSMB'
union select 'Shield'
union select 'Rose Cut'
union select 'Crisscut'
union select 'Triangular'
union select 'Tapered Pentagon'
union select 'Shield Step'
union select 'Single Cut'
union select 'Rectangular'

--color
insert color(vchColor)
      select 'D'
union select 'E'
union select 'F'
union select 'G'
union select 'H'
union select 'I'
union select 'J'
union select 'K'
union select 'L'
union select 'M'
union select 'N'
union select 'O - P'
union select 'Q - R'
union select 'S - T'
union select 'U - V'
union select 'W - X'
union select 'Y - Z'

--clarity
insert clarity(vchClarity)
      select 'FL'
union select 'IF'
union select 'VVS1'
union select 'VVS2'
union select 'VS1'
union select 'VS2'
union select 'SI1'
union select 'SI2'
union select 'SI3'
union select 'I1'
union select 'I2'
union select 'I3'
union select 'Black'