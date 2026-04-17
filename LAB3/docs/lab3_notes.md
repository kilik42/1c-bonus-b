# LAB3 Notes

## Option A Adaptation
For project continuity, the existing us-west-2 stack is treated conceptually as the Tokyo / primary data-authority side.

This preserves the intended architecture pattern without rebuilding the full primary stack in ap-northeast-1.

## Secondary Region
The São Paulo region was built as the secondary compute side of the architecture.

## Main Technical Challenge
The most important technical objective in LAB3A was creating a private multi-region corridor using:
- regional TGWs
- TGW peering
- bidirectional routing

## Key Outcome
The architecture now supports private backbone connectivity between the primary and secondary regional environments.