
ports = { 'production' => "ey03-s00234:22122", "development" => "localhost:22122", "test" => "localhost:22122" }
STARLING = MemCache.new(ports[RAILS_ENV])
