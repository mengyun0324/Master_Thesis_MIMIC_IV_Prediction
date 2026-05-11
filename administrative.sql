DROP MATERIALIZED VIEW IF EXISTS Administrative CASCADE;
CREATE MATERIALIZED VIEW Administrative AS
SELECT 
    icu.subject_id, 
    icu.hadm_id,
    icu.stay_id,       
    icd.icd_code,
    icd.icd_version,
    ad.admission_type,
    ad.admission_location,
    icu.los 
FROM mimiciv_icu.icustays AS icu
INNER JOIN mimiciv_hosp.diagnoses_icd AS icd
    ON icu.hadm_id = icd.hadm_id
INNER JOIN mimiciv_hosp.admissions AS ad
    ON icu.hadm_id = ad.hadm_id
WHERE icd.seq_num = 1;