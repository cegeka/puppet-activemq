include cegekarepos::cegeka
Yum::Repo <| title == 'cegeka-custom-noarch' |>

class { 'activemq':
  version => '5.13.2-2.cgk.el7',
}
