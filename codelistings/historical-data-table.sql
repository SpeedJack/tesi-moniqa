CREATE TABLE historical_data (
  fk_city INT(3) NOT NULL,
  year INT(4) NOT NULL,
  quarter TINYINT(1) NOT NULL,
  fk_sensortype INT(11) NOT NULL,
  measure_sum DECIMAL(18, 9) NOT NULL DEFAULT 0,
  measure_count INT(11) NOT NULL DEFAULT 1,
  PRIMARY KEY(fk_city, year, quarter, fk_sensortype),
  FOREIGN KEY(fk_city)
    REFERENCES cities(pk_city)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY(fk_sensortype)
    REFERENCES sensortypes(pk_sensortype)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

INSERT INTO historical_data
SELECT c.pk_city, YEAR(FROM_UNIXTIME(m.date DIV 1000, '%Y-%m-%d')) AS year,
  QUARTER(FROM_UNIXTIME(m.date DIV 1000, '%Y-%m-%d')) AS quarter,
  st.pk_sensortype, SUM(m.measure) AS measure_sum, COUNT(*) AS measure_count
FROM devices d
INNER JOIN cities c ON c.pk_city = d.fk_city
INNER JOIN sensors s ON s.fk_device = d.pk_device
INNER JOIN measurements m ON m.fk_sensor = s.pk_sensor
INNER JOIN sensortypes st ON st.pk_sensortype = s.fk_sensortype
GROUP BY c.pk_city, year, quarter, st.pk_sensortype;
