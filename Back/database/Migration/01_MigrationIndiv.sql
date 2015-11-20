-----------------------------------INSERT Static Prop Values -------------------------------------------------------------
INSERT INTO Individual (
[creationDate],
Age,
Species,
Birth_date,
Death_date,
Original_ID,
fk_individualType
)
SELECT o.[Creation_date]
      ,[id2@Thes_Age_Precision]
	  ,[id34@TCaracThes_Species_Precision]
      ,[id35@Birth_date]
      ,[id36@Death_date]
	  ,'eReleve_'+CONVERT(VARCHAR,Individual_Obj_PK)
	  , IT.ID
FROM [ECWP-eReleveData].[dbo].[TViewIndividual] I
JOIN [ECWP-eReleveData].[dbo].TObj_Objects o on I.Individual_Obj_PK = o.Object_Pk
JOIN IndividualType IT ON  IT.name ='Standard'
GO

-----------------------------------INSERT Sex in Dynamic Prop Values -------------------------------------------------------------
INSERT INTO IndividualDynPropValue(
		[StartDate]
      ,[ValueString]
      ,[FK_IndividualDynProp]
      ,[FK_Individual]
) 
SELECT I.[creationDate],
		IV.[id30@TCaracThes_Sex_Precision],
		(SELECT ID FROM IndividualDynProp WHERE Name = 'Sex'),
		I.ID
FROM [ECWP-eReleveData].[dbo].[TViewIndividual] IV 
JOIN Individual I ON 'eReleve_'+CONVERT(VARCHAR,IV.Individual_Obj_PK) = I.Original_ID
GO

-----------------------------------INSERT Dynamic Prop Values -------------------------------------------------------------
INSERT INTO IndividualDynPropValue(
		[StartDate]
      ,[ValueInt]
      ,[ValueString]
      ,[ValueDate]
      ,[ValueFloat]
      ,[FK_IndividualDynProp]
      ,[FK_Individual]
)

SELECT
val.begin_date,
Case 
	WHEN dp.TypeProp = 'Integer' AND val.value_precision is NULL THEN val.value
	WHEN dp.TypeProp = 'Integer' AND val.value_precision is NOT NULL THEN val.value_precision
	ELSE NULL
	END as ValueInt,
Case 
	WHEN dp.TypeProp = 'String' AND val.value_precision is NULL THEN val.value
	WHEN dp.TypeProp = 'String' AND val.value_precision is NOT NULL THEN val.value_precision
	ELSE NULL
	END as ValueString,
Case 
	WHEN dp.TypeProp = 'Date' AND val.value_precision is NULL THEN val.value
	WHEN dp.TypeProp = 'Date' AND val.value_precision is NOT NULL THEN val.value_precision
	ELSE NULL
	END as ValueDate,
Case 
	WHEN dp.TypeProp = 'Float' AND val.value_precision is NULL THEN val.value
	WHEN dp.TypeProp = 'Float' AND val.value_precision is NOT NULL THEN val.value_precision
	ELSE NULL
	END as ValueFloat,
dp.ID,
I_I.ID
FROM [ECWP-eReleveData].[dbo].[TObj_Carac_value] val 
JOIN [ECWP-eReleveData].[dbo].[TObj_Carac_type] typ on typ.Carac_type_Pk = val.Fk_carac
JOIN IndividualDynProp dp ON 'TCaracThes_'+dp.Name = typ.name or 'TCarac_'+dp.Name = typ.name or  'Thes_'+dp.Name = typ.name
JOIN Individual I_I ON  'eReleve_'+CONVERT(VARCHAR,val.fk_object) = I_I.Original_ID

