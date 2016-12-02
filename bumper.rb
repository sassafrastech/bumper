#!/usr/bin/env ruby
require_relative "lib/bumper"

exec("git checkout develop") unless `git rev-parse --abbrev-ref HEAD` == "develop\n"
commit_and_merge(do_increment(ARGV[0]))
do_deploy(ARGV[1]) if ARGV[1]
