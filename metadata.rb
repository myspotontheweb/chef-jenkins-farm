name             'jenkins-farm'
maintainer       'Mark O''Connor'
maintainer_email 'mark@myspotontheweb.com'
license          'all_rights'
description      'Installs/Configures jenkins-farm'
long_description 'Installs/Configures jenkins-farm'
version          '0.1.1'

%w(ubuntu redhat centos scientific oracle amazon).each do |os|
  supports os
end

depends "java"
depends "jenkins"
