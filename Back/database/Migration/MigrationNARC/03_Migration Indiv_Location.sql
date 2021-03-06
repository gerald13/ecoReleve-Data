/****** Script de la commande SelectTopNRows à partir de SSMS  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---- migration des données argos/GPS/GSM --------------------------------------------------------------------------------------------
INSERT INTO [Individual_Location]
           ([LAT]
           ,[LON]
           ,[Date]
           ,[Precision]
		   ,[ELE]
		   ,creator
		   ,CreationDate
           ,[FK_Sensor]
           ,[FK_Individual]
		   ,type_
		   ,OriginalData_ID
		   ,fk_region)
SELECT [LAT]
      ,[LON]
	  ,[DATE]
      ,[Precision]
      ,[ELE]
      ,[Creator]
      ,[Creation_date]
	  ,s.ID as fk_sensor
	  ,CASE WHEN a.FK_TInd_ID IS NOT NULL THEN a.FK_TInd_ID ELSE g.FK_TInd_ID END as fk_ind
	  ,CASE WHEN a.FK_TInd_ID IS NOT NULL THEN 'argos' ELSE 'gps' END as type_
	  ,CASE WHEN a.FK_TInd_ID IS NOT NULL THEN 'eReleve_TProtocolDataArgos_'+CONVERT(VARCHAR,a.PK) ELSE 'eReleve_TProtocolDataGPS_'+CONVERT(VARCHAR,g.PK) END
	  ,R.ID
  FROM [NARC_eReleveData].[dbo].[TStations] sta
  LEFT JOIN [NARC_eReleveData].[dbo].TProtocol_ArgosDataArgos a ON sta.TSta_PK_ID = a.FK_TSta_ID
  LEFT JOIN [NARC_eReleveData].[dbo].TProtocol_ArgosDataGPS g ON sta.TSta_PK_ID = g.FK_TSta_ID
  --LEFT JOIN Individual i ON a.FK_TInd_ID = i.ID
  --LEFT JOIN Individual i2 ON g.FK_TInd_ID = i2.ID
  LEFT JOIN Region R ON sta.Region = r.Region
  LEFT JOIN Sensor s ON CASE WHEN sta.name like 'argos_%' THEN  substring(replace(sta.name,'argos_',''),1,charindex('_',(replace(sta.name,'argos_','')))-1)
					ELSE NULL END  
					= s.UnicIdentifier
  where [FieldActivity_ID] = 27



  ------------------------ migration des données RFID --------------------------------------------------------------------------------------------
  
  /*INSERT INTO [Individual_Location]
           ([LAT]
           ,[LON]
           ,[Date]
		   ,creator
		   ,CreationDate
           ,[FK_Sensor]
           ,[FK_Individual]
		   ,type_
		   ,OriginalData_ID)
  SELECT [lat]
      ,[lon]
	  ,[date_]
	  ,[FK_creator]
      ,[creation_date]
	  ,s.ID
      ,i.ID
	  ,'rfid'
	  ,'eReleve_TAnimalLocation_'+CONVERT(VARCHAR,a.PK_id)

  FROM [NARC_eReleveData].[dbo].[T_AnimalLocation] a
  JOIN Individual i ON 'eReleve_'+CONVERT(Varchar,a.FK_ind) = i.Original_ID
  JOIN Sensor s ON a.FK_obj = s.UnicIdentifier

  */

  INSERT INTO [Individual_Location]
           ([LAT]
           ,[LON]
           ,[Date]
     ,creator
     ,CreationDate
           ,[FK_Sensor]
           ,[FK_Individual]
     ,type_
     ,OriginalData_ID)
  SELECT [lat]
      ,[lon]
   ,[date_]
   ,a.[FK_creator]
      ,a.[creation_date]
   ,s.ID
      ,i.ID
   ,'RFID'
   ,'eReleve_TAnimalLocation_'+CONVERT(VARCHAR,a.PK_id)
   --,a.
  FROM [NARC_eReleveData].[dbo].[T_AnimalLocation] a
  JOIN Individual i ON a.FK_ind = i.ID
  JOIN [NARC_eReleveData].[dbo].[T_Object] o on o.PK_id = a.FK_obj 
  JOIN Sensor s ON o.PK_id = s.id