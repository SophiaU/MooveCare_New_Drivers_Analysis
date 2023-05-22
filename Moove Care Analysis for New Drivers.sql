----Moove Care Analysis for New Drivers----
---Basic Metrics---[GBs, Trips, SH, CR no. of times they received incentive etc]----

select week_no, drn, SUM(perf_trips)perf_trips, SUM(supply_hours)supply_hours, Avg(cancellation_rate)cancellation_rate, SUM(gross_booking)gross_booking, SUM(net_earning)net_earning,  SUM(uber_balance)uber_balance 
from vw_uber_driver_aggr_daily 
where drn IN (
select drn from 
----Drivers who joined newly from April 2023---
(Select distinct drn,city, min(effective_start_date)effective_start_date from 
(select c.registration_no as plate_number, b.drn, b.name, a.effective_start_date, a.effective_end_date,
c.make, c.model, c.year, c.color, mc.name as city, c.vin, a.description 
from moovebackend.driver_drivervehicleassignment a, moovebackend.driver_driver b, moovebackend.driver_vehicle c, 
moovebackend.markets_city mc where a.driver_id = b.id and a.vehicle_id = c.id and c.city_id = mc.id 
order by mc.name, effective_end_date desc, effective_start_date desc) 
group by drn,city
having min(effective_start_date) >= '2023-04-01' and lower(city) = 'lagos') )
group by week_no, drn;




---Num of Times Incentives Was Received---
select * FROM reconciliation_history.drivers_data_reconciliation_ubergo_lagos_tryout where drn = 'DRN014115'; limit 20;

SELECT week, drn, Count(incentives)incentive_days,'UberGo DTO 48 [Spresso]' as product
FROM (
  SELECT drn, week, incentives
  FROM reconciliation_current.drivers_data_reconciliation_ubergo_lagos_tryout
  WHERE "day" <= '2023-05-21'
  UNION ALL
  SELECT drn, week, incentives
  FROM reconciliation_history.drivers_data_reconciliation_ubergo_lagos_tryout
  WHERE "day" >= '2023-04-03'
) combined_data
where incentives = 3400
and drn in (
----
select drn from 
----Drivers who joined newly from April 2023---
(Select distinct drn,city, min(effective_start_date)effective_start_date from 
(select c.registration_no as plate_number, b.drn, b.name, a.effective_start_date, a.effective_end_date,
c.make, c.model, c.year, c.color, mc.name as city, c.vin, a.description 
from moovebackend.driver_drivervehicleassignment a, moovebackend.driver_driver b, moovebackend.driver_vehicle c, 
moovebackend.markets_city mc where a.driver_id = b.id and a.vehicle_id = c.id and c.city_id = mc.id 
order by mc.name, effective_end_date desc, effective_start_date desc) 
group by drn,city
having min(effective_start_date) >= '2023-04-01' and lower(city) = 'lagos')
)
GROUP BY week,drn;

