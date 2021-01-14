Constraints + CIS Admission Control (PSP) Benchmarks:
CIS Benchmark - Description - Gatekeeper Constraint
 5.2.1 - Minimize the admission of privileged containers
  - Satisfied by: privileged-containers
 5.2.2 - Minimize the admission of containers wishing to share the host process ID namespace
   - Satisfied by: host-namespaces (PID)
 5.2.3 - Minimize the admission of containers wishing to share the host IPC namespace
   - Satisfied by: host-namespaces (IPC)
 5.2.4 - Minimize the admission of containers wishing to share the host network namespace
  - Satisfied by: host-network-ports (host network + port control)
 5.2.5 - Minimize the admission of containers with allowPrivilegeEscalation
   - Satisfied by: allow-privilege-escalation-container
 5.2.6 - Minimize the admission of root containers
   - Satisfied by: users
 5.2.7 - Minimize the admission of containers with the NET_RAW capability
   - Satisfied by: capabilities (drop set to NET_RAW or ALL)
 5.2.8 - Minimize the admission of containers with added capabilities
   - Satisfied by: capability
 5.2.9 - Minimize the admission of containers with capabilities assigned
   - Satisfied by: capability (drop set to ALL)

Additonal CIS benchmarks satisfied:
 5.7.2 - Ensure that the seccomp profile is set to docker/default in your pod definitions
   - Satisfied by: seccomp (annotation set to docker/default)
5.7.3 - Apply Security Context to Your Pods and Containers
   - Satisifed by: Generally required by most of constraints for admission


Additional CIS benchmarks that could be satisfied with ConstraintTemplates:

5.1.3 Minimize wildcard use in Roles and ClusterRoles (Not Scored)
5.1.4 Minimize access to create pods (?)
5.1.6 Ensure that Service Account Tokens are only mounted where necessary
5.4.1 Prefer using secrets as files over secrets as environment variables
5.5.1 Configure Image Provenance using ImagePolicyWebhook admission controller

# References

[gatekeeper-library kustomize](https://github.com/open-policy-agent/gatekeeper-library) - This chart was created from this kustomize repo.
[helm-convert](https://github.com/ContainerSolutions/helm-convert) - Tool used to convert kustomize charts to helm
