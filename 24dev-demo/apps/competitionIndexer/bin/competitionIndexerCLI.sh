#!/bin/bash
# File: competitionIndexerCLI.sh
<<COMMENT_OUT
COMMENT_OUT

echo "Starting script on:" $(date)
echo
BASE=$(pwd|cut -d"/" -f-6)
echo BASE=$BASE

echo "This program is copyrighted under the MIT license.  See: https://github.com/pmcgover/24dev-demo/blob/master/LICENSE"
echo "Source the 24dev profile to set variables and display license/program details..."
if [[  -r ${BASE}/.24dev.profile ]]; then
   . ${BASE}/.24dev.profile
else 
   echo "Failure: The profile is not readable or could not be found: ${BASE}/.24dev.profile"
   exit 1   
fi
echo 

read -r -d '' usage <<-'EOF'
Usage: competitionIndexerCLI.sh -f [inputFile.csv] 
       Example: competitionIndexerCLI.sh -f ../input/u07m-1yrDataSet-Input.csv 
       Please read the documentation under: ../docs  

EOF

if [[ $#  -ne 2 ]] ; then
  echo "Error: Requires a comma delimited CSV file" 
  echo "$usage"
  echo
  exit 1
fi

while getopts ":f:" options; do
  case $options in
    f )  inputFile=$OPTARG
         echo "Input File Name= $inputFile"
         ;; 
    \? ) echo "Error: Invalid Option!" 
         echo "$usage"
         echo
         exit 1
         ;;
  esac
done

echo "Check if the input CSV file has the minimal header line: $requiredHeaders" 
echo 
requiredHeaders="id,setid,long_ft,short_ft,row,col,block,dbh,year,site,name"
chkHeader=$(head -1 $inputFile|grep -i "^$requiredHeaders")
if [[ -z $chkHeader ]]; then
  echo
  echo "FAILURE: The supplied file does not have the minimal header line: $requiredHeaders" 
  echo "The header line contains: $chkHeader" 
  echo
  echo "$usage"
  echo 
  exit 1
fi

echo
echo "Display the first 10 lines of the input file: $inputFile..." 
head $inputFile
echo

echo
echo "Check if the input file has the same number of comma separated fields on each line..."
awk -F ',' '{print NF-1}' $inputFile|uniq
getcsvcount=$(awk -F ',' '{print NF-1}' $inputFile|uniq|wc -l)
if [[ $getcsvcount -gt 1 ]]; then
  echo "FAILURE: The input CSV file has variable number of comma separated fields." 
  echo "getcsvcount=$getcsvcount"
  exit 1
fi


echo "Extract any optional INFO header fields to append them the required T1 columns..." 
optionalHeaders=$(head -1 $inputFile |sed "s/$requiredHeaders//g")
if [[ -n $optionalHeaders ]] ; then
  optionalHeaders="${optionalHeaders},"
  echo "The optional headers are: $optionalHeaders"
  optionalHeaderText=$(echo "$optionalHeaders"|sed 's/[^,][^,]*/& VARCHAR/g;s/^,//g')
  echo "The NEW optional Text data type headers are: ...$optionalHeaderText..."
  echo
else
  echo "FYI: There are no optional headers..."
  echo
  optionalHeaderText="" 
fi

# Put the output file in the directory listed below: 
echo
echo "Extract the basename of the input file..."
baseInputFileName=$(basename $inputFile)
echo "The Base input file name is: baseInputFileName=$baseInputFileName" 
outFileName="../output/Output-${baseInputFileName}"

set -e
set -u
RUN_ON_MYDB="psql -X --set ON_ERROR_STOP=on --set AUTOCOMMIT=off r4p"

echo "DROP all tables and views..." 
$RUN_ON_MYDB <<SQL
DROP TABLE if exists CI1 CASCADE;
DROP VIEW if exists vw_ci2 CASCADE;
DROP VIEW if exists vw_ci3 CASCADE;
commit;
SQL

