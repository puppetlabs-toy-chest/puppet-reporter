#
# import YAML Puppet report files as PuppetShow Report objects
#
# (run with script/runner)

raise ArgumentError, "A list of YAML report file names is required." if ARGV.blank? or ARGV[0].blank?
Log.delete_observers
Report.import_from_yaml_files(ARGV)
