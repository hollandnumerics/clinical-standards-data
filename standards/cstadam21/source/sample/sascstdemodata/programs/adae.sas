**********************************************************************************;
* adae.sas                                                                       *;
*                                                                                *;
* Program to create ADAE (Adverse Events) ADaM OCCDS data set.                   *;
* One record per subject per AE.                                                 *;
*                                                                                *;
* Input data sets: sdtm.ae, sdtm.ex, adam.adsl                                   *;
*                  metadata.source_columns, adam_cst.adae                        *;
*                                                                                *;
* CSTversion  1.7.6                                                              *;
**********************************************************************************;

PROC SORT DATA=sdtm.ex OUT=ex;
  BY studyid usubjid exstdtc exendtc;
RUN;

DATA ex;
  SET ex;
  BY studyid usubjid exstdtc exendtc;
  RETAIN cum_dose .;
  IF FIRST.usubjid THEN cum_dose=.;
  exdurn = (exendy - exstdy) + 1;
  SELECT (exdosfrq);
    WHEN ('BID') DO;
      total_dose = exdose * exdurn * 2;
    END;
    WHEN ('TID') DO;
      total_dose = exdose * exdurn * 3;
    END;
    WHEN ('QID') DO;
      total_dose = exdose * exdurn * 4;
    END;
    WHEN ('QD') DO;
      total_dose = exdose * exdurn;
    END;
    WHEN ('QN') DO;
      total_dose = exdose * exdurn;
    END;
    WHEN ('QOD') DO;
      total_dose = exdose * exdurn / 2;
    END;
    WHEN ('Q2D') DO;
      total_dose = exdose * exdurn / 2;
    END;
    WHEN ('Q3D') DO;
      total_dose = exdose * exdurn / 3;
    END;
    WHEN ('QW') DO;
      total_dose = exdose * exdurn / 7;
    END;
    WHEN ('Q2W') DO;
      total_dose = exdose * exdurn / 14;
    END;
    WHEN ('Q3W') DO;
      total_dose = exdose * exdurn / 21;
    END;
    OTHERWISE;
  END;
  cum_dose = SUM(cum_dose, total_dose);
  OUTPUT;
  IF LAST.USUBJID THEN DO;
    exendt = INPUT(exendtc, YYMMDD10.);
    exstdtc = PUT(exendt + 1, YYMMDDD10.);
    exendtc = PUT('31Dec9999'd, YYMMDDD10.);
    exstdy = exendy + 1;
    exendy = 9999;
    total_dose = 0;
    OUTPUT;
  END;
RUN;
    
