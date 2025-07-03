{{ config(
     enabled = var('analytics_enabled',var('claims_enabled',var('clinical_enabled',var('tuva_marts_enabled',False)))) | as_bool
   )
}}

with member_paid_by_year as (
  select
    member_id
  , incr_year
  , sum(paid_amount) as paid
  from {{ ref('outliers__int_all_claims_agg') }}
  group by member_id, incr_year
)

, stats_by_year as (
    select
        incr_year
      , sum(paid) as total_paid
      , avg(paid) as mean_paid
      , stddev(paid) as stddev_paid
      , count(distinct member_id) as total_members
    from member_paid_by_year
    group by incr_year
)

select
    mpby.member_id
  , mpby.incr_year
  , mpby.paid
  , sby.total_members
  , sby.mean_paid
  , (sby.mean_paid + 2 * sby.stddev_paid) as outlier_threshold
  , mpby.paid / sby.total_paid as percent_paid
  , sby.total_paid
  , case
      when mpby.paid > (sby.mean_paid + 2 * sby.stddev_paid) then 'OUTLIER'
      else 'NORMAL'
    end as outlier_flag
from member_paid_by_year mpby
left join stats_by_year sby 
  on mpby.incr_year = sby.incr_year
order by mpby.paid desc