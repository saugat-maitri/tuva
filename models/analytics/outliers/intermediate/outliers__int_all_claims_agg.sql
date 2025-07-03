{{ config(
     enabled = var('analytics_enabled',var('claims_enabled',var('clinical_enabled',var('tuva_marts_enabled',False)))) | as_bool
   )
}}

with all_claims as (
  select 
      claim_id
    , claim_line_number
    , claim_type
    , person_id
    , member_id
    , incr_date
    , paid_date
    , cast({{ date_part("month", "incr_date") }} as {{ dbt.type_string() }}) as incr_month
    , cast({{ date_part("month", "paid_date") }} as {{ dbt.type_string() }}) as paid_month
    , cast({{ date_part("year", "incr_date") }} as {{ dbt.type_string() }}) as incr_year
    , cast({{ date_part("year", "paid_date") }} as {{ dbt.type_string() }}) as paid_year
    , paid_amount
    , dx_code
    , dx_description
    , dx_ccsr_category1
    , dx_ccsr_category2
    , encounter_id
    , encounter_type
    , encounter_group
    , service_category_1
    , service_category_2
    , service_category_3
    , ms_drg_code
    , ms_drg_description
    , apr_drg_code
    , apr_drg_description
    , revenue_center_code
    , revenue_center_description
    , hcpcs_code
    , rbcs_cat_desc
    , rbcs_subcat_desc
    , rbcs_family_desc
    , rendering_id
    , null as ndc_code
    , null as ndc_description
    , null as quantity
    , null as days_supply
    , null as refills
    , null as prescriber_npi
    , null as dispensing_npi
    , null as rx_norm_code
    , null as rxnorm_description
    , null as atc_1_code
    , null as atc_1_name
    , null as atc_2_code
    , null as atc_2_name
    , null as atc_3_code
    , null as atc_3_name
    , null as atc_4_code
    , null as atc_4_name
  from {{ ref('outliers__stg_medical_claims') }}

  union all

  select 
      claim_id
    , claim_line_number
    , claim_type
    , person_id
    , member_id
    , incr_date
    , paid_date
    , cast({{ date_part("month", "incr_date") }} as {{ dbt.type_string() }}) as incr_month
    , cast({{ date_part("month", "paid_date") }} as {{ dbt.type_string() }}) as paid_month
    , cast({{ date_part("year", "incr_date") }} as {{ dbt.type_string() }}) as incr_year
    , cast({{ date_part("year", "paid_date") }} as {{ dbt.type_string() }}) as paid_year
    , paid_amount
    , null as dx_code
    , null as dx_description
    , null as dx_ccsr_category1
    , null as dx_ccsr_category2
    , null as encounter_id
    , null as encounter_type
    , null as encounter_group
    , null as service_category_1
    , null as service_category_2
    , null as service_category_3
    , null as ms_drg_code
    , null as ms_drg_description
    , null as apr_drg_code
    , null as apr_drg_description
    , null as revenue_center_code
    , null as revenue_center_description
    , null as hcpcs_code
    , null as rbcs_cat_desc
    , null as rbcs_subcat_desc
    , null as rbcs_family_desc
    , null as rendering_id
    , ndc_code
    , ndc_description
    , quantity
    , days_supply
    , refills
    , prescriber_npi
    , dispensing_npi
    , rx_norm_code
    , rxnorm_description
    , atc_1_code
    , atc_1_name
    , atc_2_code
    , atc_2_name
    , atc_3_code
    , atc_3_name
    , atc_4_code
    , atc_4_name
  from {{ ref('outliers__stg_rx_claims') }}
)

select
    claim_type
  , member_id
  , incr_month
  , incr_year
  , dx_code
  , dx_description
  , dx_ccsr_category1
  , dx_ccsr_category2
  , encounter_id
  , encounter_type
  , encounter_group
  , service_category_1
  , service_category_2
  , service_category_3
  , ms_drg_code
  , ms_drg_description
  , apr_drg_code
  , apr_drg_description
  , revenue_center_code
  , revenue_center_description
  , hcpcs_code
  , rbcs_cat_desc
  , rbcs_subcat_desc
  , rbcs_family_desc
  , sum(paid_amount) as paid_amount
from all_claims
group by
    claim_type
  , member_id
  , incr_month
  , incr_year
  , dx_code
  , dx_description
  , dx_ccsr_category1
  , dx_ccsr_category2
  , encounter_id
  , encounter_type
  , encounter_group
  , service_category_1
  , service_category_2
  , service_category_3
  , ms_drg_code
  , ms_drg_description
  , apr_drg_code
  , apr_drg_description
  , revenue_center_code
  , revenue_center_description
  , hcpcs_code
  , rbcs_cat_desc
  , rbcs_subcat_desc
  , rbcs_family_desc
