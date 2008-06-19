class Log
  generator_for :level => 'info'
  generator_for :message => 'log message goes here'
  generator_for(:timestamp) { Time.zone.now }
end
