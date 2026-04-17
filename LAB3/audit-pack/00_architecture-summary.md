# LAB3A Architecture Summary

## Purpose
LAB3A extends the prior single-region application into a multi-region architecture pattern.

The primary region functions as the logical Tokyo/data-authority side of the system, while São Paulo functions as the secondary compute region.

## Architecture Pattern
Primary VPC -> Primary Transit Gateway -> TGW Peering -> São Paulo Transit Gateway -> São Paulo VPC

## Key Design Principle
Application compute can expand into another region, but the primary/data-authority side remains centralized.

This models a common enterprise pattern where:
- data residency and authority remain in the primary region
- secondary regions host stateless or semi-stateless compute
- private AWS backbone connectivity is used instead of public internet paths

## Components Built
- Primary-region Transit Gateway
- Primary VPC attachment
- São Paulo Transit Gateway
- São Paulo VPC attachment
- Cross-region TGW peering attachment
- Bidirectional TGW routing between VPC CIDRs
- São Paulo application-side network, ALB, and app tier foundation

## Validation Results
Validation confirmed:
- both TGWs exist
- both VPC attachments are available
- TGW peering is available
- primary route to São Paulo exists
- secondary route to primary exists

## Why This Matters
This lab demonstrates:
- multi-region AWS networking
- private inter-region connectivity
- distributed systems architecture thinking
- separation of compute expansion from centralized data authority