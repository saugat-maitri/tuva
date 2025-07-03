{{ config(
     enabled = var('analytics_enabled',var('claims_enabled',var('clinical_enabled',var('tuva_marts_enabled',False)))) | as_bool
   )
}}

select
    claim_id
  , claim_line_number
  , person_id
  , member_id
  , dispensing_date
  , paid_date
  , cast({{ date_part("month", "dispensing_date") }} as {{ dbt.type_string() }}) as incr_month
  , cast({{ date_part("month", "paid_date") }} as {{ dbt.type_string() }}) as paid_month
  , cast({{ date_part("year", "dispensing_date") }} as {{ dbt.type_string() }}) as incr_year
  , cast({{ date_part("year", "paid_date") }} as {{ dbt.type_string() }}) as paid_year
  , ndc_code
  , ndc_description
  , quantity
  , days_supply
  , refills
  , paid_amount
  , prescribing_provider_id as prescriber_npi
  , dispensing_provider_id as dispensing_npi
from {{ ref('core__pharmacy_claim') }}