echo
echo "Create first table, CI1 with the input file values..."
$RUN_ON_MYDB <<SQL
CREATE TABLE CI1( 
id serial,
setid INTEGER NOT NULL, 
long_ft INTEGER NOT NULL, 
short_ft INTEGER NOT NULL, 
row INTEGER NOT NULL, 
col INTEGER NOT NULL,
block INTEGER NOT NULL,
dbh NUMERIC NOT NULL, 
year VARCHAR NOT NULL, 
site VARCHAR NOT NULL, 
name VARCHAR NOT NULL, 
${optionalHeaderText}
CONSTRAINT CI1_pk PRIMARY KEY (id)
);
commit;
SQL

echo "Load the input CSV file into the CI1 table..."
$RUN_ON_MYDB <<SQL
\copy CI1 from '$inputFile' delimiter ',' CSV HEADER
commit;
SQL

echo "Display first record of the CI1 Table..."
$RUN_ON_MYDB <<SQL
select * from CI1 
limit 1;
commit;
SQL

echo
echo "Create the CI calculations view: CI2..."
angleA="atan(t.long_ft / t.short_ft)"
angleB="1.57079633 - (atan(t.long_ft / t.short_ft))"

$RUN_ON_MYDB <<SQL
DROP VIEW if exists vw_ci2 CASCADE;
CREATE VIEW vw_ci2 AS
select
distinct t.setid,
t.long_ft as Clong,
t.short_ft as Cshort,
sqrt(t.long_ft^2 + t.short_ft^2) as Cdiag,
$angleA as angleA,
$angleB as angleB,
sin($angleA) as SA,
cos($angleA) as CA,
sin($angleB) as SB,
cos($angleB) as CB
from CI1 t
order by t.setid;
commit;
SQL

echo
echo "Display first record of the vw_ci2 view..."
$RUN_ON_MYDB <<SQL
select * from vw_ci2 view
limit 1;
commit;
SQL
echo

