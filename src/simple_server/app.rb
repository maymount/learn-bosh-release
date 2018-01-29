require 'sinatra'
require 'json'

# From https://12factor.net/

$rules = [
  "Codebase: One codebase tracked in revision control, many deploys",
  "Dependencies: Explicitly declare and isolate dependencies",
  "Config: Store config in the environment",
  "Backing Services: Treat backing services as attached resources",
  "Build, release, run: Strictly separate build and run stages",
  "Processes: Execute the app as one or more stateless processes",
  "Port binding: Export services via port binding",
  "Concurrency: Scale out via the process model",
  "Disposability: Maximize robustness with fast startup and graceful shutdown",
  "Dev/prod parity: Keep development, staging, and production as similar as possible",
  "Logs: Treat logs as event streams",
  "Admin processes: Run admin/management tasks as one-off processes"
]

def all_rules
  s = []
  $rules.each_with_index { |t, n| s << "#{n+1}: #{t}" }
  s.join("\r\n")
end

def get_rule(n)
  i = Integer(n) - 1
  if i >= 0 && i < $rules.length
    $rules[i]
  else
    'Not a rule'
  end
rescue => ex
  r = ["Huh?  #{n.inspect} is invalid", ex.to_s]
  ex.backtrace.each { |x| r << x}
  r.join("\r\n")
end

get '/kill' do
  Process.kill 'TERM', Process.pid
end

get '/:id' do |n|
  get_rule(n)
end

get '/' do
  all_rules
end
