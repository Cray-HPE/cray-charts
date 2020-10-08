# Change Log

Changes to the `cray-certmanager` chart, indexed by semantic versions.

##v0.2.0:

- Upgrade cert-manager to v0.14.1.
- Remove setup of self-signed ClusterIssuer. See the ``cray-certmanager-issuers`` chart for issuer deployment.
- Updated non-legacy cert-manager CRD due to use of custom webhook service name (see values.yaml)

##v0.1.0:

- Initial release
- Install cert-manager v0.9.1.
- Setup self-signed ClusterIssuer. 