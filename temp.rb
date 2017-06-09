#!/usr/bin/env ruby
  `./terraform plan -state=no_state_for_testing -out=terraform.tfplan > /dev/null;  \
      [ -f terraform.tfplan ] && tfjson terraform.tfplan`
