_ = system('/usr/bin/env sh -c "./terraform plan -state=no_state_for_testing \
                                      -out=terraform.tfplan > /dev/null"')
