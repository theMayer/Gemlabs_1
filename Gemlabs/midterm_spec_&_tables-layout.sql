
/*
locations
	states
	labs
personal
	cachier
	acounts rap
	measurer
	colorist
	clearitist
stone from-to
	cachier
	acounts rap
	measurer
	colorist
	clearitist
	pick-up
personal job
	cachier
		stone type
		stone shape
	acounts rap
		contact
	measurer
		size in carat--decimal 0.00>10.01
	colorist
		color
	clearitist	
		clarity
timestamp for stone recieve
	cachier
	acounts rap
	measurer
	colorist
	clearitist	
timestamp for stone attribute with attribute
	cachier
	acounts rap
	measurer
	colorist
	clearitist	
IMPORTANT: tables for loose stones and attached stones 
----------------------------------
somtimes stone may have 2 or 3 colorists or clearitists evaluating stone with their id and time-stamp
attached to their opinion, in that case if both are in the same rank the later opinion matters if one is of higher rank
we go acording to his opinion

stones standard description: StoneType / stone shape / carat / color / clearity

stone value based on carat / color / clearity

never deletefrom system even the CERTIFICATE is reevaluated

[REPORTS]
number of parcels and where they are at the current moment [i.e. 8 stones at color]
how long does it take to get from 1 station to another
cutomer name / parcel / number of stones


---------------------------------------------


company has multiple labs

each lab location works as decribed below

pesonal consists of:  cachier / acounts rap / measurer / colorist / clearitist

every profassional has a ranking based on lenght of time he is in the field

every activity comes with a time-stamp
------------------
customer comes in with single stone or multiple stones on a jewelry

gives it to cachier

cachier puts it in parcel

parcel gets a barcode, if there are "multiple stones on jewelry" every stone gets seperate barcode from parcel

	[table 1 is for single stones] parcel  barcode / "StoneType" / "stone shape" / cachier "barcode" / "costomer id"  

	[table 2 is for connected stones parcel]same as "table 1" minus "StoneType" / "stone shape"

	[table 3 is for connected stones]"table 2 Id" / stone barcode / "StoneType" / "stone shape" 

cahier asighines acount manager who should be contacted or should contact customer

--[cashier gives to measurer]-----

measurer scans parcel and his barcode  with time-stamp

when finnish he puts in second table "carat amount". together with his and stone barcode and timestamp

--[measurer gives to colorist]-----

same as measurer, colorist scans parcel and his barcode  with time-stamp

when finnish he puts in second table "color code". together with his and stone barcode and timestamp

--[colorist gives to clearitist]-----

same as colorist, clearitist scans parcel and his barcode  with time-stamp

when finnish he puts in second table "clearity code". together with his and stone barcode and timestamp

--[colorist puts it at pickup]-----
customer pics up

---keep out to keep simple-------if not satisfied with report he contacts acount rep who might say to bring it back to lab for reevaluation
---------------------------------------------------

somtimes stone may have 2 or 3 colorists or clearitists evaluating stone with their id and time-stamp
attached to their opinion, in that case if both are in the same rank the later opinion matters if one is of higher rank
we go acording to his opinion
---------------------------------------------------
stones should have standard description of: StoneType / stone shape / carat / color / clearity
---------------------------------------
[CERTIFICATE]
stone value based on carat / color / clearity
never deletefrom system even the CERTIFICATE is reevaluated
[REPORTS]
number of parcels and where they are at the current moment [i.e. 8 stones at color]
how long does it take to get from 1 station to another
cutomer name / parcel / number of stones

*/

--TABLE LAYOUT BELOW

/*
initials and there meaning
pk  primary key
f   foreign key

c   char
vc  varchar
i	int
dm  decimal
d	date
ui	uniqueidentifier
b	bit

dft default
ct  constraint
ck  check constraint
u   unique
n   null --every column is not null unless specified with an "n"

states
	iStateId			i	pk
	chstateCode			c   ck(2and<>'')	u
	vchstateName		vc	ck(<>'')		u
labs
	iLabId				i   pk
	iStateId			i	f
	iGemlabsNum			i	u		
ranking
	iRankingId			i	pk
	iRankNum			i	ck(>0 and <5)	
	iYearsOfExperience	i
											u(iRankNum,iYearsOfExperience)
cashier
	icashierId			i	pk
	iLabId				i	f
	uCachierId			ui	dft
accountRep
	iAccountRepId		i	pk
	iLabId				i	f
	uAccountRepId		ui	dft
measurer
	iMeasurerId			i	pk
	uMeasurerId 		ui	dft
	iLabId				i	f
	dFromYear			d	dft
	iRankingId			i	f			(>0 and <5)	--function to calculate rank from date	
colorist
	iColoristId			i	pk
	uColoristId     	ui	dft
	iLabId	    		i	f
	dFromYear   		d	dft
	iRankingId			i	f
clearitist
	iClearitistId		i	pk
	uClearitistId		ui	dft    
	iLabId				i	f
	dFromYear			d	dft
	iRankingId	 		i	f	
customer				
	iCustomerId	   		i
	iLabId	     		i	f
	vchFirstName   		vc	ck
	vchLastName    		vc	ck
	vchAddress     		vc	ck
	vchTelephoneNum		vc	ck
	iState		   		i	f
								--in some places children have the same name as parents so "FirstName LastName Address" can not be unique
											MWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMMWMWMW

cashierParcel
	iCashierParcelId	i	pk
	icashierId			i	f
	iCustomerId			i	f
	uBarcode			ui	dft
	dtTime				d	dft
cashierAttached
	iCashierAttachedId  i	pk
	iCashierParcelId	i   f
	uBarcode			ui	dft
	dtTime				d	dft
accountRepAssign
	iaccountRepAssignId	i	pk
	iCashierParcelId	i	f
	iAccountRepId		i	f
	dtTime				d	dft
							
											MWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMMWMWMW
stoneLocationAndDesc					
	iStoneLocationAndDesc	i	pk
	iCashierParcelId	    i	f
	iCashierAttachedId		i	f
	vchStoneType			vc	ck	
	vchStoneShape			vc	ck
	iMeasurerId				i	f
	dcarat					dm	ck			>0.00 and 10.01<
	iColoristId				i	f
	vchColor				vc	ck
	iClearitistId			i	f
	vchClarity				vc	ck
	dDate					d	dft							
								check (the columns grouped should not be null
								 and others should be null, this doesn't include
								 the columns "iStoneLocationAndDesc / dDate")

iCashierParcelId
vchStoneType
vchStoneShape

iCashierAttachedId
vchStoneType
vchStoneShape

	iCashierParcelId
	iMeasurerId

	iCashierAttachedId
	iMeasurerId
	
	iCashierParcelId
	iMeasurerId
	dcarat
	
	iCashierAttachedId
	iMeasurerId
	dcarat

iCashierParcelId
iColoristId

iCashierAttachedId
iColoristId

iCashierParcelId
iColoristId
vchColor

iCashierAttachedId
iColoristId
vchColor
	
	iCashierParcelId
	iColoristId
	
	iCashierAttachedId
	iColoristId
	
	iCashierParcelId
	iColoristId
	vchClarity
	
	iCashierAttachedId
	iColoristId
	vchClarity

*/















