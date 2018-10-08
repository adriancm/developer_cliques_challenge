Gem::Specification.new do |s|
  s.name        = 'developer_cliques'
  s.version     = '0.5.0'
  s.executables << 'devcliques'
  s.date        = '2018-10-04'
  s.summary     = 'Calculates maximal cliques from developers social connections'
  s.description = 'Calculates maximal cliques from developers social connections'
  s.authors     = ['Adrián Cepillo']
  s.email       = 'adrian.cepillo@gmail.com'
  s.files       = Dir['lib/*', 'lib/*/*', 'config/*']
  s.homepage    = 'http://rubygems.org/gems/developer_cliques'
  s.license     = 'MIT'
  s.add_runtime_dependency 'octokit', '~>4.0'
  s.add_runtime_dependency 'twitter', '~>6.0'
  s.add_runtime_dependency 'dotenv', '~>2.0'
end