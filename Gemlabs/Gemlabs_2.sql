use gemlabs
go

create or alter function dbo.ranks(@iEmployeeTypeId  int)
returns bit
as
begin
declare @bBit as bit

select @bBit = t.bRankValid
from employeeType t
where t.iEmployeeTypeId = @iEmployeeTypeId
return @bBit
end

 go
 alter table employee add constraint ck_employeeType_does_not_require_a_rank check((dbo.ranks(iEmployeeTypeId)=1 and iRank is not null) or (dbo.ranks(iEmployeeTypeId)=0 and iRank is null))