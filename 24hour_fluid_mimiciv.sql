WITH
  t1 AS (
  SELECT
    mv.stay_id,
    mv.starttime AS charttime
    -- standardize the units to millilitres
    -- also metavision has floating point precision.. but we only care down to the mL
    ,
    ROUND(CASE
        WHEN mv.amountuom = 'L' THEN mv.amount * 1000.0
        WHEN mv.amountuom = 'ml' THEN mv.amount
      ELSE
      NULL
    END
      ) AS amount
  FROM
    `physionet-data.mimic_icu.inputevents` mv
  WHERE
    mv.itemid IN (
      -- 225943 Solution
      225158,
      -- NaCl 0.9%
      225828,
      -- LR
      225944,
      -- Sterile Water
      225797,
      -- Free Water
      225159,
      -- NaCl 0.45%
      -- 225161, -- NaCl 3% (Hypertonic Saline)
      225823,
      -- D5 1/2NS
      225825,
      -- D5NS
      225827,
      -- D5LR
      225941,
      -- D5 1/4NS
      226089 -- Piggyback
      )
    AND mv.statusdescription != 'Rewritten' AND
    -- in MetaVision, these ITEMIDs appear with a null rate IFF endtime=starttime + 1 minute
    -- so it is sufficient to:
    --    (1) check the rate is > 240 if it exists or
    --    (2) ensure the rate is null and amount > 240 ml
    ( (mv.rate IS NOT NULL
        AND mv.rateuom = 'mL/hour')
      OR (mv.rate IS NOT NULL
        AND mv.rateuom = 'mL/min')
      OR (mv.rate IS NULL
        AND mv.amountuom = 'L')
      OR (mv.rate IS NULL
        AND mv.amountuom = 'ml') ) ),

    
t3 AS(
  SELECT
    *
  FROM
    t1
    -- just because the rate was high enough, does *not* mean the final amount was
  WHERE
  stay_id IS NOT NULL ),
    
  t4 AS(
  SELECT
    stay_id,
    charttime,
    SUM(amount) AS intake_first,
    DATETIME_DIFF(charttime,
      INTIME,
      MINUTE) AS chartoffset
  FROM
    t3
  LEFT JOIN
    `physionet-data.mimic_icu.icustays`
  USING
    (stay_id)
    -- just because the rate was high enough, does *not* mean the final amount was
  WHERE
  stay_id IS NOT NULL
  GROUP BY
    t3.stay_id,
    t3.charttime,
    intime),
    
t5 AS (
  SELECT
    stay_id,
    sum (intake_first) AS intakes,
  FROM
    t4
  WHERE
    intake_first IS NOT NULL
    AND chartoffset BETWEEN -6*60 AND 36*60
  GROUP BY
    stay_id,
    chartoffset
  ORDER BY
    stay_id)
    
SELECT
  stay_id,
  sum (intakes) AS intakes_total
FROM
  t5
GROUP BY
  stay_id
ORDER BY
  stay_id;