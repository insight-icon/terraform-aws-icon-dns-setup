# terraform-aws-icon-dns-setup

A terraform module to create hosted zones in AWS Route 53 for your deployed region.
This module will create a hosted zone for:

- Public subdomain off your root domain (example.xyz)
    - <region>.<environment>.<root domain>
    - ie `us-east-1.dev.insight-icon.net`
- Private domain off support VPC 
    - ie `icon.internal`
- Private subdomain of tld domain 
    - Same scheme with root domain as private internal domain 
    - ie `us-east-1.dev.icon.internal`

You should use the deployed region zone ID for adding further records.

## Inputs

- root_domain_name: The root domain of your Route 53 hosted zone
- internal_domain_name: The internal domain name, totally arbitrary, ie `takemedown.tofunkytown.wtf`

## Outputs

- public_zone_id: The zone ID for the deployed regional public zone Route 53 hosted zone
- private_zone_id: The zone ID for the deployed regional private zone Route 53 hosted zone