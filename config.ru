require ::File.expand_path '../config/environment',  __FILE__

if defined? Unicorn
  require 'unicorn/worker_killer'

  use Unicorn::WorkerKiller::Oom, 256 * (1024**2), 384 * (1024**2), 16, true
end

run Rails.application
