**********************************************************************************;
* adsl.sas                                                                       *;
*                                                                                *;
* Program to create ADSL (Subject Level) ADaM ADSL data set.                     *;
* One record per subject.                                                        *;
*                                                                                *;
* Input data sets: sdtm.ds, sdtm.sv, sdtm.ex, sdtm.dm                            *;
*                  metadata.source_columns, adam_cst.adsl                        *;
*                                                                                *;
* CSTversion  1.7.6                                                              *;
**********************************************************************************;

DATA dsdecod;
  SET sdtm.ds;
  WHERE dscat = 'DISPOSITION EVENT';
  compdt = INPUT(dsstdtc, YYMMDD10.);
RUN;

DATA randdt;
  SET sdtm.ds;
  WHERE dscat = 'PROTOCOL MILESTONE' AND dsdecod = 'RANDOMIZED';
  randdt = INPUT(dsstdtc, YYMMDD10.);
RUN;

DATA visit1dt;
  SET sdtm.sv;
  WHERE visitnum = 1;
  visit1dt = INPUT(svstdtc, YYMMDD10.);
RUN;

PROC SORT DATA=sdtm.ex OUT=exst;
  BY studyid usubjid exstdtc;
RUN;

DATA exstdt;
  SET exst;
  BY studyid usubjid exstdtc;
  IF FIRST.usubjid;
  exstdt = INPUT(exstdtc, YYMMDD10.);
RUN;

PROC SORT DATA=sdtm.ex OUT=exen;
  BY studyid usubjid exendtc;
RUN;

DATA exendt;
  SET exen;
  BY studyid usubjid exendtc;
  IF LAST.usubjid;
  exendt = INPUT(exendtc, YYMMDD10.);
RUN;

DATA complt2;
  SET sdtm.sv;
  WHERE visitnum = 2;
  compdt = INPUT(svstdtc, YYMMDD10.);
RUN;

DATA complt4;
  SET sdtm.sv;
  WHERE visitnum = 3;
  compdt = INPUT(svstdtc, YYMMDD10.);
RUN;

DATA complt6;
  SET sdtm.sv;
  WHERE visitnum = 4;
  compdt = INPUT(svstdtc, YYMMDD10.);
RUN;

PROC SQL;
  CREATE TABLE adsl AS
    SELECT a.*
          ,a.arm AS trt01p
          ,(CASE
            WHEN a.armcd = 'A' THEN 1
            WHEN a.armcd = 'B' THEN 2
            WHEN a.armcd = 'C' THEN 3
            ELSE .
            END) AS trt01pn
          ,(CASE
            WHEN 0 LE a.age LT 65 THEN '<65'
            WHEN 65 LE a.age LE 80 THEN '65-80'
            WHEN 80 LT a.age THEN '>80'
            ELSE ' '
            END) AS agegr1 LENGTH=5
          ,(CASE
            WHEN 0 LE a.age LT 65 THEN 1
            WHEN 65 LE a.age LE 80 THEN 2
            WHEN 80 LT a.age THEN 3
            ELSE .
            END) AS agegr1n
          ,(CASE
            WHEN a.armcd NE ' ' THEN 'Y'
            ELSE 'N'
            END) AS ittfl
          ,b.dsdecod
          ,c.randdt FORMAT=DATE11.
          ,d.visit1dt FORMAT=DATE11.
          ,e.exstdt AS trtsdt FORMAT=DATE11.
          ,(CASE
            WHEN CALCULATED ittfl = 'Y' AND e.exstdt IS NOT MISSING THEN 'Y'
            ELSE 'N'
            END) AS saffl
          ,(CASE
            WHEN CALCULATED saffl = 'Y' AND e.exdose IS NOT MISSING THEN 'Y'
            ELSE 'N'
            END) AS fasfl
          ,(CASE
            WHEN h.compdt IS MISSING THEN f.exendt
            ELSE COALESCE(f.exendt, b.compdt)
            END) AS trtedt FORMAT=DATE11.
          ,(CALCULATED trtedt - e.exstdt + 1) AS trtdurd
          ,(CASE
            WHEN g.compdt IS MISSING THEN 'N'
            WHEN CALCULATED trtedt IS MISSING THEN 'Y'
            WHEN g.compdt LE CALCULATED trtedt THEN 'Y'
            ELSE 'N'
            END) AS complt2
          ,(CASE
            WHEN h.compdt IS MISSING THEN 'N'
            WHEN CALCULATED trtedt IS MISSING THEN 'Y'
            WHEN h.compdt LE CALCULATED trtedt THEN 'Y'
            ELSE 'N'
            END) AS complt4
          ,(CASE
            WHEN i.compdt IS MISSING THEN 'N'
            WHEN CALCULATED trtedt IS MISSING THEN 'Y'
            WHEN i.compdt LE CALCULATED trtedt THEN 'Y'
            ELSE 'N'
            END) AS complt6
    FROM   sdtm.dm AS a
    LEFT JOIN
           dsdecod AS b
    ON     a.studyid = b.studyid
      AND  a.usubjid = b.usubjid
    LEFT JOIN
           randdt AS c
    ON     a.studyid = c.studyid
      AND  a.usubjid = c.usubjid
    LEFT JOIN
           visit1dt AS d
    ON     a.studyid = d.studyid
      AND  a.usubjid = d.usubjid
    LEFT JOIN
           exstdt AS e
    ON     a.studyid = e.studyid
      AND  a.usubjid = e.usubjid
    LEFT JOIN
           exendt AS f
    ON     a.studyid = f.studyid
      AND  a.usubjid = f.usubjid
    LEFT JOIN
           complt2 AS g
    ON     a.studyid = g.studyid
      AND  a.usubjid = g.usubjid
    LEFT JOIN
           complt4 AS h
    ON     a.studyid = h.studyid
      AND  a.usubjid = h.usubjid
    LEFT JOIN
           complt6 AS i
    ON     a.studyid = i.studyid
      AND  a.usubjid = i.usubjid
    ORDER BY
           a.studyid
          ,a.usubjid         
  ;
QUIT;

/* Assign variable attributes from metadata.source_columns */
FILENAME src CATALOG 'work.columns_adsl';

DATA _NULL_;
  SET metadata.source_columns;
  WHERE table = "ADSL";
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

DATA adam.adsl (
  %INCLUDE src(columns.source);
               );
  %INCLUDE src(attrib.source);
  SET adsl;
  %INCLUDE src(initial.source);
RUN;

/* Compare with ADSL in adam_cst */
PROC COMPARE BASE=adam_cst.adsl COMPARE=adam.adsl LISTALL BRIEFSUMMARY MAXPRINT=(5000, 100) METHOD=RELATIVE CRITERION=0.001;
  ID studyid usubjid;
RUN;
