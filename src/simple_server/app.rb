require 'sinatra'
require 'json'
require 'securerandom'

$twelve = [
  'Codebase: One codebase tracked in revision control, many deploys',
  'Dependencies: Explicitly declare and isolate dependencies',
  'Config: Store config in the environment',
  'Backing Services: Treat backing services as attached resources',
  'Build, release, run: Strictly separate build and run stages',
  'Processes: Execute the app as one or more stateless processes',
  'Port binding: Export services via port binding',
  'Concurrency: Scale out via the process model',
  'Disposability: Maximize robustness with fast startup and graceful shutdown',
  'Dev/prod parity: Keep development, staging, and production as similar as possible',
  'Logs: Treat logs as event streams',
  'Admin processes: Run admin/management tasks as one-off processes'
]

get '/:id' do |n|
  i = begin
    n.to_i - 1
  rescue
    0
  end

  $twelve[i]
end

get '/' do
  $twelve.join("\r\n")
end

get '/kill' do
  Process.kill 'TERM', Process.pid
end
