**********************************************************************************;
* adtte.sas                                                                      *;
*                                                                                *;
* Program to create ADTTE (Time-to-Event) ADaM BDS data set.                     *;
* One record per subject per event.                                              *;
*                                                                                *;
* Input data sets: sdtm.ds, sdtm.sv, adam.adsl                                   *;
*                  metadata.source_columns, metadata.source_tables               *;
*                  adam_cst.adtte                                                *;
*                                                                                *;
* CSTversion  1.7.6                                                              *;
**********************************************************************************;

DATA ds;
  SET sdtm.ds;
  WHERE dscat = 'DISPOSITION EVENT';
RUN;

PROC SQL;
  CREATE TABLE adtte1 AS
    SELECT a.*
          ,INPUT(b.dsstdtc, YYMMDD10.) AS adt
          ,a.trt01p AS trtp
          ,a.trt01pn AS trtpn
          ,c.visit AS avisit
          ,'Successful study completion' AS param
          ,'STDYCOMP' AS paramcd
          ,(CALCULATED adt - a.trtsdt + 1) AS aval
          ,a.trtsdt AS startdt
          ,(CASE
            WHEN b.dsdecod = 'COMPLETED' THEN 0
            WHEN b.dsdecod = 'LOST TO FOLLOW UP' THEN 1
            WHEN b.dsdecod = 'PHYSICIAN DECISION' THEN 2
            ELSE .
            END) AS cnsr
          ,b.dsdecod AS evntdesc
          ,'DS' AS srcdom
          ,'DSDECOD' AS srcvar
          ,b.dsseq AS srcseq
    FROM   adam.adsl AS a
    LEFT JOIN
           ds AS b
    ON     a.studyid = b.studyid
      AND  a.usubjid = b.usubjid
    LEFT JOIN
           sdtm.sv AS c
    ON     a.studyid = c.studyid
      AND  a.usubjid = c.usubjid
      AND  b.dsstdtc GE SUBSTR(c.svstdtc, 1, 10)
      AND  b.dsstdtc LE SUBSTR(c.svendtc, 1, 10)
    ORDER BY
           a.studyid
          ,a.usubjid
          ,CALCULATED paramcd
  ;
QUIT;

/* Assign variable attributes from metadata.source_columns */
FILENAME src CATALOG 'work.columns_adtte';

DATA _NULL_;
  SET metadata.source_columns;
  WHERE table = "ADTTE";
  LENGTH _label _format _length $200;
  FILE src(columns.source);
  IF _N_ = 1 THEN PUT "KEEP=" column;
  ELSE PUT " " column;
  FILE src(attrib.source);
  _label = STRIP(label);
  _format = STRIP(displayformat);
  _length = STRIP(PUT(length, 8.));
  PUT "ATTRIB " column;
  IF CMISS(_label) = 0 THEN PUT " LABEL='" _label +(-1) "'";
  IF CMISS(_format) = 0 THEN PUT " FORMAT=" _format;
  IF type = "C" AND NMISS(length) = 0 THEN PUT " LENGTH=$" _length;
  PUT " ;";
  FILE src(initial.source);
  PUT column "= " column ";";
RUN;

DATA _NULL_;
  SET metadata.source_tables;
  WHERE table = "ADTTE";
  LENGTH _label $200;
  FILE src(dslabel.source);
  _label = STRIP(label);
  PUT " (DESCRIPTION='" _label +(-1) "');";
  FILE src(sort.source);
  PUT keys ";";
RUN;

DATA adtte2 (
  %INCLUDE src(columns.source);
               );
  %INCLUDE src(attrib.source);
  SET adtte1;
  BY studyid usubjid paramcd;
  %INCLUDE src(initial.source);
RUN;

PROC SORT DATA = adtte2 OUT = adam.adtte %INCLUDE src(dslabel.source);;
  BY %INCLUDE src(sort.source);
RUN;

/* Compare with ADTTE in adam_cst */
PROC COMPARE BASE=adam_cst.adtte COMPARE=adam.adtte LISTALL BRIEFSUMMARY MAXPRINT=(5000, 100) METHOD=RELATIVE CRITERION=0.001;
  ID  %INCLUDE src(sort.source);
RUN;
