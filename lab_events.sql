DROP MATERIALIZED VIEW IF EXISTS lab_event_first_day;
CREATE MATERIALIZED VIEW lab_event_first_day AS
SELECT
    i.subject_id,
	i.hadm_id,
    i.stay_id,
	i.intime,
    -- Glucose
    MAX(CASE WHEN l.itemid = 50931 THEN l.valuenum ELSE NULL END) AS glucose,
    -- Creatinine
    MAX(CASE WHEN l.itemid = 50912 THEN l.valuenum ELSE NULL END) AS creatinine,
    -- Urea Nitrogen
    MAX(CASE WHEN l.itemid = 51006 THEN l.valuenum ELSE NULL END) AS urea_nitrogen,
    -- Sodium
    MAX(CASE WHEN l.itemid = 50983 THEN l.valuenum ELSE NULL END) AS sodium,
    -- Potassium
    MAX(CASE WHEN l.itemid = 50971 THEN l.valuenum ELSE NULL END) AS potassium,
    -- Chloride
    MAX(CASE WHEN l.itemid = 50902 THEN l.valuenum ELSE NULL END) AS chloride,
    -- Bicarbonate
    MAX(CASE WHEN l.itemid = 50882 THEN l.valuenum ELSE NULL END) AS bicarbonate,
    -- Anion Gap
    MAX(CASE WHEN l.itemid = 50868 THEN l.valuenum ELSE NULL END) AS anion_gap,
    -- Magnesium
    MAX(CASE WHEN l.itemid = 50960 THEN l.valuenum ELSE NULL END) AS magnesium,

    -- Hemoglobin
    MAX(CASE WHEN l.itemid = 51222 THEN l.valuenum ELSE NULL END) AS hemoglobin,
    -- Hematocrit
    MAX(CASE WHEN l.itemid = 51221 THEN l.valuenum ELSE NULL END) AS hematocrit,
    -- Red Blood Cells
    MAX(CASE WHEN l.itemid = 51279 THEN l.valuenum ELSE NULL END) AS rbc,
    -- RDW
    MAX(CASE WHEN l.itemid = 51277 THEN l.valuenum ELSE NULL END) AS rdw,
    -- MCV
    MAX(CASE WHEN l.itemid = 51250 THEN l.valuenum ELSE NULL END) AS mcv,
    -- MCH
    MAX(CASE WHEN l.itemid = 51248 THEN l.valuenum ELSE NULL END) AS mch,
    -- MCHC
    MAX(CASE WHEN l.itemid = 51249 THEN l.valuenum ELSE NULL END) AS mchc,

    -- White Blood Cells
    MAX(CASE WHEN l.itemid = 51301 THEN l.valuenum ELSE NULL END) AS wbc,
    -- Platelet Count
    MAX(CASE WHEN l.itemid = 51265 THEN l.valuenum ELSE NULL END) AS platelet

FROM mimiciv_hosp.labevents AS l
INNER JOIN mimiciv_icu.icustays AS i
ON l.hadm_id = i.hadm_id
WHERE l.charttime >= i.intime 
  AND l.charttime <= i.intime + INTERVAL '24 hour'
  AND l.itemid IN (
    50868, 50882, 50902, 50912, 50931, 50960, 50971, 50983, 51006, 
    51221, 51222, 51248, 51249, 51250, 51265, 51277, 51279, 51301
)
  AND l.valuenum IS NOT NULL 
GROUP BY i.subject_id, i.hadm_id, i.stay_id, i.intime
ORDER BY i.subject_id, i.intime ASC

