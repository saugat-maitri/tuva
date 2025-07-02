{{ config(
     enabled = var('analytics_enabled',var('claims_enabled',var('clinical_enabled',var('tuva_marts_enabled',False)))) | as_bool
   )
}}

select *
from {{ ref('outliers__int_member_months') }}
where member_id in (
  select distinct member_id
  from {{ ref('outliers__int_outlier_members') }}
  where outlier_flag = 'OUTLIER'
)