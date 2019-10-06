SELECT h.year, h.quarter, h.fk_sensortype,
  h.measure_sum/h.measure_count AS mean,
  h.measure_count AS count
FROM historical_data h
INNER JOIN cities c ON c.pk_city = h.fk_city
WHERE c.name = '{{PROVINCE_NAME}}'
  AND h.year BETWEEN {{START_YEAR}} AND {{END_YEAR}}
ORDER BY year ASC, quarter ASC;
