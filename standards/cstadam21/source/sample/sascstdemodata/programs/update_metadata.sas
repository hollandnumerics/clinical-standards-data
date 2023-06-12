LIBNAME meta_2_1 "!cstsamplelib./cdisc-adam-2.1-1.7/sascstdemodata/metadata/" access=readonly;

DATA metadata.source_columns;
  ATTRIB origin LENGTH=$40 LABEL="Column Origin";
  ATTRIB origindescription LENGTH=$1000 LABEL="Column Origin Description";
  ATTRIB algorithm LENGTH=$1000 LABEL="Computational Algorithm or Method";
  SET meta_2_1.source_columns;
  SELECT;
    WHEN (table='ADSL' AND column='STUDYID') DO;
      origin = "Predecessor";
      origindescription = "DM.STUDYID";
      algorithm = "";
    END;
    WHEN (column='STUDYID') DO;
      origin = "Predecessor";
      origindescription = "ADSL.STUDYID";
      algorithm = "";
    END;
    WHEN (table='ADSL' AND column='USUBJID') DO;
      origin = "Predecessor";
      origindescription = "DM.USUBJID";
      algorithm = "";
    END;
    WHEN (column='USUBJID') DO;
      origin = "Predecessor";
      origindescription = "ADSL.USUBJID";
      algorithm = "";
    END;
    WHEN (table='ADSL' AND column='SUBJID') DO;
      origin = "Predecessor";
      origindescription = "DM.SUBJID";
      algorithm = "";
    END;
    WHEN (column='SUBJID') DO;
      origin = "Predecessor";
      origindescription = "ADSL.SUBJID";
      algorithm = "";
    END;
    WHEN (table='ADSL' AND column='RFSTDTC') DO;
      origin = "Predecessor";
      origindescription = "DM.RFSTDTC";
      algorithm = "";
    END;
    WHEN (column='RFSTDTC') DO;
      origin = "Predecessor";
      origindescription = "ADSL.RFSTDTC";
      algorithm = "";
    END;
    WHEN (table='ADSL' AND column='RFENDTC') DO;
      origin = "Predecessor";
      origindescription = "DM.RFENDTC";
      algorithm = "";
    END;
    WHEN (column='RFENDTC') DO;
      origin = "Predecessor";
      origindescription = "ADSL.RFENDTC";
      algorithm = "";
    END;
    WHEN (table='ADSL' AND column='SITEID') DO;
      origin = "Predecessor";
      origindescription = "DM.SITEID";
      algorithm = "";
    END;
    WHEN (column='SITEID') DO;
      origin = "Predecessor";
      origindescription = "ADSL.SITEID";
      algorithm = "";
    END;
    WHEN (table='ADSL' AND column='AGE') DO;
      origin = "Predecessor";
      origindescription = "DM.AGE";
      algorithm = "";
    END;
    WHEN (column='AGE') DO;
      origin = "Predecessor";
      origindescription = "ADSL.AGE";
      algorithm = "";
    END;
    WHEN (table='ADSL' AND column='AGEU') DO;
      origin = "Predecessor";
      origindescription = "DM.AGEU";
      algorithm = "";
    END;
    WHEN (column='AGEU') DO;
      origin = "Predecessor";
      origindescription = "ADSL.AGEU";
      algorithm = "";
    END;
    WHEN (table='ADSL' AND column='SEX') DO;
      origin = "Predecessor";
      origindescription = "DM.SEX";
      algorithm = "";
    END;
    WHEN (column='SEX') DO;
      origin = "Predecessor";
      origindescription = "ADSL.SEX";
      algorithm = "";
    END;
    WHEN (table='ADSL' AND column='RACE') DO;
      origin = "Predecessor";
      origindescription = "DM.RACE";
      algorithm = "";
    END;
    WHEN (column='RACE') DO;
      origin = "Predecessor";
      origindescription = "ADSL.RACE";
      algorithm = "";
    END;
    WHEN (table='ADSL' AND column='ARMCD') DO;
      origin = "Predecessor";
      origindescription = "DM.ARMCD";
      algorithm = "";
    END;
    WHEN (column='ARMCD') DO;
      origin = "Predecessor";
      origindescription = "ADSL.ARMCD";
      algorithm = "";
    END;
    WHEN (table='ADSL' AND column='ARM') DO;
      origin = "Predecessor";
      origindescription = "DM.ARM";
      algorithm = "";
    END;
    WHEN (column='ARM') DO;
      origin = "Predecessor";
      origindescription = "ADSL.ARM";
      algorithm = "";
    END;
    WHEN (table='ADSL' AND column='VISIT1DT') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "SV.SVSTDTC when SV.VISITNUM=1, converted to SAS date";
    END;
    WHEN (table='ADSL' AND column='RANDDT') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "DS.DSSTDTC where DSCAT='PROTOCOL MILESTONE' and DSDECOD='RANDOMIZED', converted to SAS date";
    END;
    WHEN (table='ADSL' AND column='COMPLT2') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "Y if subject has a SV.VISITNUM=2 and TRTEDT>= date of visit 2, N otherwise";
    END;
    WHEN (table='ADSL' AND column='COMPLT4') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "Y if subject has a SV.VISITNUM=3 and TRTEDT>= date of visit 3, N otherwise";
    END;
    WHEN (table='ADSL' AND column='COMPLT6') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "Y if subject has a SV.VISITNUM=4 and TRTEDT>= date of visit 4, N otherwise";
    END;
    WHEN (table='ADSL' AND column='TRTEDT') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "The date of final dose (from the CRF) is EX.EXENDTC on the subject's last EX record. If the date of final dose is missing for the subject and the subject discontinued after visit 3, use the date of discontinuation as the date of last dose. Convert the date to a SAS date.";
    END;
    WHEN (column='TRTEDT') DO;
      origin = "Predecessor";
      origindescription = "ADSL.TRTEDT";
      algorithm = "";
    END;
    WHEN (table='ADSL' AND column='TRTSDT') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "First EX.EXSTDTC, converted to SAS date";
    END;
    WHEN (column='TRTSDT') DO;
      origin = "Predecessor";
      origindescription = "ADSL.TRTSDT";
      algorithm = "";
    END;
    WHEN (table='ADSL' AND column='DSDECOD') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "DS.DSDECOD where DSCAT='DISPOSITION EVENT'";
    END;
    WHEN (table='ADSL' AND column='FASFL') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "Y if SAFFL='Y' and first EX.EXDOSE ne missing. N otherwise";
    END;
    WHEN (column='FASFL') DO;
      origin = "Predecessor";
      origindescription = "ADSL.FASFL";
      algorithm = "";
    END;
    WHEN (table='ADSL' AND column='ITTFL') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "Y if ARMCD ne ' '. N otherwise";
    END;
    WHEN (column='ITTFL') DO;
      origin = "Predecessor";
      origindescription = "ADSL.ITTFL";
      algorithm = "";
    END;
    WHEN (table='ADSL' AND column='SAFFL') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "Y if ITTFL='Y' and TRTSDT ne missing. N otherwise";
    END;
    WHEN (column='SAFFL') DO;
      origin = "Predecessor";
      origindescription = "ADSL.SAFFL";
      algorithm = "";
    END;
    WHEN (table='ADSL' AND column='TRT01P') DO;
      origin = "Predecessor";
      origindescription = "DM.ARM";
      algorithm = "";
    END;
    WHEN (table='ADSL' AND column='TRT01PN') DO;
      origin = "Assigned";
      origindescription = "";
      algorithm = "1 if ARMCD='A'. 2 if ARMCD='B'. 3 if ARMCD='C'. Missing otherwise";
    END;      
    WHEN (column='TRTP') DO;
      origin = "Predecessor";
      origindescription = "ADSL.TRT01P";
      algorithm = "";
    END;
    WHEN (table='ADSL' AND column='TRT01PN') DO;
      origin = "Assigned";
      origindescription = "";
      algorithm = "1 if ARMCD='A'. 2 if ARMCD='B'. 3 if ARMCD='C'. Missing otherwise";
    END;      
    WHEN (column='TRTPN') DO;
      origin = "Predecessor";
      origindescription = "ADSL.TRT01PN";
      algorithm = "";
    END;
    WHEN (table='ADAE' AND column='AESEQ') DO;
      origin = "Predecessor";
      origindescription = "AE.AESEQ";
      algorithm = "";
    END;
    WHEN (table='ADAE' AND column='AETERM') DO;
      origin = "Predecessor";
      origindescription = "AE.AETERM";
      algorithm = "";
    END;
    WHEN (table='ADAE' AND column='AEDECOD') DO;
      origin = "Predecessor";
      origindescription = "AE.AEDECOD";
      algorithm = "";
    END;
    WHEN (table='ADAE' AND column='AEBODSYS') DO;
      origin = "Predecessor";
      origindescription = "AE.AEBODSYS";
      algorithm = "";
    END;
    WHEN (table='ADAE' AND column='AEBDSYCD') DO;
      origin = "Predecessor";
      origindescription = "AE.AEBDSYCD";
      algorithm = "";
    END;
    WHEN (table='ADAE' AND column='AELLT') DO;
      origin = "Predecessor";
      origindescription = "AE.AELLT";
      algorithm = "";
    END;
    WHEN (table='ADAE' AND column='AELLTCD') DO;
      origin = "Predecessor";
      origindescription = "AE.AELLTCD";
      algorithm = "";
    END;
    WHEN (table='ADAE' AND column='AEPTCD') DO;
      origin = "Predecessor";
      origindescription = "AE.AEPTCD";
      algorithm = "";
    END;
    WHEN (table='ADAE' AND column='AEHLT') DO;
      origin = "Predecessor";
      origindescription = "AE.AEHLT";
      algorithm = "";
    END;
    WHEN (table='ADAE' AND column='AEHLTCD') DO;
      origin = "Predecessor";
      origindescription = "AE.AEHLTCD";
      algorithm = "";
    END;
    WHEN (table='ADAE' AND column='AEHLGT') DO;
      origin = "Predecessor";
      origindescription = "AE.AE.AEHLGT";
      algorithm = "";
    END;
    WHEN (table='ADAE' AND column='AEHLGTCD') DO;
      origin = "Predecessor";
      origindescription = "AE.AEHLGTCD";
      algorithm = "";
    END;
    WHEN (table='ADAE' AND column='AESOC') DO;
      origin = "Predecessor";
      origindescription = "AE.AESOC";
      algorithm = "";
    END;
    WHEN (table='ADAE' AND column='AESOCCD') DO;
      origin = "Predecessor";
      origindescription = "AE.AESOCCD";
      algorithm = "";
    END;
    WHEN (table='ADAE' AND column='AESTDTC') DO;
      origin = "Predecessor";
      origindescription = "AE.AESTDTC";
      algorithm = "";
    END;
    WHEN (table='ADAE' AND column='ASTDTM') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "AESTDTC, converted to SAS date/time. Missing hours imputed to 12. Missing minutes imputed to 0. Missing seconds imputed to 0";
    END;
    WHEN (table='ADAE' AND column='ASTTMF') DO;
      origin = "Derived";
      origindescription = "'H' if hours imputed in ASTDTM. Else 'M' if minutes imputed in ASTDTM. Else 'S' if seconds imputed in ASTDTM. Missing otherwise";
      algorithm = "";
    END;
    WHEN (table='ADAE' AND column='AEENDTC') DO;
      origin = "Predecessor";
      origindescription = "AE.AEENDTC";
      algorithm = "";
    END;
    WHEN (table='ADAE' AND column='AENDTM') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "AEENDTC, converted to SAS date/time. Missing hours imputed to 12. Missing minutes imputed to 0. Missing seconds imputed to 0";
    END;
    WHEN (table='ADAE' AND column='AENTMF') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "'H' if hours imputed in AENDTM. Else 'M' if minutes imputed in AENDTM. Else 'S' if seconds imputed in AENDTM. Missing otherwise";
    END;
    WHEN (table='ADAE' AND column='ASTDY') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "Date part of ASTDTM - TRTSDT + 1";
    END;
    WHEN (table='ADAE' AND column='AENDY') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "Date part of AENDTM - TRTSDT + 1";
    END;
    WHEN (table='ADAE' AND column='ADURN') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "Date part of AENDTM - Date part of ASTDTM + 1";
    END;
    WHEN (table='ADAE' AND column='ADURU') DO;
      origin = "Assigned";
      origindescription = "";
      algorithm = "'DAYS' if ADURN is not missing. Missing otherwise";
    END;
    WHEN (table='ADAE' AND column='AEDUR') DO;
      origin = "Predecessor";
      origindescription = "AE.AEDUR";
      algorithm = "";
    END;
    WHEN (table='ADAE' AND column='TRTEMFL') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "'Y' if date part of ASTDTM >= TRTSDT. Missing otherwise";
    END;
    WHEN (table='ADAE' AND column='FUPFL') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "'Y' if date part of ASTDTM > TRTEDT. Missing otherwise";
    END;
    WHEN (table='ADAE' AND column='AOCCFL') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "Subset to TRTEMFL='Y' and sort by Subject (USUBJID), Date/Time (ASTDTM), and Sequence Number (AESEQ) and flag the first record (set AOCCFL='Y') within each Subject. Missing otherwise";
    END;
    WHEN (table='ADAE' AND column='AOCCIFL') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "Subset to TRTEMFL='Y' and sort by Subject (USUBJID), Date/Time (ASTDTM), and Sequence Number (AESEQ) and flag the first record (set AOCCIFL='Y') with the highest ASEVN within each Subject. Missing otherwise";
    END;
    WHEN (table='ADAE' AND column='DOSEAEON') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "EX.EXDOSE where AE.AESTDTC >= EX.EXSTDTC and AE.AESTDTC <= EX.EXENDTC. Missing otherwise";
    END;
    WHEN (table='ADAE' AND column='DOSAEONU') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "EX.EXDOSU where AE.AESTDTC >= EX.EXSTDTC and AE.AESTDTC <= EX.EXENDTC. Missing otherwise";
    END;
    WHEN (table='ADAE' AND column='DOSECUM') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "Sum of EX.EXDOSE * EX.EXDUR (converted to numeric value) * EX.EXDOSFRQ multiplier (BID = x2) from first dose up to, and including, AE.AESTDTC. Missing otherwise";
    END;
    WHEN (table='ADAE' AND column='DOSECUMU') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "EX.EXDOSU where AE.AESTDTC >= EX.EXSTDTC and AE.AESTDTC <= EX.EXENDTC. Missing otherwise";
    END;
    WHEN (table='ADAE' AND column='AESER') DO;
      origin = "Predecessor";
      origindescription = "AE.AESER";
      algorithm = "";
    END;
    WHEN (table='ADAE' AND column='AESEV') DO;
      origin = "Predecessor";
      origindescription = "AE.AESEV";
      algorithm = "";
    END;
    WHEN (table='ADAE' AND column='AESEVN') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "1 if AESEV='MILD'. 2 if AESEV='MODERATE'. 3 if AESEV='SEVERE'. 4 if AESEV='FATAL'. Missing otherwise";
    END;
    WHEN (table='ADAE' AND column='ASEV') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "Convert AESEV to proper-case";
    END;
    WHEN (table='ADAE' AND column='ASEVN') DO;
      origin = "Derived";
      origindescription = "1 if AESEV='MILD'. 2 if AESEV='MODERATE'. 3 if AESEV='SEVERE'. 4 if AESEV='FATAL'. Missing otherwise";
      algorithm = "";
    END;
    WHEN (table='ADAE' AND column='SEVGR1') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "'Non-severe' if ASEVN=1 or 2. 'Severe' if ASEVN=3 or 4. Missing otherwise";
    END;
    WHEN (table='ADAE' AND column='SEVGR1N') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "1 if ASEVN=1 or 2. 2 if ASEVN=3 or 4. Missing otherwise";
    END;
    WHEN (table='ADAE' AND column='AEREL') DO;
      origin = "Predecessor";
      origindescription = "AE.AEREL";
      algorithm = "";
    END;
    WHEN (table='ADAE' AND column='AERELN') DO;
      origin = "Derived";
      origindescription = "1 if AEREL='NOT RELATED'. 2 if AEREL='LIKELY RELATED'. 3 if AEREL='RELATED'. Missing otherwise";
      algorithm = "";
    END;
    WHEN (table='ADAE' AND column='AREL') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "Convert AEREL to proper-case";
    END;
    WHEN (table='ADAE' AND column='ARELN') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "1 if AEREL='NOT RELATED'. 2 if AEREL='LIKELY RELATED'. 3 if AEREL='RELATED'. Missing otherwise";
    END;
    WHEN (table='ADAE' AND column='AETOXGR') DO;
      origin = "Predecessor";
      origindescription = "AE.AETOXGR";
      algorithm = "";
    END;
    WHEN (table='ADAE' AND column='AETOXGRN') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "Convert AETOXGR to numeric value";
    END;
    WHEN (table='ADAE' AND column='AEACN') DO;
      origin = "Predecessor";
      origindescription = "AE.AEACN";
      algorithm = "";
    END;
    WHEN (table='ADAE' AND column='SMQ01NAM') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "'Gastrointestinal nonspecific symptoms and therapeutic procedures (SMQ)' if AELLTCD in (10012727 10012732 10024840 10055420). Missing otherwise";
    END;
    WHEN (table='ADAE' AND column='SMQ01CD') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "20000140 if AELLTCD in (10012727 10012732 10024840 10055420). Missing otherwise";
    END;
    WHEN (table='ADAE' AND column='SMQ01SC') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "'NARROW' if AELLTCD in (10012727 10012732 10024840 10055420). Missing otherwise";
    END;
    WHEN (table='ADAE' AND column='SMQ01SCN') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "2 if AELLTCD in (10012727 10012732 10024840 10055420). Missing otherwise";
    END;
    WHEN (table='ADAE' AND column='CQ01NAM') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "'Pruritic or NOS rashes (CQ)' if AELLTCD in (10037844 10037889). Missing otherwise";
    END;
    WHEN (table='ADTTE' AND column='ADT') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "DS.DSSTDTC converted to a SAS date if DS.DSCAT='DISPOSITION EVENT'. Missing otherwise";
    END;
    WHEN (table='ADTTE' AND column='AVISIT') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "SV.VISIT if DS.DSSTDTC >= 1st 10 characters of SV.SVSTDTC and DS.DSSTDTC <= 1st 10 characters of SV.SVENDTC. Missing otherwise";
    END;
    WHEN (table='ADTTE' AND column='PARAM') DO;
      origin = "Assigned";
      origindescription = "";
      algorithm = "'Successful study completion'";
    END;
    WHEN (table='ADTTE' AND column='PARAMCD') DO;
      origin = "Assigned";
      origindescription = "";
      algorithm = "'STDYCOMP'";
    END;
    WHEN (table='ADTTE' AND column='AVAL') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "DS.DSSTDTC converted to a SAS date - TRTSDT + 1 if DS.DSCAT='DISPOSITION EVENT'. Missing otherwise";
    END;
    WHEN (table='ADTTE' AND column='STARTDT') DO;
      origin = "Predecessor";
      origindescription = "ADSL.TRTSDT";
      algorithm = "";
    END;
    WHEN (table='ADTTE' AND column='CNSR') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "0 if DS.DSDECOD='COMPLETED' and DS.DSCAT='DISPOSITION EVENT'. 1 if DS.DSDECOD='LOST TO FOLLOW UP' and DS.DSCAT='DISPOSITION EVENT'. 2 if DS.DSDECOD='PHYSICIAN DECISION' and DS.DSCAT='DISPOSITION EVENT'. Missing otherwise";
    END;
    WHEN (table='ADTTE' AND column='EVNTDESC') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "DS.DSDECOD if DS.DSCAT='DISPOSITION EVENT'. Missing otherwise";
    END;
    WHEN (table='ADTTE' AND column='SRCDOM') DO;
      origin = "Assigned";
      origindescription = "";
      algorithm = "'DS'";
    END;
    WHEN (table='ADTTE' AND column='SRCVAR') DO;
      origin = "Assigned";
      origindescription = "";
      algorithm = "'DSDECOD'";
    END;
    WHEN (table='ADTTE' AND column='SRCSEQ') DO;
      origin = "Predecessor";
      origindescription = "DS.DSSEQ";
      algorithm = "";
    END;
    WHEN (table='ADQS' AND column='ADT') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "Convert QS.QSDTC to SAS date";
    END;
    WHEN (table='ADQS' AND column='ADY') DO;
      origin = "Predecessor";
      origindescription = "QS.QSDY";
      algorithm = "";
    END;
    WHEN (table='ADQS' AND column='AVISIT') DO;
      origin = "Predecessor";
      origindescription = "QS.VISIT";
      algorithm = "";
    END;
    WHEN (table='ADQS' AND column='AVISITN') DO;
      origin = "Predecessor";
      origindescription = "QS.VISITNUM";
      algorithm = "";
    END;
    WHEN (table='ADQS' AND column='PARAM') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "'NAMING OBJECTS AND FINGERS' if QS.QSTESTCD='ACITM02'. 'WORD FINDING DIFFICULTY IN SPONTANEOUS SPEECH' if QS.QSTESTCD='ACITM13'. Upper-case QS.QSTEST otherwise";
    END;
    WHEN (table='ADQS' AND column='PARAMCD') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "QS.QSTESTCD + 'N' if QS.QSTESTCD begins with 'NPITM' and upper-case QS.QSTEST ends in 'SCORE'. QS.QSTESTCD + 1st character of last word in upper-case QS.QSTEST if QS.QSTESTCD begins with 'NPITM'. QS.QSTESTCD otherwise";
    END;
    WHEN (table='ADQS' AND column='PARAMN') DO;
      origin = "Derived";
      origindescription = "";
      algorithm = "99 if QS.QSTESTCD='ACTOT'. 100 if QS.QSTESTCD='CIBIC'. 299 if QS.QSTESTCD='NPTOT'. Numeric value of last 2 digits if QS.QSTESTCD begins with 'AC'. Numeric value of last 2 digits + 200 if QS.QSTESTCD begins with 'DA'. 300 + numeric value of last 2 digits if QS.QSTESTCD begins with 'NP'. Missing otherwise";
    END;
    WHEN (table='ADQS' AND column='AVAL') DO;
      origin = "Predecessor";
      origindescription = "QS.QSSTRESN";
      algorithm = "";
    END;
    WHEN (table='ADQS' AND column='QSSEQ') DO;
      origin = "Predecessor";
      origindescription = "QS.QSSEQ";
      algorithm = "";
    END;
    WHEN (table='ADQS' AND column='QSCAT') DO;
      origin = "Predecessor";
      origindescription = "QS.QSCAT";
      algorithm = "";
    END;
    WHEN (table='ADQS' AND column='QSSCAT') DO;
      origin = "Predecessor";
      origindescription = "QS.QSSCAT";
      algorithm = "";
    END;
    WHEN (table='ADQS' AND column='QSORRES') DO;
      origin = "Predecessor";
      origindescription = "QS.QSORRES";
      algorithm = "";
    END;
    WHEN (table='ADQS' AND column='QSORRESU') DO;
      origin = "Predecessor";
      origindescription = "QS.QSORRESU";
      algorithm = "";
    END;
    WHEN (table='ADQS' AND column='QSSTRESC') DO;
      origin = "Predecessor";
      origindescription = "QS.QSSTRESC";
      algorithm = "";
    END;
    WHEN (table='ADQS' AND column='QSSTRESU') DO;
      origin = "Predecessor";
      origindescription = "QS.QSSTRESU";
      algorithm = "";
    END;
    OTHERWISE;
  END;