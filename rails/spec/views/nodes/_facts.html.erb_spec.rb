require File.dirname(__FILE__) + '/../../spec_helper'

describe '/nodes/_facts.html.erb' do
  before :each do
    @node = Node.new(:name => 'foo')
    @facts = { :operatingsystem => 'Darwin' }
    @node.stubs(:details).returns(@facts)
  end

  def do_render
    render :partial => '/nodes/facts', :locals => { :facts => @facts }
  end

  it 'should include the operatingsystem fact' do
    do_render
    response.should have_text(Regexp.new(@facts[:operatingsystem]))
  end
end

__END__

<!-- SAMPLE FACT DATA:
	
	sp_serial_number: 4H633244U9B
  kernel: Darwin
  macosx_productname: Mac OS X
  sp_current_processor_speed: 1.83 GHz
  sp_smc_version: 1.4f12
  hardwaremodel: i386
  sp_boot_rom_version: MB11.0061.B03
  rubysitedir: /opt/local/lib/ruby/site_ruby/1.8
  operatingsystemrelease: 8.11.1
  sp_os_version: Mac OS X 10.4.11 (8S2167)
  sp_kernel_version: Darwin 8.11.1
  ipaddress: 70.148.117.116
  ps: ps -auxwww
  kernelrelease: 8.11.1
  macosx_productversion: 10.4.11
  fqdn: adsl-070-148-117-116.sip.bna.bellsouth.net
  sp_packages: 1
  domain: sip.bna.bellsouth.net
  macosx_buildversion: 8S2167
  sp_l2_cache_share: 2 MB
  sp_machine_name: MacBook
  sp_boot_volume: Macintosh HD
  sp_local_host_name: Yer Mom's Computer
  :_timestamp: 2008-06-11 15:44:35.348053 -05:00
  sp_bus_speed: 667 MHz
  sshrsakey: AAAAB3NzaC1yc2EAAAABIwAAAQEAyFJQndn+o8x8pPNdOj3le5WBYpV51U7X9xBChs7Jz70O/nsXOSI9FUQmCBMDuEYal36DCRipPeiCHxFMRdkFqUL9clCMDvtyp93yrmp7JIQ852M2+sRSJRVdiir8JVSoaZyMEdn3pH8MKQ9DdzsAF4jEhHGJUAwq/TxJ4YGyZ2VXrBEHwJr4/06DkPClRu+77VPfzSDipfDjDeEiRbTc777Z5Ebnc6eoIMFPcoWN6d/zyXTkTrYLvFs3+pvfct2j4fDppbHj0pqNtLJa71sqrirBU1Bt/1DUDnmOLLI3pjguo4i5qkvkY/NOkhZYhf84zfvlMC+NQiX26VJCjh7KGw==
  sp_physical_memory: 2 GB
  sp_user_name: Rick Bradley (rick)
  hostname: adsl-070-148-117-116
  sp_cpu_type: Intel Core Duo
  puppetversion: 0.24.4
  sp_machine_model: MacBook1,1
  interfaces: lo0 gif0 stf0 en0 en1 wlt1 fw0
  sp_mmm_entry: 
    MMM_state: MMM_enabled
  rubyversion: 1.8.6
  facterversion: 1.3.8
  operatingsystem: Darwin
  macaddress: 00:17:f2:29:fa:59
  sshdsakey: AAAAB3NzaC1kc3MAAAEBALTlyRq+0kulTAX4A1uqISRUIlAXrmi/Yg+NGU0ExoF9vLubu+B7nsrFy2Dko4Ltw/dpgwaiZfTF58QcdFV+XfHSqFJOm69gmxpHzpqMkAxEzydoVRCERQ9ENL1L78gjJx1zU/b+uM7EkpXjlSb1MbibyiZ+0zcdDMdDL3lnLZ/nO/mdFjfxaBc93byuxx5lAed7wU2UIyIMS69w68uXzyt01zsdNJ8keE1NpEpW1Q54b4nC2vpgcAC3pUw214e7gHdtVL5qMepDOw8TIf5Ioa6FLkPbt06KZaowz7kRmCX34XFnYMCIzPvyJfJEuD7PUhcb3+oaf9aMFZtmrBwLUK8AAAAVANbCZnufmNw4gv4vCn2EPUwvU2hfAAABAE3haScdvFv0MzJ83Ckv//x5EQAGP2py8BsxRHmuk3y7VvDnVVRSwcatVWtqDwtTbfBfBBxOK5627zMEKw+2UqET4ze/cld/sH99YbuwJt5mEf0ftM3V+KzFYLLuyWMbcm0iD5QPHUzsVPENCkAYAVRSVpN8ijMEBh2LlXuMHul3RFFwzpgwHlGyEIelGpzH8UO3lDbjK3iQ/TMGxDHhJpGyFls9NFumteyfi35viTX9UgRh9jO2CBBzjvvNC45CLoaMo9xsjzKlzeBpMcfAFIGu+fRaBE4LaU2GevAC79Y/aB/AqEteUQmI+f7vQgq5ihGDTFapnyBrVG2/Hr4Z+5sAAAEAX0Hb5MwmxJxQ5pxhlWxRMiVLC8Ed9NqKWPpuCRpVDxq/OY254EMgM1TA9iIrVaXuy54xssYDIBkWEauDvRFvHFUT4y9Ar74HmvkpLoNKbcF46OuRmwuU3lmFm89RBXZwPDpj6jbjTQSuVI4dLX06Kl0h37Bi7RGcMOHnb+h8fCnEeGalKnkICniHV8VjqbAg2FrF6jNhDbIW3yTiJtS9ZWyoAhKmEpmbIIanT0CvdnuBo6/fcE2Q8JftEPR9W6uBLiJ8jzNQqYpeWfY+kn8zD/YcCLqlBqMJhc3BNuFakuWcbl0/Q2+vtNfLY1URKehIrLOVRhqM/oIcmnFgOLZw9w==
  sp_number_processors: 2
  
	-->