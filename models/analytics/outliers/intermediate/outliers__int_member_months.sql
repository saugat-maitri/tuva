{{ config(
     enabled = var('analytics_enabled',var('claims_enabled',var('clinical_enabled',var('tuva_marts_enabled',False)))) | as_bool
   )
}}

with avg_risk_score_by_year as (
  select
    payment_year
  , avg(v24_risk_score) as annual_avg_risk_score
  from {{ ref('cms_hcc__patient_risk_scores_monthly') }}
  group by payment_year
)

select
    mm.person_id
  , mm.member_id
  , cast({{ substring('mm.year_month', 1, 4) }} as integer) as year
  , mm.year_month
  , pt.sex
  , pt.race
  , pt.state
  , pt.age
  , pt.age_group
  , rsk.payment_year
  , rsk.v24_risk_score
  , rsk.v24_risk_score / avg.annual_avg_risk_score as population_normalized_risk_score
from {{ ref('core__member_months') }} mm
left join {{ ref('core__patient') }} pt
  on mm.person_id = pt.person_id
left join {{ ref('cms_hcc__patient_risk_scores') }} rsk
  on mm.person_id = rsk.person_id
left join avg_risk_score_by_year avg
  on rsk.payment_year = avg.payment_year
order by member_id