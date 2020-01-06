-- Run the sql below to verify no corruption has occurred from known pedigree lines.
-- Use code from the competition indexer to write to a file and fail if diferent... 
SELECT pedigree_key, path,  md5(path::text)  FROM pedigree
WHERE pedigree_key LIKE '%100XAA10%'
OR pedigree_key LIKE '%9XTG93%'
OR pedigree_key LIKE '%5xRB%'
OR pedigree_key LIKE '%2xARW%'
OR pedigree_key LIKE '%1XAW%'
OR pedigree_key LIKE '%21xBA%'
OR pedigree_key LIKE '%3xRR%'
