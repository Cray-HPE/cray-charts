package istio.authz

# allow.http_status is 403 when the request is rejected due to the default allow.
# allow.http_status is not present the request is successful because the result is true.

# The JWTs here were created by going to https://jwt.io and modifying the
# sample JWT to have the necessary roles. Just paste the JWT into jwt.io to see
# what it looks like, and it can be modified there, too.

test_allow_bypassed_urls_with_no_auth_header {
  not allow.http_status with input as {"attributes": {"request": {"http": {"path": "/keycloak"}}}}
  not allow.http_status with input as {"attributes": {"request": {"http": {"path": "/vcs"}}}}
  not allow.http_status with input as {"attributes": {"request": {"http": {"path": "/repository"}}}}
  not allow.http_status with input as {"attributes": {"request": {"http": {"path": "/v2"}}}}
  not allow.http_status with input as {"attributes": {"request": {"http": {"path": "/service/rest"}}}}
  not allow.http_status with input as {"attributes": {"request": {"http": {"path": "/apis/tokens"}}}}
  not allow.http_status with input as {"attributes": {"request": {"http": {"path": "/capsules/"}}}}
}

test_deny_apis_with_no_auth_header {
  allow.http_status == 403 with input as {"attributes": {"request": {"http": {"path": "/apis/api1"}}}}
}

test_user_when_admin_required {
  allow.http_status == 403 with input as {"attributes": {"request": {"http": {"method": "GET", "path": "/apis/api1", "headers": {"authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJyZXNvdXJjZV9hY2Nlc3MiOnsic2hhc3RhIjp7InJvbGVzIjpbInVzZXIiXX19fQ.yrtzAbMtFWoPa9McMdlOZ-ruCkWFsTUgHl8cxUarmZg"}}}}}
}

test_user {
  not allow.http_status with input as {"attributes": {"request": {"http": {"method": "GET", "path": "/apis/uas-mgr/v1/", "headers": {"authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJyZXNvdXJjZV9hY2Nlc3MiOnsic2hhc3RhIjp7InJvbGVzIjpbInVzZXIiXX19fQ.yrtzAbMtFWoPa9McMdlOZ-ruCkWFsTUgHl8cxUarmZg"}}}}}
}

test_admin {
  not allow.http_status with input as {"attributes": {"request": {"http": {"method": "GET", "path": "/apis/api1", "headers": {"authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJyZXNvdXJjZV9hY2Nlc3MiOnsic2hhc3RhIjp7InJvbGVzIjpbImFkbWluIl19fX0.mh5XY026WvPNj9jGUelnRnlQ0OvSi7WjdAdl1G3M_9k"}}}}}
}

# Tests for system-pxe role

pxe_auth = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJyZXNvdXJjZV9hY2Nlc3MiOnsic2hhc3RhIjp7InJvbGVzIjpbInN5c3RlbS1weGUiXX19fQ.6zfb-i5Vs_emtNEH7EYGCmvqS2rihJAjjBaRHze1kZk"

bss_mock_path = "/apis/bss/mock"

test_pxe {

  # BSS - Allowed

  not allow.http_status with input as {"attributes": {"request": {"http": {"method": "GET", "path": bss_mock_path, "headers": {"authorization": pxe_auth}}}}}

  not allow.http_status with input as {"attributes": {"request": {"http": {"method": "HEAD", "path": bss_mock_path, "headers": {"authorization": pxe_auth}}}}}

  not allow.http_status with input as {"attributes": {"request": {"http": {"method": "POST", "path": bss_mock_path, "headers": {"authorization": pxe_auth}}}}}

  # BSS - Not Allowed

  allow.http_status == 403 with input as {"attributes": {"request": {"http": {"method": "PATCH", "path": bss_mock_path, "headers": {"authorization": pxe_auth}}}}}
}

# Tests for system-compute role

compute_auth = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJyZXNvdXJjZV9hY2Nlc3MiOnsic2hhc3RhIjp7InJvbGVzIjpbInN5c3RlbS1jb21wdXRlIl19fX0.jJOdd63VjLKF2TdGfSFWLKLPj1h_zzQSAiOB1pE393g"

cfs_mock_path = "/apis/cfs/mock"
cps_mock_path = "/apis/v2/cps/mock"
hbtb_mock_path = "/apis/hbtd/mock"
nmd_mock_path = "/apis/v2/nmd/mock"
smd_mock_path = "/apis/smd/mock"
hmnfd_mock_path = "/apis/hmnfd/mock"
pals_mock_path = "/apis/pals/v1/mock"

