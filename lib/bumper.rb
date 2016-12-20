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
  File.read("VERSION").gsub(/\Av/, "") # Remove leading 'v' if present
end

def increment(version, type)
  chunks = version.split(".").map(&:to_i)
  abort("Invalid increment type #{type}") unless idx = INCTYPES.index(type)
  (chunks.size..2).each { |i| chunks[i] = 0 }
  chunks[idx] += 1
  ((idx + 1)...chunks.size).each { |i| chunks[i] = 0 }
  chunks.pop if chunks.last == 0
  chunks.join(".")
end

def write_version(version)
  File.open("VERSION", "w") { |f| f.write("#{version}\n") }
end

def commit_and_merge(version)
  system("git commit -a -m 'Bumped version to #{version}'")
  system("git tag -a v#{version} -m v#{version}")
  system("git push && git push --tags")
end

def do_deploy(env)
  branch = env == "production" ? "master" : env
  system("git checkout #{branch}")
  system("git merge develop")
  system("git push")
  system("cap #{env} deploy#{capistrano_version == 2 ? ":migrations" : ""}")
end

def capistrano_version
  matches = `cap --version`.match(/v(\d+)/)
  matches.nil? ? nil : matches[1].to_i
end
