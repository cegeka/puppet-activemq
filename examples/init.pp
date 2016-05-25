include cegekarepos::cegeka
Yum::Repo <| title == 'cegeka-custom-noarch' |>

class { 'activemq':
  version => '5.10.0-2.cgk.el6',
}
