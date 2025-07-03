{{ config(
     enabled = var('analytics_enabled',var('claims_enabled',var('clinical_enabled',var('tuva_marts_enabled',False)))) | as_bool
   )
}}

select
    rx.claim_id
  , rx.claim_line_number
  , 'PHARMACY' as claim_type
  , rx.person_id
  , rx.member_id
  , rx.dispensing_date as incr_date
  , rx.paid_date
  , cast({{ date_part("month", "rx.dispensing_date") }} as {{ dbt.type_string() }}) as incr_month
  , cast({{ date_part("month", "rx.paid_date") }} as {{ dbt.type_string() }}) as paid_month
  , cast({{ date_part("year", "rx.dispensing_date") }} as {{ dbt.type_string() }}) as incr_year
  , cast({{ date_part("year", "rx.paid_date") }} as {{ dbt.type_string() }}) as paid_year
  , rx.ndc_code
  , rx.ndc_description
  , rx.quantity
  , rx.days_supply
  , rx.refills
  , rx.paid_amount
  , rx.prescribing_provider_id as prescriber_npi
  , rx.dispensing_provider_id as dispensing_npi
  , rx2.rxcui as rx_norm_code
  , atc.rxnorm_description as rxnorm_description
  , atc.atc_1_code
  , atc.atc_1_name
  , atc.atc_2_code
  , atc.atc_2_name
  , atc.atc_3_code
  , atc.atc_3_name
  , atc.atc_4_code
  , atc.atc_4_name
from {{ ref('core__pharmacy_claim') }} rx
left join {{ ref('pharmacy__pharmacy_claim_expanded') }} rx2
  on rx.claim_id = rx2.claim_id
 and rx.claim_line_number = rx2.claim_line_number
left join {{ ref('terminology__rxnorm_to_atc') }} atc
  on rx2.rxcui = atc.rxcui