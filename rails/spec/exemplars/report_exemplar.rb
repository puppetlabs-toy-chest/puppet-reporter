class Report
  generator_for(:timestamp) { Time.zone.now }
  generator_for(:details) { '--- !ruby/object:Puppet::Transaction::Report 
    host: phage.madstop.com
    logs: 
      - !ruby/object:Puppet::Util::Log 
        level: :err
        message: "Failed to retrieve current state of resource: cannot convert nil into String"
        objectsource: true
        source: //basenode/puppetclient/remotefile[/etc/puppet/puppet.conf]/File[/etc/puppet/puppet.conf]
        tags: 
          - :basenode
          - :main
          - :puppetclient
          - :remotefile
          - :file
          - :source
        time: 2007-05-31 17:05:52.188748 -05:00
      - !ruby/object:Puppet::Util::Log 
        level: :notice
        message: executed successfully
        objectsource: true
        source: //basenode/os::darwin/Exec[/bin/echo yaytest]/returns
        tags: 
          - :basenode
          - :main
          - :os::darwin
          - :exec
          - :testing
          - :returns
        time: 2007-05-31 17:05:53.698169 -05:00
    metrics: 
      time: !ruby/object:Puppet::Util::Metric 
        label: Time
        name: time
        values: 
          - 
            - :filebucket
            - Filebucket
            - 0.000102043151855469
          - 
            - :notify
            - Notify
            - 0.000590801239013672
          - 
            - :total
            - Total
            - 2.97548842430115
          - 
            - :exec
            - Exec
            - 0.011544942855835
          - 
            - :schedule
            - Schedule
            - 0.000103950500488281
          - 
            - :config_retrieval
            - Config retrieval
            - 0.150889158248901
          - 
            - :user
            - User
            - 0.124068021774292
          - 
            - :file
            - File
            - 2.68818950653076
      resources: !ruby/object:Puppet::Util::Metric 
        label: Resources
        name: resources
        values: 
          - 
            - :restarted
            - Restarted
            - 0
          - 
            - :applied
            - Applied
            - 1
          - 
            - :failed_restarts
            - Failed restarts
            - 0
          - 
            - :total
            - Total
            - 29
          - 
            - :skipped
            - Skipped
            - 0
          - 
            - :failed
            - Failed
            - 1
          - 
            - :scheduled
            - Scheduled
            - 23
          - 
            - :out_of_sync
            - Out of sync
            - 2
      changes: !ruby/object:Puppet::Util::Metric 
        label: Changes
        name: changes
        values: 
          - 
            - :total
            - Total
            - 2
    records: {}
    time: 2007-05-31 17:05:53.824906 -05:00
    '
  }
end
