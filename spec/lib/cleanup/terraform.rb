def cleanup_terraform_residue!
  [ './dummy_state', './terraform_fixture.tfplan' ].each do |file|
    if File.exist? file
      `rm #{file}`
    end
  end
end
