# terraform-aws-icon-dns-setup

A terraform module to create hosted zones in AWS Route 53 for your deployed region.
This module will create a hosted zone for:

- Your root domain (example.xyz)
- The deployed region (us-east-1.example.xyz)

You should use the deployed region zone ID for adding further records.

## Inputs

- root_domain_name: The root domain of your Route 53 hosted zone
- region: The region where the instances are hosted

## Outputs

- zone_id: The zone ID for the deployed region Route 53 hosted zone
