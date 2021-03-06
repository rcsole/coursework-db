USE prescriptionsdb;

-- a) How many practices and registered patients are there in the N17 postcode
--    Area?
SELECT COUNT(*) AS 'practices in n17',
       SUM(patientcount) AS 'patients in n17'
FROM practices
LEFT JOIN gppatients ON gppatients.practiceid = practices.id
WHERE postcode LIKE 'N17%';

-- +------------------+-----------------+
-- | practices in n17 | patients in n17 |
-- +------------------+-----------------+
-- |                7 | 49358           |
-- +------------------+-----------------+

-- b) Which practice prescribed the most beta blockers per registered patients
--    in total over the two month period?
-- Common beta-blockers include:
-- atenolol
-- bisoprolol
-- carvedilol
-- metoprolol
-- nebivolol
-- propranolol

SELECT bbpgp.practiceid AS 'practice id',
       bbpgp.total / gppatients.patientcount AS betablockersperpatient,
       bbpgp.practicename AS 'practice name'
FROM bbpgp
INNER JOIN gppatients ON gppatients.practiceid = bbpgp.practiceid
ORDER BY betablockersperpatient DESC
LIMIT 1;

-- +-------------+------------------------+------------------------+
-- | practice id | betablockersperpatient | practice name          |
-- +-------------+------------------------+------------------------+
-- | G82651      | 161.0000               | BURRSWOOD NURSING HOME |
-- +-------------+------------------------+------------------------+

-- c) Which was the most prescribed medication across all practices?
SELECT chemicalname,
       dispensedamount
FROM chemicals
INNER JOIN ppc ON ppc.bnfcodesub = chemicals.bnfcodesub
ORDER BY dispensedamount DESC
LIMIT 1;

-- +----------------+-----------------+
-- | chemicalname   | dispensedamount |
-- +----------------+-----------------+
-- | Colecalciferol |          280495 |
-- +----------------+-----------------+

-- d) Which practice spent the most and the least per patient?
SELECT spentperpatient,
       practicename
FROM
  (SELECT spent / patientcount AS spentperpatient,
          spentpergp.practiceid
   FROM spentpergp
   INNER JOIN gppatients ON gppatients.practiceid = spentpergp.practiceid) AS spp
INNER JOIN practices ON spp.practiceid = practices.id
ORDER BY spentperpatient DESC
LIMIT 1;

-- +-------------------+------------------------+
-- | spentperpatient   | practicename           |
-- +-------------------+------------------------+
-- | 7609.050047278404 | BURRSWOOD NURSING HOME |
-- +-------------------+------------------------+

SELECT spentperpatient,
       practicename
FROM
  (SELECT spent / patientcount AS spentperpatient,
          spentpergp.practiceid
   FROM spentpergp
   INNER JOIN gppatients ON gppatients.practiceid = spentpergp.practiceid) AS spp
INNER JOIN practices ON spp.practiceid = practices.id
ORDER BY spentperpatient ASC
LIMIT 1;

-- +----------------------+------------------------------------------+
-- | spentperpatient      | practicename                             |
-- +----------------------+------------------------------------------+
-- | 0.013433942387335699 | SCHOOL LANE PMS PRACTICE                 |
-- +----------------------+------------------------------------------+

-- e) What was the difference in selective serotonin reuptake inhibitor
--    prescriptions between January and February?
-- There are currently seven SSRIs prescribed in the UK:
-- citalopram (Cipramil)
-- dapoxetine (Priligy)
-- escitalopram (Cipralex)
-- fluoxetine (Prozac or Oxactin)
-- fluvoxamine (Faverin)
-- paroxetine (Seroxat)
-- sertraline (Lustral)
SELECT period,
       COUNT(*) AS 'SSRI prescriptions'
FROM ssriprescriptions
GROUP BY period;

-- +--------+--------------------+
-- | period | SSRI prescriptions |
-- +--------+--------------------+
-- | 201601 |              99797 |
-- | 201602 |              99311 |
-- +--------+--------------------+
-- There were 486 less SSRI prescriptions in February than in January.

-- f) Visualise the top 10 practices by number of metformin prescriptions
--    throughout the entire period.
SELECT COUNT(*) AS prescribed,
       practicename
FROM metforminprescriptions
INNER JOIN practices ON id = practiceid
GROUP BY practiceid
ORDER BY prescribed DESC
LIMIT 10;

-- +------------+----------------------------------+
-- | prescribed | practicename                     |
-- +------------+----------------------------------+
-- |         45 | DR GHAFOOR & ABBASI              |
-- |         44 | PARADISE MEDICAL CENTRE          |
-- |         44 | SHANTI MEDICAL CENTRE            |
-- |         40 | MIDLANDS MEDICAL PARTNERSHIP     |
-- |         39 | BUXTED MEDICAL CENTRE            |
-- |         39 | WHITE HORSE HEALTH CENTRE        |
-- |         38 | EAGLE HOUSE SURGERY              |
-- |         38 | OLD TRAFFORD MEDICAL PRACTICE    |
-- |         38 | HALL GREEN HEALTH                |
-- |         37 | EAST NORWICH MEDICAL PARTNERSHIP |
-- +------------+----------------------------------+
