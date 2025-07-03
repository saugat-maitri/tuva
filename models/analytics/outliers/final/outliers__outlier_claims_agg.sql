{{ config(
     enabled = var('analytics_enabled',var('claims_enabled',var('clinical_enabled',var('tuva_marts_enabled',False)))) | as_bool
   )
}}

select
    aca.claim_type
  , aca.member_id
  , aca.incr_month
  , aca.incr_year
  , aca.dx_code
  , aca.dx_description
  , aca.dx_ccsr_category1
  , aca.dx_ccsr_category2
  , aca.encounter_id
  , aca.encounter_type
  , aca.encounter_group
  , aca.service_category_1
  , aca.service_category_2
  , aca.service_category_3
  , aca.ms_drg_code
  , aca.ms_drg_description
  , aca.apr_drg_code
  , aca.apr_drg_description
  , aca.revenue_center_code
  , aca.revenue_center_description
  , aca.hcpcs_code
  , aca.rbcs_cat_desc
  , aca.rbcs_subcat_desc
  , aca.rbcs_family_desc
  , aca.paid_amount
  , om.total_paid
  , om.outlier_threshold
  , om.total_members
from {{ ref('outliers__int_all_claims_agg') }} aca
inner join {{ ref('outliers__int_outlier_members') }} om
  on aca.member_id = om.member_id
  and aca.incr_year = om.incr_year
where om.outlier_flag = 'OUTLIER'