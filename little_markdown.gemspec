Gem::Specification.new do |s|
  s.name = 'little_markdown'
  s.version = '0.1.0'
  s.summary = 'An experimental markdown parser for learning purposes.'
  s.authors = ['James Robertson']
  s.files = Dir["lib/little_markdown.rb"]
  s.add_runtime_dependency('rexle', '~> 1.6', '>=1.6.0') 
  s.signing_key = '../privatekeys/little_markdown.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/little_markdown'
end
