SETUP_DIR=/Users/rick/git/
THIS_DIR=${SETUP_DIR}/puppetshow
PATH=$PATH:$SETUP_DIR/facter/bin:$SETUP_DIR/puppet/bin
RUBYLIB=$SETUP_DIR/facter/lib:$SETUP_DIR/puppet/lib
export PATH RUBYLIB

cd ${SETUP_DIR}/puppet	  # wherever the puppet checkout is

# install our custom report
cp ${THIS_DIR}/report-scripts/inspect.rb ${SETUP_DIR}/puppet/lib/puppet/reports/

# kill off any old processes
ps auxwww | grep pup[p]etmaster | awk '{print $2}' | xargs sudo kill
ps auxwww | grep pup[p]etd | awk '{print $2}' | xargs sudo kill
sleep 1
ps auxwww | grep pup[p]etmaster | awk '{print $2}' | xargs sudo kill -9
ps auxwww | grep pup[p]etd | awk '{print $2}' | xargs sudo kill -9

# clean up from any previous runs
sudo rm -rf /tmp/puppet

# make confdir and vardir
mkdir -p /tmp/puppet/var

# make sure we have a trivial manifest installed
mkdir -p /tmp/puppet/manifests
echo "node default { }" > /tmp/puppet/manifests/site.pp

# startup a puppetmasterd instance
sudo puppetmasterd --vardir /tmp/puppet/var --confdir /tmp/puppet --user rick --group staff --debug --trace --reports=store,inspect

# initial start of puppetd for cert shit
sudo puppetd --no-http_enable_post_connection_check --vardir /tmp/puppet/var --confdir /tmp/puppet/ --user rick --group staff --debug --trace -t --report --server localhost --waitforcert 60

# get the cert bullshit right
sudo puppetca --clean rick-bradleys-computer.local --user rick --group staff --confdir /tmp/puppet/ --vardir /tmp/puppet/var --sign all

# and attempt to run puppet, generate a report
sudo puppetd --no-http_enable_post_connection_check --vardir /tmp/puppet/var --confdir /tmp/puppet/ --user rick --group staff --debug --trace -t --report --server localhost --noop --onetime

# what's in the reports dir?
ls -altrR /tmp/puppet/var/reports/
ls -tr /tmp/puppet/var/reports/*/ | tail -1 | sed 's:^:sudo cat /tmp/puppet/var/reports/*/:' | sh -s

cat /tmp/bullshit.txt