echo "DROP/ADD the  competition indexer view: vw_ci2..."
$RUN_ON_MYDB <<SQL
DROP VIEW if exists vw_ci3 CASCADE;
CREATE VIEW vw_ci3 AS 
select top.*,
-- Display Line Lengths for each of the directional competition tree:
round((s.Nl)::numeric, 1)  Nline, round((s.NEl)::numeric, 1) NEline, round((s.El)::numeric, 1)  Eline, round((s.SEl)::numeric, 1) SEline,
round((s.Sl)::numeric, 1)  Sline, round((s.SWl)::numeric, 1) SWline, round((s.Wl)::numeric, 1)  Wline, round((s.NWl)::numeric, 1) NWline,
round((s.Nl + s.NEl + s.El + s.SEl + s.Sl + s.SWl + s.Wl + s.NWl)::numeric, 2) AS  Line_Index,
-- Process all directional lines for Area-Index   
round(coalesce((
-- NW-N  IF(L14<L15,0.5*(SA*L14)*(CA*L14),  0.5*(SA*L15)*(CA*L15)) IF(L14<L15,0.5*((L15-(CA*L14))*(SA*L14)),  0.5*((L14-(CA*L15))*(SA*L15)))
 ( CASE WHEN s.NWl < s.Nl THEN 0.5*((s.SA * s.NWl)*(s.CA * s.NWl)) ELSE 0.5*((s.SA * s.Nl)*(s.CA * s.Nl)) END +
   CASE WHEN s.NWl < s.Nl THEN 0.5*((s.Nl -(s.CA * s.NWl))*(s.SA * s.NWl)) ELSE 0.5*((s.NWl-(s.CA * s.Nl))*(s.SA * s.Nl)) END) +
-- 
-- N-NE IF(U15<U16,0.5*(s.SA *U15)*(s.CA *U15),  0.5*(s.SA *U16)*(s.CA *U16))  IF(U15<U16,0.5*((U16-(s.CA *U15))*(s.SA *U15)),  0.5*((U15-(s.CA *U16))*(s.SA *U16)))
 ( CASE WHEN s.Nl < s.NEl THEN 0.5*((s.SA * s.Nl)*(s.CA * s.Nl)) ELSE 0.5*((s.SA * s.NEl)*(s.CA * s.NEl)) END + 
   CASE WHEN s.Nl < s.NEl THEN 0.5*((s.NEl -(s.CA * s.Nl))*(s.SA * s.Nl)) ELSE 0.5*((s.Nl -(s.CA * s.NEl))*(s.SA * s.NEl)) END) + 
--
-- NE-E IF(U16<U17,0.5*(s.SB *U16)*(s.CB *U16),0.5*(s.SB *U17)*(s.CB *U17))   IF(U16<U17,0.5*((U17-(s.CB *U16))*s.SB *U16),  0.5*((U16-(s.CB *U17))*(s.SB *U17)))
 ( CASE WHEN s.NEl < s.El THEN 0.5*((s.SB * s.NEl)*(s.CB * s.NEl)) ELSE 0.5*((s.SB * s.El)*(s.CB * s.El)) END  +    
   CASE WHEN s.NEl < s.El THEN 0.5*((s.El -(s.CB * s.NEl))*(s.SB * s.NEl)) ELSE 0.5*((s.NEl -(s.CB * s.El))*(s.SB * s.El)) END) + 
--
-- E-SE IF(U17<U18,0.5*(s.SB *U17)*(s.CB *U17),  0.5*(s.SB *U18)*(s.CB *U18))   IF(U17<U18,0.5*((U18-(s.CB *U17))*s.SB *U17),  0.5*((U17-(s.CB *U18))*(s.SB *U18)))
 ( CASE WHEN s.El < s.SEl THEN 0.5*((s.SB * s.El)*(s.CB * s.El)) ELSE 0.5*((s.SB * s.SEl)*(s.CB * s.SEl)) END + 
   CASE WHEN s.El < s.SEl THEN 0.5*((s.SEl -(s.CB * s.El ))*(s.SB* s.El)) ELSE 0.5*((s.El -(s.CB * s.SEl))*(s.SB* s.SEl)) END) + 
--
-- SE-S IF(U18<U19,0.5*(s.SA *U18)*(s.CA *U18),  0.5*(s.SA *U19)*(s.CA *U19))  IF(U18<U19,0.5*((U19-(s.CA *U18))*(s.SA *U18)), 0.5*((U18-(s.CA *U19))*(s.SA *U19)))
 ( CASE WHEN s.SEl < s.Sl THEN 0.5*((s.SA * s.SEl)*(s.CA * s.SEl)) ELSE 0.5*((s.SA * s.Sl)*(s.CA * s.Sl)) END +   
   CASE WHEN s.SEl < s.Sl THEN 0.5*((s.Sl -(s.CA * s.SEl ))*(s.SA * s.SEl)) ELSE 0.5*((s.SEl -(s.CA * s.Sl))*(s.SA * s.Sl)) END) + 
--
-- S-SW IF(U19<U20,0.5*(s.SA *U19)*(s.CA *U19), 0.5*(s.SA *U20)*(s.CA *U20))   IF(U19<U20,0.5*((U20-(s.CA *U19))*(s.SA *U19)), 0.5*((U19-(s.CA *U20))*(s.SA *U20)))
 ( CASE WHEN s.Sl < s.SWl THEN 0.5*((s.SA * s.Sl)*(s.CA * s.Sl)) ELSE 0.5*((s.SA * s.SWl)*(s.CA * s.SWl)) END +
   CASE WHEN s.Sl < s.SWl THEN 0.5*((s.SWl -(s.CA * s.Sl ))*(s.SA * s.Sl)) ELSE 0.5*((s.Sl -(s.CA * s.SWl))*(s.SA * s.SWl)) END) + 
--
-- SW-W IF(U20<U21,0.5*(s.SB *U20)*(s.CB *U20),  0.5*(s.SB *U21)*(s.CB *U21))   IF(U20<U21,0.5*((U21-(s.CB *U20))*s.SB *U20),  0.5*((U20-(s.CB *U21))*(s.SB *U21)))
 ( CASE WHEN s.SWl < s.Wl THEN 0.5*((s.SB * s.SWl)*(s.CB * s.SWl)) ELSE 0.5*((s.SB * s.Wl)*(s.CB * s.Wl)) END +   
   CASE WHEN s.SWl < s.Wl THEN 0.5*((s.Wl -(s.CB * s.SWl ))*(s.SB * s.SWl)) ELSE 0.5*((s.SWl -(s.CB * s.Wl))*(s.SB * s.Wl)) END) + 
--
-- W-NW IF(U21<U14,0.5*(s.SB *U21)*(s.CB *U21),  0.5*(s.SB *U14)*(s.CB *U14)) --  IF(U21<U14,0.5*((U14-(s.CB *U21))*s.SB *U21),  0.5*((U21-(s.CB *U14))*(s.SB *U21)))
 ( CASE WHEN s.Wl < s.NWl THEN 0.5*((s.SB * s.Wl)*(s.CB * s.Wl)) ELSE 0.5*((s.SB * s.NWl)*(s.CB * s.NWl)) END +
  CASE WHEN s.Wl < s.NWl THEN 0.5*((s.NWl -(s.CB * s.Wl ))*(s.SB * s.Wl)) ELSE 0.5*((s.Wl -(s.CB * s.NWl))*(s.SB * s.NWl)) END)   ),0)::numeric  ,2) AS Area_Index,
