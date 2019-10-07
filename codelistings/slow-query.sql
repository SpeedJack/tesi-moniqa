SELECT YEAR(FROM_UNIXTIME(m.date DIV 1000, '%Y-%m-%d')) AS year,
  QUARTER(FROM_UNIXTIME(m.date DIV 1000, '%Y-%m-%d')) AS quarter,
  s.fk_sensortype, CAST(AVG(m.measure) AS DECIMAL(10,3)) AS mean,
  COUNT(*) AS count
FROM devices d
INNER JOIN cities c ON c.pk_city = d.fk_city
INNER JOIN sensors s ON s.fk_device = d.pk_device
INNER JOIN measurements m ON m.fk_sensor = s.pk_sensor
WHERE c.name = '{{CITY_NAME}}'
  AND m.date BETWEEN (UNIX_TIMESTAMP(CONCAT('{{START_YEAR}}', '-01-01')) * 1000)
  AND ((UNIX_TIMESTAMP(CONCAT('{{END_YEAR}}', '-01-01')) * 1000) - 1)
GROUP BY year, quarter, s.fk_sensortype
ORDER BY year ASC, quarter ASC;
