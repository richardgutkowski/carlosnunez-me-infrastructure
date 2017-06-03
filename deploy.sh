usage() {
  SUPPORTED_ENVIRONMENTS=$(find config -type f -name "infrastructure_config*" \
    -exec sh -c "echo {} | cut -f2-d '.'" \;`)
  print "deploy.sh [target_environment]\n"
  print "Deploys infrastructure for carlosnunez.me\n\n"
  print "\ttarget_environment: The environment to deploy onto. \
Supported environments: $SUPPORTED_ENVIRONMENTS"
}
