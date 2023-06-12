**********************************************************************************;
* adqs.sas                                                                       *;
*                                                                                *;
* Program to create ADQS (Questionnaire) ADaM BDS data set.                      *;
* One record per subject per question per visit.                                 *;
*                                                                                *;
* Input data sets: sdtm.qs, adam.adsl                                            *;
*                  metadata.source_columns, adam_cst.adqs                        *;
*                                                                                *;
* CSTversion  1.7.6                                                              *;
**********************************************************************************;

PROC SQL;
  CREATE TABLE adqs AS
    SELECT a.*
          ,a.trt01p AS trtp
          ,a.trt01pn AS trtpn
          ,INPUT(b.qsdtc, YYMMDD10.) AS adt
          ,b.qsdy AS ady
          ,b.visit AS avisit
          ,b.visitnum AS avisitn
          ,(CASE
            WHEN b.qstestcd = 'ACITM02' THEN 'NAMING OBJECTS AND FINGERS'
            WHEN b.qstestcd = 'ACITM13' THEN 'WORD FINDING DIFFICULTY IN SPONTANEOUS SPEECH'
            ELSE UPCASE(b.qstest)
            END) AS param
          ,(CASE
            WHEN SUBSTR(b.qstestcd, 1, 5) = 'NPITM' AND SCAN(UPCASE(b.qstest), -1) = 'SCORE' THEN STRIP(b.qstestcd) || 'N'
            WHEN SUBSTR(b.qstestcd, 1, 5) = 'NPITM' THEN STRIP(b.qstestcd) || SUBSTR(SCAN(UPCASE(b.qstest), -1), 1, 1)
            ELSE b.qstestcd
            END) AS paramcd
          ,(CASE
            WHEN b.qstestcd = 'ACTOT' THEN 99
            WHEN SUBSTR(b.qstestcd, 1, 2) = 'AC' THEN INPUT(SUBSTR(b.qstestcd, 6, 2), BEST.)
            WHEN b.qstestcd = 'CIBIC' THEN 100
            WHEN SUBSTR(b.qstestcd, 1, 2) = 'DA' THEN 200 + INPUT(SUBSTR(b.qstestcd, 6, 2), BEST.)
            WHEN b.qstestcd = 'NPTOT' THEN 399
            WHEN SUBSTR(b.qstestcd, 1, 2) = 'NP' THEN 300 + INPUT(SUBSTR(b.qstestcd, 6, 2), BEST.)
            END) AS paramn
          ,b.qsstresn AS aval
          ,b.qsseq
          ,b.qscat
          ,b.qsscat
          ,b.qsorres
          ,b.qsorresu
          ,b.qsstresc
          ,b.qsstresu
    FROM   adam.adsl AS a
    JOIN
           sdtm.qs AS b
    ON     a.studyid = b.studyid
      AND  a.usubjid = b.usubjid
    ORDER BY
           a.studyid
          ,a.usubjid
          ,CALCULATED paramcd
          ,CALCULATED adt
          ,b.qsseq
  ;
QUIT;

/* Assign variable attributes from metadata.source_columns */
FILENAME src CATALOG 'work.columns_adqs';

DATA _NULL_;
  SET metadata.source_columns;
  WHERE table = "ADQS";
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

DATA adam.adqs (
  %INCLUDE src(columns.source);
               );
  %INCLUDE src(attrib.source);
  SET adqs;
  BY studyid usubjid paramcd adt qsseq;
  %INCLUDE src(initial.source);
RUN;

/* Compare with ADQS in adam_cst */
PROC COMPARE BASE=adam_cst.adqs COMPARE=adam.adqs LISTALL BRIEFSUMMARY MAXPRINT=(5000, 100) METHOD=RELATIVE CRITERION=0.001;
  ID studyid usubjid paramcd adt qsseq;
RUN;
