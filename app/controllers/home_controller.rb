class HomeController < ApplicationController
  def index
    @operating_systems = ['RHEL8', 'RHEL7', 'AlmaLinux8', 'OracleLinux8']
  end
end
