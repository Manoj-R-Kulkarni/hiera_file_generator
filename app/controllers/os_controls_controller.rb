require 'yaml'
# require 'pry'

class OsControlsController < ApplicationController
  def show
    @os = params[:os]
    @controls = get_controls(@os)
  end

  def generate
    @os = params[:os]
    @selected_controls = params[:controls] || []
    @yaml_content = { @os => @selected_controls }.to_yaml

    # require 'pry'
    # binding.pry

    # send_data @yaml_content, filename: "#{@os}_controls.yml"
    respond_to do |format|
      format.html { render :generate }
      format.yaml { send_data @yaml_content, filename: "#{@os}_controls.yml" }
    end
  end

  private

  def get_controls(os)
    controls = {
      'RHEL8' => ['Control 1', 'Control 2', 'Control 3'],
      'RHEL7' => ['Control A', 'Control B', 'Control C'],
      'AlmaLinux8' => ['Control X', 'Control Y', 'Control Z'],
      'OracleLinux8' => ['Control M', 'Control N', 'Control O']
    }
    controls[os] || []
  end
end
