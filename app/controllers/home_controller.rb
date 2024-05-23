class HomeController < ApplicationController
  def index
    @operating_systems = ['RedHat Enterprise Linux 8', 'RedHat Enterprise Linux 7', 'Alma Linux 8', 'Alma Linux 7', 
      'Oracle Linux 8', 'Oracle Linux 7', 'CentOS 8', 'CentOS 7', 'Ubuntu 20']
  end
end