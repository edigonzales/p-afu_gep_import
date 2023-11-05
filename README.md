# p-afu_gep_import

Edit:

```
java -jar /Users/stefan/apps/ili2pg-4.9.1/ili2pg-4.9.1.jar --dbhost localhost --dbport 54321 --dbdatabase edit --dbusr ddluser --dbpwd ddluser --defaultSrsCode 2056 --createGeomIdx  --createFk --createFkIdx --createEnumTabs --createMetaInfo --nameByTopic --strokeArcs --createBasketCol --createDatasetCol --createUnique --createNumChecks --createTextChecks --createDateTimeChecks --createImportTabs --dbschema afu_gep_v1 --models "SIA405_Base_Abwasser_LV95;VSADSSMINI_2020_LV95" --schemaimport
```


```
java -jar /Users/stefan/apps/ili2pg-4.9.1/ili2pg-4.9.1.jar --dbhost localhost --dbport 54321 --dbdatabase edit --dbusr ddluser --dbpwd ddluser --dbschema afu_gep_v1 --models "SIA405_Base_Abwasser_LV95" --disableValidation --defaultSrsCode 2056 --dataset organisation --importBid --import data/vsa_organisationen.xtf
```


```
java -jar /Users/stefan/apps/ili2pg-4.9.1/ili2pg-4.9.1.jar --dbhost localhost --dbport 54321 --dbdatabase edit --dbusr ddluser --dbpwd ddluser --dbschema afu_gep_v1 --models "VSADSSMINI_2020_LV95" --disableValidation --defaultSrsCode 2056 --dataset 2471_gep --import data/2471_gep.xtf
```

Pub:

```
java -jar /Users/stefan/apps/ili2pg-4.9.1/ili2pg-4.9.1.jar --dbhost localhost --dbport 54322 --dbdatabase pub --dbusr ddluser --dbpwd ddluser --defaultSrsCode 2056 --createGeomIdx  --createFk --createFkIdx --createEnumTabs --createMetaInfo --nameByTopic --strokeArcs --createUnique --createNumChecks --createTextChecks --createDateTimeChecks --createImportTabs --dbschema afu_gep_werkkataster_v1 --models "SO_AFU_VSADSSMINI_WK_Publikation_20231027" --modeldir "ili;https://models.interlis.ch" --schemaimport
```