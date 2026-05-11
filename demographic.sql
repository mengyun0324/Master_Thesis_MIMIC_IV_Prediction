DROP MATERIALIZED VIEW IF EXISTS Demographic;
CREATE MATERIALIZED VIEW Demographic AS
SELECT
  i.subject_id,
  i.hadm_id,
  pa.anchor_age + EXTRACT(EPOCH FROM ad.admittime - MAKE_TIMESTAMP(pa.anchor_year, 1, 1, 0, 0, 0)) / 31556908.8 AS age,
  pa.gender,
  ad.race
FROM mimiciv_hosp.admissions AS ad
INNER JOIN mimiciv_hosp.patients AS pa
ON ad.subject_id = pa.subject_id
INNER JOIN mimiciv_icu.icustays AS i
ON ad.hadm_id = i.hadm_id AND ad.subject_id = i.subject_id
