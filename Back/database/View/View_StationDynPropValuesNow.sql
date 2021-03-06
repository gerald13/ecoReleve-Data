/****** Script de la commande SelectTopNRows à partir de SSMS  ******/

CREATE VIEW StationDynPropValuesNow AS
SELECT dyn_val.*,dyn.name,dyn.TypeProp FROM 
  StationDynPropValue dyn_val 
  JOIN StationDynProp dyn ON dyn_val.FK_StationDynProp = dyn.ID
	 where not exists (select * from  StationDynPropValue  V2 
         where V2.FK_StationDynProp  =  dyn_val.FK_StationDynProp  and V2.FK_Station = dyn_val.FK_Station
        AND V2.startdate > dyn_val.startdate AND V2.startdate <= getdate())
	  AND dyn_val.startdate <= getdate()
	

  