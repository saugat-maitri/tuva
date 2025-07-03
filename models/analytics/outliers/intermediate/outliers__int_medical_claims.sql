{{ config(
     enabled = var('analytics_enabled',var('claims_enabled',var('clinical_enabled',var('tuva_marts_enabled',False)))) | as_bool
   )
}}

select
    clm.claim_id
  , clm.claim_line_number
  , clm.claim_type
  , clm.person_id
  , clm.member_id
  , clm.incr_date
  , clm.paid_date
  , clm.incr_month
  , clm.paid_month
  , clm.incr_year
  , clm.paid_year
  , ccsr.normalized_code as dx_code
  , ccsr.code_description as dx_description
  , ccsr.body_system as dx_ccsr_category1
  , ccsr.ccsr_category_description as dx_ccsr_category2
  , clm.encounter_id
  , clm.encounter_type
  , clm.encounter_group
  , clm.service_category_1
  , clm.service_category_2
  , clm.service_category_3
  , clm.ms_drg_code
  , clm.ms_drg_description
  , clm.apr_drg_code
  , clm.apr_drg_description
  , clm.revenue_center_code
  , clm.revenue_center_description
  , clm.hcpcs_code
  , rbcs_cat_desc
  , rbcs_subcat_desc
  , rbcs_family_desc
  , clm.paid_amount
  , clm.rendering_id
from {{ ref('outliers__stg_core__medical_claim') }} clm
left join {{ ref('ccsr__long_condition_category') }} ccsr
  on clm.claim_id = ccsr.claim_id
 and clm.person_id = ccsr.person_id
left join {{ ref('terminology__hcpcs_to_rbcs') }} rbcs
  on clm.hcpcs_code = rbcs.hcpcs_cd
 and rbcs.current_flag = 1
where ccsr.condition_rank = 1
  and ccsr.ccsr_category_rank = 1