PROC SQL;
  CREATE TABLE adae1 AS
    SELECT a.*
          ,b.age
          ,b.sex
          ,b.trt01p AS trtp
          ,b.trtedt
          ,b.trtsdt
          ,b.saffl
          ,b.trt01pn AS trtpn
          ,DHMS(INPUT(SCAN(a.aestdtc, 1, ':T'), YYMMDD10.), COALESCE(INPUT(SCAN(a.aestdtc, 2, ':T'), BEST.), 12), COALESCE(INPUT(SCAN(a.aestdtc, 3, ':T'), BEST.), 0), COALESCE(INPUT(SCAN(a.aestdtc, 4, ':T'), BEST.), 0)) AS astdtm
          ,(CASE
            WHEN NMISS(SCAN(a.aestdtc, 2, ':T'))=1 THEN 'H'
            WHEN NMISS(SCAN(a.aestdtc, 3, ':T'))=1 THEN 'M'
            WHEN NMISS(SCAN(a.aestdtc, 4, ':T'))=1 THEN 'S'
            ELSE ''
            END) AS asttmf LENGTH=1
          ,DHMS(INPUT(SCAN(a.aeendtc, 1, ':T'), YYMMDD10.), COALESCE(INPUT(SCAN(a.aeendtc, 2, ':T'), BEST.), 12), COALESCE(INPUT(SCAN(a.aeendtc, 3, ':T'), BEST.), 0), COALESCE(INPUT(SCAN(a.aeendtc, 4, ':T'), BEST.), 0)) AS aendtm
          ,(CASE
            WHEN NMISS(SCAN(a.aeendtc, 2, ':T'))=1 THEN 'H'
            WHEN NMISS(SCAN(a.aeendtc, 3, ':T'))=1 THEN 'M'
            WHEN NMISS(SCAN(a.aeendtc, 4, ':T'))=1 THEN 'S'
            ELSE ''
            END) AS aentmf LENGTH=1
          ,(DATEPART(CALCULATED astdtm) - b.trtsdt + 1) AS astdy
          ,(DATEPART(CALCULATED aendtm) - b.trtsdt + 1) AS aendy
          ,(DATEPART(CALCULATED aendtm) - DATEPART(CALCULATED astdtm) + 1) AS adurn
          ,(CASE
            WHEN CALCULATED adurn IS NOT MISSING THEN 'DAYS'
            ELSE ''
            END) AS aduru LENGTH=4            
          ,(CASE
            WHEN DATEPART(CALCULATED astdtm) GE b.trtsdt THEN 'Y'
            ELSE ''
            END) AS trtemfl LENGTH=1
          ,(CASE
            WHEN DATEPART(CALCULATED astdtm) GT b.trtedt THEN 'Y'
            ELSE ''
            END) AS fupfl LENGTH=1
          ,(CASE
            WHEN a.aesev='MILD' THEN 1
            WHEN a.aesev='MODERATE' THEN 2
            WHEN a.aesev='SEVERE' THEN 3
            WHEN a.aesev='FATAL' THEN 4
            ELSE .
            END) AS aesevn
          ,PROPCASE(a.aesev) AS ASEV
          ,(CASE
            WHEN a.aesev='MILD' THEN 1
            WHEN a.aesev='MODERATE' THEN 2
            WHEN a.aesev='SEVERE' THEN 3
            WHEN a.aesev='FATAL' THEN 4
            ELSE .
            END) AS asevn
          ,(CASE
            WHEN CALCULATED aesevn in (1 2) THEN 'Non-severe'
            WHEN CALCULATED aesevn in (3 4) THEN 'Severe'
            ELSE ''
            END) AS sevgr1 LENGTH=20
          ,(CASE
            WHEN CALCULATED aesevn in (1 2) THEN 1
            WHEN CALCULATED aesevn in (3 4) THEN 2
            ELSE .
            END) AS sevgr1n
           ,(CASE
            WHEN a.aerel='NOT RELATED' THEN 1
            WHEN a.aerel='LIKELY RELATED' THEN 2
            WHEN a.aerel='RELATED' THEN 3
            ELSE .
            END) AS aereln
          ,PROPCASE(a.aerel) AS AREL
           ,(CASE
            WHEN a.aerel='NOT RELATED' THEN 1
            WHEN a.aerel='LIKELY RELATED' THEN 2
            WHEN a.aerel='RELATED' THEN 3
            ELSE .
            END) AS areln
          ,INPUT(a.aetoxgr, BEST.) AS aetoxgrn
          ,(CASE
            WHEN a.aelltcd in (10012727 10012732 10024840 1005542) THEN 'Gastrointestinal nonspecific symptoms and therapeutic procedures (SMQ)'
            ELSE ''
            END) AS smq01nam LENGTH=200
          ,(CASE
            WHEN a.aelltcd in (10012727 10012732 10024840 1005542) THEN 20000140
            ELSE .
            END) AS smq01cd
          ,(CASE
            WHEN a.aelltcd in (10012727 10012732 10024840 1005542) THEN 'NARROW'
            ELSE ''
            END) AS smq01sc LENGTH=6
          ,(CASE
            WHEN a.aelltcd in (10012727 10012732 10024840 1005542) THEN 2
            ELSE .
            END) AS smq01scn
          ,(CASE
            WHEN a.aelltcd in (10037844 10037889) THEN 'Pruritic or NOS rashes (CQ)'
            ELSE ''
            END) AS cq01nam LENGTH=200
          ,c.exdose AS doseaeon
          ,c.exdosu AS dosaeonu
          ,c.exstdtc  /*debug*/
          ,c.exendtc  /*debug*/
          ,c.exstdy  /*debug*/
          ,c.exendy  /*debug*/
          ,c.exdurn  /*debug*/
          ,c.cum_dose  /*debug*/
          ,c.total_dose  /*debug*/
          ,(c.cum_dose - COALESCE(c.total_dose * (exendy - CALCULATED astdy) / exdurn, 0)) AS dosecum
          ,c.exdosu AS dosecumu
    FROM   sdtm.ae AS a
    JOIN
           adam.adsl AS b
    ON     a.studyid = b.studyid
      AND  a.usubjid = b.usubjid                 
    LEFT JOIN
           ex AS c
    ON     a.studyid = c.studyid
      AND  a.usubjid = c.usubjid
      AND  SUBSTR(a.aestdtc, 1, 10) GE SUBSTR(c.exstdtc, 1, 10)
      AND  SUBSTR(a.aestdtc, 1, 10) LE SUBSTR(c.exendtc, 1, 10) 
    ORDER BY
           a.studyid
          ,a.usubjid
          ,CALCULATED astdtm
          ,a.aeseq
          ,a.aedecod
  ;
QUIT;

PROC SORT DATA=adae1 OUT=aoccfl;
  BY studyid usubjid astdtm aeseq;
  WHERE trtemfl='Y' AND asevn > .;
RUN;

DATA aoccfl;
  SET aoccfl;  
  BY studyid usubjid;
  IF FIRST.usubjid;
  aoccfl = 'Y';
RUN;

PROC SORT DATA=aoccfl;
  BY studyid usubjid astdtm aeseq aedecod;
RUN;

PROC SORT DATA=adae1 OUT=aoccifl;
  BY studyid usubjid DESCENDING asevn astdtm aeseq;
  WHERE trtemfl='Y' AND asevn > .;
RUN;

DATA aoccifl;
  SET aoccifl;  
  BY studyid usubjid;
  IF FIRST.usubjid;
  aoccifl = 'Y';
RUN;
  
PROC SORT DATA=aoccifl;
  BY studyid usubjid astdtm aeseq aedecod;
RUN;

/* Assign variable attributes from metadata.source_columns */
FILENAME src CATALOG 'work.columns_adae';

DATA _NULL_;
  SET metadata.source_columns;
  WHERE table = "ADAE";
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

DATA adam.adae (
  %INCLUDE src(columns.source);
               );
  %INCLUDE src(attrib.source);
  MERGE adae1
        aoccfl
        aoccifl
        ;
  BY studyid usubjid astdtm aeseq aedecod;
  %INCLUDE src(initial.source);
RUN;

/* Compare with ADAE in adam_cst */
PROC COMPARE BASE=adam_cst.adae COMPARE=adam.adae LISTALL BRIEFSUMMARY MAXPRINT=(5000, 100) METHOD=RELATIVE CRITERION=0.001;
  ID studyid usubjid aedecod aestdtc aeendtc;
RUN;
