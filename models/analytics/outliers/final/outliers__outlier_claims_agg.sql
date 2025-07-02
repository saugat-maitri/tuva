{{ config(
     enabled = var('analytics_enabled',var('claims_enabled',var('clinical_enabled',var('tuva_marts_enabled',False)))) | as_bool
   )
}}

select
  aca.*,
  om.total_paid,
  om.outlier_threshold,
  om.total_members
from {{ ref('outliers__int_all_claims_agg') }} aca
inner join {{ ref('outliers__int_outlier_members') }} om
  on aca.member_id = om.member_id
  and aca.incr_year = om.incr_year
where om.outlier_flag = 'OUTLIER'