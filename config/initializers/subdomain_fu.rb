begin
  h=Object.const_get("SIMS_DOMAIN") 
rescue NameError
  h='example.com'
end
SubdomainFu.configure do |config|

size = h.split(".").length() -1

config.tld_sizes = {:development => 0,
                         :development_with_cache => 0,
                         :test => 1,
                         :production => size,
                         :staging => size,
                         :cucumber => 1
                         }
config.mirrors = 'www'
config.preferred_mirror = "www"
end
 
