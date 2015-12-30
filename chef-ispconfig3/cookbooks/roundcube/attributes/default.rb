default['roundcube']['version'] = '1.0.2'
default['roundcube']['download_url'] = "https://github.com/roundcube/roundcubemail/releases/download/#{node['roundcube']['version']}/roundcubemail-#{node['roundcube']['version']}.tar.gz"
default['roundcube']['download_checksum'] = '1c1560a7a56e6884b45c49f52961dbbb3f6bacbc7e7c755440750a1ab027171c'
default['roundcube']['install_dir'] = '/srv'
default['roundcube']['default_host'] = 'ssl://imap.gmail.com:993'
default['roundcube']['support_url'] = ''
default['roundcube']['product_name'] = 'Roundcube Webmail'
default['roundcube']['skin'] = 'larry'
default['roundcube']['listen_port'] = 80
default['roundcube']['server_name'] = 'localhost'
default['roundcube']['database']['user'] = 'roundcube'
default['roundcube']['database']['password'] = 'secure_password'
default['roundcube']['database']['schema'] = 'roundcubemail'
default['roundcube']['smtp']['server'] = 'tls://smtp.gmail.com'
default['roundcube']['smtp']['port'] = 587
default['roundcube']['smtp']['user'] = '%u'
default['roundcube']['smtp']['password'] = '%p'