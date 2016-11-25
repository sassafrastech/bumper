#!/usr/bin/env ruby
# Version bump and deploy script
# Usage:
#   bumper.rb <increment-type-or-explicit-version> <deploy-env>
#
# Examples:
#   bumper.rb micro production   # Increment micro version and deploy to production
#   bumper.rb minor              # Increment minor version but don't deploy
#   bumper.rb 2.13p production   # Set version to v2.13p (don't include)
#
# Assumptions:
# * Deploy branch has same name as deploy env, except assumes `master` for `production`
# * Development branch is called `develop`
# * Changes requiring deploy live on `develop`
# * Version stored in VERSION file in project root
# * Deployment via capistrano
#
# Results:
# * Sets VERSION to updated version (version in VERSION file does not have leading `v`)
# * Creates and pushes new tag of form `vX.Y.Z`

INCTYPES = %w(major minor micro)

def do_increment(inctype_or_version)
  if inctype_or_version =~ /\d\.\d/
    version = inctype_or_version
  else
    version = increment(current_version, inctype_or_version)
  end
  write_version(version)
  version
end

def current_version
  File.read("VERSION")
end

def increment(version, type)
  chunks = version.split(".").map(&:to_i)
  abort("Invalid increment type #{type}") unless idx = INCTYPES.index(type)
  chunks[idx] = (chunks[idx] || 0) + 1
  chunks.join(".")
end

def write_version(version)
  File.open("VERSION", "w") { |f| f.write("#{version}\n") }
end

def commit_and_merge(version)
  exec("git commit -a -m 'Bumped version to #{version}'")
  exec("git tag -a v#{version} -m v#{version}")
  exec("git push --tags")
end

def do_deploy(env)
  branch = env == "production" ? "master" : env
  exec("git checkout #{branch}")
  exec("git merge develop")
  exec("git push")
  exec("cap #{env} deploy")
end

exec("git checkout develop") unless `git rev-parse --abbrev-ref HEAD` == "develop\n"
commit_and_merge(do_increment(ARGV[0]))
do_deploy(ARGV[1])
