DROP MATERIALIZED VIEW IF EXISTS vital_sign_first_day;
CREATE MATERIALIZED VIEW vital_sign_first_day AS
SELECT 
    i.subject_id,
	i.hadm_id,
    i.stay_id,
	i.intime,
    -- Heart Rate
    AVG(CASE WHEN c.itemid = 220045 AND c.valuenum > 0 AND c.valuenum < 300 THEN c.valuenum ELSE NULL END) AS heart_rate,
    
    -- Respiration Rate
    AVG(CASE WHEN c.itemid IN (220210, 224690) AND c.valuenum > 0 AND c.valuenum < 70 THEN c.valuenum ELSE NULL END) AS respiration,
    
    -- SpO2
    AVG(CASE WHEN c.itemid = 220277 AND c.valuenum > 0 AND c.valuenum <= 100 THEN c.valuenum ELSE NULL END) AS SPO2_peripheral,
    
    -- Arterial Blood Pressure
    -- Systolic
    AVG(CASE WHEN c.itemid IN (225309, 220050) AND c.valuenum > 0 AND c.valuenum < 300 THEN c.valuenum ELSE NULL END) AS art_bp_systolic,
    -- Diastolic
    AVG(CASE WHEN c.itemid IN (225310, 220051) AND c.valuenum > 0 AND c.valuenum < 200 THEN c.valuenum ELSE NULL END) AS art_bp_diastolic,
    -- Mean
    AVG(CASE WHEN c.itemid IN (225312, 220052) AND c.valuenum > 0 AND c.valuenum < 250 THEN c.valuenum ELSE NULL END) AS art_bp_mean,
    
    -- Non-Invasive Blood Pressure(NIBP)
    -- Non Invasive Blood Pressure Systolic
    AVG(CASE WHEN c.itemid = 220179 AND c.valuenum > 0 AND c.valuenum < 300 THEN c.valuenum ELSE NULL END) AS non_invasive_bp_systolic,
    -- Non Invasive Blood Pressure Diastolic
    AVG(CASE WHEN c.itemid = 220180 AND c.valuenum > 0 AND c.valuenum < 200 THEN c.valuenum ELSE NULL END) AS non_invasive_bp_diastolic,
    -- Non Invasive Blood Pressure Mean
    AVG(CASE WHEN c.itemid = 220181 AND c.valuenum > 0 AND c.valuenum < 250 THEN c.valuenum ELSE NULL END) AS non_invasive_bp_mean,    
    
    -- Glasgow Coma Scale(GCS)
    -- Eye
    AVG(CASE WHEN c.itemid = 220739 AND c.valuenum >= 1 AND c.valuenum <= 4 THEN c.valuenum ELSE NULL END) AS GLC_eye,
    -- Verbal
    AVG(CASE WHEN c.itemid = 223900 AND c.valuenum >= 1 AND c.valuenum <= 5 THEN c.valuenum ELSE NULL END) AS GLC_verbal,
    -- Motor
    AVG(CASE WHEN c.itemid = 223901 AND c.valuenum >= 1 AND c.valuenum <= 6 THEN c.valuenum ELSE NULL END) AS GLC_motor

FROM mimiciv_icu.chartevents AS c
INNER JOIN mimiciv_icu.icustays AS i
ON c.stay_id = i.stay_id

WHERE c.charttime >= i.intime 
  AND c.charttime <= i.intime + INTERVAL '24 hour'
  AND c.itemid IN (220045, 220210, 224690, 220277, 225309, 220050, 225310, 220051, 225312, 220052, 220179, 220180, 220181, 220739, 223900, 223901)
  AND c.value IS NOT NULL

GROUP BY i.subject_id, i.hadm_id, i.stay_id, i.intime
ORDER BY i.subject_id, i.intime ASC