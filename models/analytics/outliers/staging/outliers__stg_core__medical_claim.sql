{{ config(
     enabled = var('analytics_enabled',var('claims_enabled',var('clinical_enabled',var('tuva_marts_enabled',False)))) | as_bool
   )
}}

select
    claim_id
  , claim_line_number
  , claim_type
  , person_id
  , member_id
  , claim_start_date as incr_date
  , paid_date
  , cast({{ date_part("month", "claim_start_date") }} as {{ dbt.type_string() }}) as incr_month
  , cast({{ date_part("month", "paid_date") }} as {{ dbt.type_string() }}) as paid_month
  , cast({{ date_part("year", "claim_start_date") }} as {{ dbt.type_string() }}) as incr_year
  , cast({{ date_part("year", "paid_date") }} as {{ dbt.type_string() }}) as paid_year
  , encounter_id
  , encounter_type
  , encounter_group
  , service_category_1
  , service_category_2
  , service_category_3
  , case when drg_code_type = 'ms-drg' then drg_code end as ms_drg_code
  , case when drg_code_type = 'ms-drg' then drg_description end as ms_drg_description
  , case when drg_code_type = 'apr-drg' then drg_code end as apr_drg_code
  , case when drg_code_type = 'apr-drg' then drg_description end as apr_drg_description
  , revenue_center_code
  , revenue_center_description
  , hcpcs_code
  , paid_amount
  , rendering_id
from {{ ref('core__medical_claim') }}
