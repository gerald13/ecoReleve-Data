
/****** Object:  StoredProcedure [dbo].[sp_validate_Argos_GPS]    Script Date: 22/11/2015 10:34:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[sp_validate_GSM]
	@listID xml,
	@ind int,
	@user int,
	@ptt int , 
	@nb_insert int OUTPUT,
	@exist int output, 
	@error int output
	
	
AS
BEGIN
   
	SET NOCOUNT ON;
	DECLARE @data_to_insert table ( 
		data_id int,FK_Sensor int, date_ datetime, lat decimal(9,5), lon decimal(9,5)
		,ele int,hdop int , 
		speed int,course int, type_ varchar(3),
		 FK_ind int,creator int,name varchar(100)
		 );

	DECLARE @data_duplicate table ( 
		data_id int,fk_sta_id int
		);

	DECLARE @output TABLE (sta_id int,data_id int,type_ varchar(3));
	DECLARE @NbINserted int ; 

INSERT INTO @data_to_insert (
data_id ,FK_Sensor , date_ , lat , lon,ele,hdop
 ,speed,course ,type_,
  FK_ind ,creator )
SELECT 
[PK_id],FK_Sensor,[date],[lat],[lon],[ele]
,[hdop]
,[speed],[course],'GSM'
,@ind,@user
FROM VGSMData_With_EquipIndiv
WHERE PK_id in (
select * from [dbo].[XML_int] (@listID)
) and checked = 0

-- check duplicate location before insert data in @data_without_duplicate
insert into  @data_duplicate  
select d.data_id, s.ID
from @data_to_insert d 
join Individual_Location s 
	on d.lat=s.LAT and d.lon = s.LON and d.date_ = s.DATE and s.FK_Individual = d.FK_ind


-- insert data creating new Location
INSERT INTO [dbo].[Individual_Location]
           ([LAT]
           ,[LON]
           ,[Date]
           ,[Precision]
           ,[FK_Sensor]
           ,[FK_Individual]
           ,[ELE]
           ,[creationDate]
           ,[creator]
           ,[type_]
		   ,OriginalData_ID)
select 
lat,
lon,
date_,
CASE 
	WHEN hdop is null then 26
	ELSE hdop
 END
,FK_Sensor
,FK_ind
,ele
,GETDATE()
,@user
,[type_]
,'Tgsm'+CONVERT(VARCHAR,data_id)
from @data_to_insert i
where i.data_id not in (select data_id from @data_duplicate)
SET @NbINserted=@@ROWCOUNT

update ecoReleve_Sensor.dbo.Tgsm set imported = 1 where PK_id in (select data_id from @data_to_insert)
update VGSMData_With_EquipIndiv set checked = 1 where FK_ptt = @ptt and [FK_Individual] = @ind

SET @nb_insert = @NbINserted
SELECT @exist = COUNT(*) FROM @data_duplicate
SET @error=@@ERROR

RETURN
END


GO