-- Competition Tree DBHs: 
top.name sName2,
coalesce(s.Ndbh,0) n_dbh, coalesce(s.NEdbh,0) ne_dbh, coalesce(s.Edbh,0) e_dbh, coalesce(s.SEdbh,0) se_dbh, 
coalesce(s.Sdbh,0) s_dbh, coalesce(s.SWdbh,0) sw_dbh, coalesce(s.Wdbh,0) w_dbh, coalesce(s.NWdbh,0) nw_dbh,
top.name sName3,
coalesce(s.dbhcount,0) AS DBH_Count, 
-- Display the DBH sum of the competition trees: 
(coalesce(s.Ndbh,0) + coalesce(s.NEdbh,0) + coalesce(s.Edbh,0) + coalesce(s.SEdbh,0) +
coalesce(s.Sdbh,0) + coalesce(s.SWdbh,0) + coalesce(s.Wdbh,0) + coalesce(s.NWdbh,0)) AS cDbh_Sum,
round(s.avg_cdbh,2) AS cDBH_AVG,
round(coalesce(top.dbh / nullif(s.avg_cdbh,0),0),2)  AS DBH_Ratio,
-- Sum of DBH Ratios: NW/Cc+N/Cc+NE/Cc+E/Cc+SE/Cc+S/Cc+SW/Cc+W/Cc 
round(  
   coalesce(s.Ndbh/nullif(top.dbh,0),0) + coalesce(s.NEdbh/nullif(top.dbh,0),0) +
   coalesce(s.Edbh/nullif(top.dbh,0),0) + coalesce(s.SEdbh/nullif(top.dbh,0),0) +
   coalesce(s.Sdbh/nullif(top.dbh,0),0) + coalesce(s.SWdbh/nullif(top.dbh,0),0) +
   coalesce(s.Wdbh/nullif(top.dbh,0),0) + coalesce(s.NWdbh/nullif(top.dbh,0),0) ,2) AS Sum_DBH_Ratio1_sd,
round(  
   coalesce(top.dbh/nullif(s.Ndbh,0),0) + coalesce(top.dbh/nullif(s.NEdbh,0),0) +
   coalesce(top.dbh/nullif(s.Edbh,0),0) + coalesce(top.dbh/nullif(s.SEdbh,0),0) + 
   coalesce(top.dbh/nullif(s.Sdbh,0),0) + coalesce(top.dbh/nullif(s.SWdbh,0),0) + 
   coalesce(top.dbh/nullif(s.Wdbh,0),0) + coalesce(top.dbh/nullif(s.NWdbh,0),0),2) AS Sum_DBH_Ratio2_cd,
-- BA_Ratio: Cc^2/((NW^2+N^2+NE^2+E^2+SE^2+S^2+SW^2+W^2)/8)  --- todo verify this formula
--coalesce(round(top.dbh^2 / avg_cba,2),0) as BA_Ratio,
coalesce(round(top.dbh^2 / nullif(avg_cba,0) ,2),0) as BA_Ratio,
-- SumBAratio: (NW^2/Cc^2)+(N^2/Cc^2)+(NE^2/Cc^2)+(E^2/Cc^2)+(SE^2/Cc^2)+(S^2/Cc^2)+(SW^2/Cc^2)+(W^2/Cc^2))
-- Brads old Formula: .005454*((Cc/NW)^2+(Cc/N)^2+....(Cc/W)^2)
round(
   coalesce(s.Ndbh/nullif(top.dbh,0),0)^2  + coalesce(s.NEdbh/nullif(top.dbh,0),0)^2 + coalesce(s.Edbh/nullif(top.dbh,0),0)^2  + 
   coalesce(s.SEdbh/nullif(top.dbh,0),0)^2 + coalesce(s.Sdbh/nullif(top.dbh,0),0)^2  + coalesce(s.SWdbh/nullif(top.dbh,0),0)^2 + 
   coalesce(s.Wdbh/nullif(top.dbh,0),0)^2  + coalesce(s.NWdbh/nullif(top.dbh,0),0)^2 ,2) AS Sum_BA_Ratio,