test_compute {

  # CFS - Allowed

  not allow.http_status with input as {"attributes": {"request": {"http": {"method": "GET", "path": cfs_mock_path, "headers": {"authorization": compute_auth}}}}}

  not allow.http_status with input as {"attributes": {"request": {"http": {"method": "HEAD", "path": cfs_mock_path, "headers": {"authorization": compute_auth}}}}}

  not allow.http_status with input as {"attributes": {"request": {"http": {"method": "PATCH", "path": cfs_mock_path, "headers": {"authorization": compute_auth}}}}}

  # CFS - Not Allowed

  allow.http_status == 403 with input as {"attributes": {"request": {"http": {"method": "POST", "path": cfs_mock_path, "headers": {"authorization": compute_auth}}}}}

  # CPS - Allowed

  not allow.http_status with input as {"attributes": {"request": {"http": {"method": "GET", "path": cps_mock_path, "headers": {"authorization": compute_auth}}}}}

  not allow.http_status with input as {"attributes": {"request": {"http": {"method": "HEAD", "path": cps_mock_path, "headers": {"authorization": compute_auth}}}}}

  # CPS - Not Allowed

  allow.http_status == 403 with input as {"attributes": {"request": {"http": {"method": "POST", "path": cps_mock_path, "headers": {"authorization": compute_auth}}}}}

  # HBTB - Allowed

  not allow.http_status with input as {"attributes": {"request": {"http": {"method": "GET", "path": hbtb_mock_path, "headers": {"authorization": compute_auth}}}}}

  not allow.http_status with input as {"attributes": {"request": {"http": {"method": "HEAD", "path": hbtb_mock_path, "headers": {"authorization": compute_auth}}}}}

  not allow.http_status with input as {"attributes": {"request": {"http": {"method": "POST", "path": hbtb_mock_path, "headers": {"authorization": compute_auth}}}}}

  # HBTB - Not Allowed

  allow.http_status == 403 with input as {"attributes": {"request": {"http": {"method": "PATCH", "path": hbtb_mock_path, "headers": {"authorization": compute_auth}}}}}

  # NMD - Allowed

  not allow.http_status with input as {"attributes": {"request": {"http": {"method": "GET", "path": nmd_mock_path, "headers": {"authorization": compute_auth}}}}}

  not allow.http_status with input as {"attributes": {"request": {"http": {"method": "HEAD", "path": nmd_mock_path, "headers": {"authorization": compute_auth}}}}}

  not allow.http_status with input as {"attributes": {"request": {"http": {"method": "POST", "path": nmd_mock_path, "headers": {"authorization": compute_auth}}}}}

  not allow.http_status with input as {"attributes": {"request": {"http": {"method": "PUT", "path": nmd_mock_path, "headers": {"authorization": compute_auth}}}}}

  # NMD - Not Allowed

  allow.http_status == 403 with input as {"attributes": {"request": {"http": {"method": "PATCH", "path": nmd_mock_path, "headers": {"authorization": compute_auth}}}}}

  # SMD - Allowed

  not allow.http_status with input as {"attributes": {"request": {"http": {"method": "GET", "path": smd_mock_path, "headers": {"authorization": compute_auth}}}}}

  not allow.http_status with input as {"attributes": {"request": {"http": {"method": "HEAD", "path": smd_mock_path, "headers": {"authorization": compute_auth}}}}}

  # SMD - Not Allowed

  allow.http_status == 403 with input as {"attributes": {"request": {"http": {"method": "POST", "path": smd_mock_path, "headers": {"authorization": compute_auth}}}}}

  # HMNFD - Allowed

  not allow.http_status with input as {"attributes": {"request": {"http": {"method": "GET", "path": hmnfd_mock_path, "headers": {"authorization": compute_auth}}}}}

  not allow.http_status with input as {"attributes": {"request": {"http": {"method": "HEAD", "path": hmnfd_mock_path, "headers": {"authorization": compute_auth}}}}}

  not allow.http_status with input as {"attributes": {"request": {"http": {"method": "PATCH", "path": hmnfd_mock_path, "headers": {"authorization": compute_auth}}}}}

  not allow.http_status with input as {"attributes": {"request": {"http": {"method": "POST", "path": hmnfd_mock_path, "headers": {"authorization": compute_auth}}}}}

  not allow.http_status with input as {"attributes": {"request": {"http": {"method": "DELETE", "path": hmnfd_mock_path, "headers": {"authorization": compute_auth}}}}}

  # HMNFD - Not Allowed

  allow.http_status == 403 with input as {"attributes": {"request": {"http": {"method": "TRACE", "path": hmnfd_mock_path, "headers": {"authorization": compute_auth}}}}}

}

# Tests for unauthorized role for any policy (maps to shasta role 'invalid-role')

unauthorized_role_auth = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJyZXNvdXJjZV9hY2Nlc3MiOnsic2hhc3RhIjp7InJvbGVzIjpbImludmFsaWQtcm9sZSJdfX19.OTaNI4VZoSB1NnKtdzunJFyGhGzs36XkNkpAqJOzKQc"

test_unauth_role {

  allow.http_status == 403 with input as {"attributes": {"request": {"http": {"method": "POST", "path": pals_mock_path, "headers": {"authorization": unauthorized_role_auth}}}}}

}