round(top.dbh * s.avg_cdbh,2)  AS sDBH_x_AvgcDBH
-------- ################################# --------------
/* --------------------------------- Start Comment out Bottom for DEBUGGING  ######################################### 
*/ --------------------------------- End Comment out Bottom for DEBUGGING  ######################################### 
-------------END: Comma separated Select statements, last statement must NOT end in a comma --------------------------
-- Start From clauses using In-Line Views that emulate nested tables. 
-- Note that the input data may have LOTS of null values where trees don't exist, and zeros where trees are dead.
-- Zero values cause issues becaue you cant divide by zero.  Null values break addition but allow division.
-- For null values, use coalesce to convert nulls to zero.  Use nullif to convert zeros to nulls (for division), then convert to 0 with coalesce.
-------- ################################# --------------
FROM ci1 AS top -- Denotes Top level view 
LEFT JOIN ( -- Join to the Subject Inline View (aka: s)
  select sub.id, sub.name, sub.row, sub.col, sub.dbh, 
  -- Load each competition tree DBH to an alias:
  nullif(N.dbh,0) Ndbh, nullif(NE.dbh,0) NEdbh, nullif(E.dbh,0) Edbh, nullif(SE.dbh,0) SEdbh, 
  nullif(S.dbh,0) Sdbh, nullif(SW.dbh,0) SWdbh, nullif(W.dbh,0) Wdbh, nullif(NW.dbh,0) NWdbh,
  -- Calculate the mean DBH of the competion trees: 
  ( 
    coalesce(N.dbh,0) + coalesce(NE.dbh,0) + coalesce(E.dbh,0) + coalesce(SE.dbh,0) + 
    coalesce(S.dbh,0) + coalesce(SW.dbh,0) + coalesce(W.dbh,0) + coalesce(NW.dbh,0)
  ) / 8 AS avg_cdbh, 
   -- Calculate the mean Basal Area (BA): (.005454*(NW^2+....W^2)/8
  (
      coalesce(N.dbh,0)^2 + coalesce(NE.dbh,0)^2 + coalesce(E.dbh,0)^2 + coalesce(SE.dbh,0)^2 + 
      coalesce(S.dbh,0)^2 + coalesce(SW.dbh,0)^2 + coalesce(W.dbh,0)^2 + coalesce(NW.dbh,0)^2 
  ) / 8.0
    AS avg_cba,
   -- Count the live Competion tree DBHs > 0 (Sum of live trees) 
  ( 
    (CASE WHEN (N.dbh > 0)  THEN 1 ELSE 0 END) + (CASE WHEN (NE.dbh > 0) THEN 1  ELSE 0 END) + (CASE WHEN (E.dbh > 0)  THEN 1 ELSE 0 END) +
    (CASE WHEN (SE.dbh > 0) THEN 1 ELSE 0 END) + (CASE WHEN (S.dbh > 0)  THEN 1 ELSE 0 END)  + (CASE WHEN (SW.dbh > 0) THEN 1 ELSE 0 END) +
    (CASE WHEN (W.dbh > 0)  THEN 1 ELSE 0 END) + (CASE WHEN (NW.dbh > 0) THEN 1 ELSE 0 END)
  ) AS dbhcount,
   -- Calculate Line Lengths for Line and area Indexes: 
    coalesce(sub.dbh/(nullif(sub.dbh,0) + coalesce(N.dbh,0))  * ss.cShort,0) as Nl,
    coalesce(sub.dbh/(nullif(sub.dbh,0) + coalesce(NE.dbh,0)) * ss.cDiag,0)  as NEl,
    coalesce(sub.dbh/(nullif(sub.dbh,0) + coalesce(E.dbh,0))  * ss.cLong,0)  as El,
    coalesce(sub.dbh/(nullif(sub.dbh,0) + coalesce(SE.dbh,0)) * ss.cDiag,0)  as SEl,
    coalesce(sub.dbh/(nullif(sub.dbh,0) + coalesce(S.dbh,0))  * ss.cShort,0) as Sl,
    coalesce(sub.dbh/(nullif(sub.dbh,0) + coalesce(SW.dbh,0)) * ss.cDiag,0)  as SWl,
    coalesce(sub.dbh/(nullif(sub.dbh,0) + coalesce(W.dbh,0))  * ss.cLong,0)  as Wl,
    coalesce(sub.dbh/(nullif(sub.dbh,0) + coalesce(NW.dbh,0)) * ss.cDiag,0)  as NWl,
  -- Load the Calculated Area variables from the vw_ci2 table:
  ss.SA as SA, ss.CA as CA, ss.SB as SB, ss.CB as CB
  from ci1 sub -- Denotes: Subject trees of interest 
  -- Calculate the pie and diagonal areas from the line lengths
  -- LEFT JOIN ( select id, setid, long_ft cLongDist, short_ft cShortDist from vw_ci2) AS ss  ON ss.id = sub.id and ss.setid = sub.setid -- Test inline View before ss
  -- Load all data from Competition trees: Direction of Row-Columns:  N-1+0 NE-1+1 E+0+1 SE+1+1 S+1+0 SW+1-1 W+0-1 NW-1-1
  -- Non-existent tree locations are null so they are converted to zero when they are used above  
  LEFT JOIN (select * from vw_ci2) as ss -- Set Level Stage Table
  ON ss.setid = sub.setid
  LEFT JOIN (select * from ci1) as N 
  ON N.row=sub.row-1 and N.col=sub.col+0 and N.setid = sub.setid 
  LEFT JOIN (select * from ci1) as NE 
  ON NE.row=sub.row-1 and NE.col=sub.col+1  and NE.setid = sub.setid  
  LEFT JOIN (select * from ci1) as E
  ON E.row=sub.row+0 and E.col=sub.col+1 and E.setid = sub.setid 
  LEFT JOIN (select * from ci1) as SE 
  ON SE.row=sub.row+1 and SE.col=sub.col+1  and SE.setid = sub.setid  
  LEFT JOIN (select * from ci1) as S
  ON S.row=sub.row+1 and S.col=sub.col+0 and S.setid = sub.setid 
  LEFT JOIN (select * from ci1) as SW
  ON SW.row=sub.row+1 and SW.col=sub.col-1 and SW.setid = sub.setid 
  LEFT JOIN (select * from ci1) as W
  ON W.row=sub.row+0 and W.col=sub.col-1 and W.setid = sub.setid 
  LEFT JOIN (select * from ci1) as NW 
  ON NW.row=sub.row-1  and NW.col=sub.col-1 and NW.setid = sub.setid 
) AS s -- Denotes: Subject Inline View 
ON s.id = top.id;
commit;
SQL


echo
echo "Display first few records of the vw_ci3 view..."
$RUN_ON_MYDB <<SQL
select * from vw_ci3 view
order by id
limit 8;
commit;
SQL
echo


echo
echo "Write contents of the vw_ci3 view to output CSV file $outFileName"
$RUN_ON_MYDB <<SQL > $outFileName
copy (SELECT * from vw_ci3 order by id) TO STDOUT delimiter ',' CSV HEADER;
SQL
echo

echo
echo "Check if the OUTPUT file has the same number of rows ase the input file..."
getOutLineCount=$(wc -l $outFileName|awk '{print $1}')
getInputLineCount=$(wc -l $inputFile|awk '{print $1}')
if [[ $getOutLineCount -ne $getInputLineCount ]]; then
  echo "FAILURE: The output and input CSV files have a different number of lines:"
  echo "getOutLineCount=$getOutLineCount, getInputLineCount=$getInputLineCount"
  exit 1
fi
echo "getOutLineCount=$getOutLineCount  getInputLineCount=$getInputLineCount"


echo
echo "We are finished so cleanup files/tables..." 

echo "DROP all tables and views..." 
$RUN_ON_MYDB <<SQL
DROP TABLE if exists CI1 CASCADE;
DROP VIEW if exists vw_ci2 CASCADE;
DROP VIEW if exists vw_ci3 CASCADE;
commit;
SQL

