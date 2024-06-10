require 'yaml'
require_relative '../jobs/generate_heira'

# rest of the code
# require 'pry'

class OsControlsController < ApplicationController
  def show
    @os = params[:os]
    @controls = get_controls(@os)
    @mapping_data = read_mapping_data.first[1].first[1].first[1]
  end

  def generate
    @os = params[:os]
    @selected_controls = params[:controls] || []
    @option = params[:option]
    final_controls_to_show = get_final_controls(@selected_controls, @option)

    @yaml_content = GenerateHeiraData.new.content('cis', 'server', '2', @option, @selected_controls, load_required_hash(final_controls_to_show), 'dummy/path', '', @os)

    respond_to do |format|
      format.html { render :generate }
      format.yaml { send_data @yaml_content, filename: "#{@os}_controls.yml", type: 'application/x-yaml', disposition: 'attachment' }
    end
  end

  private

  def get_controls(os)
    controls = {
      'RedHat Enterprise Linux 8' => pick_controls_only,
      'RedHat Enterprise Linux 7' => pick_controls_only,
      'Alma Linux 8' => pick_controls_only,
      'Alma Linux 7' => pick_controls_only,
      'Oracle Linux 8' => pick_controls_only,
      'Oracle Linux 7' => pick_controls_only,
      'CentOS 8' => pick_controls_only,
      'CentOS 7' => pick_controls_only,
      'Ubuntu 20' => pick_controls_only
    }
    controls[os] || []
  end

  def read_mapping_data
    @mapping_data ||= YAML.load_file(Rails.root.join('config', 'controls.yml'))
  end

  def read_resource_data
    @resource_data ||= YAML.load_file(Rails.root.join('config', 'resource_data.yml'))
  end

  def pick_controls_only
    removed_controls = %w[sce_options]
    read_resource_data.map { |_klass, details| details['controls'].keys }.flatten.map(&:to_s).reject { |control| removed_controls.include?(control)  }
  end

  def get_final_controls(selected_controls, selected_option)
    if %w[all only].include?(selected_option)
      selected_controls
    elsif selected_option.eql?('ignore')
      pick_controls_only - selected_controls
    else
      []
    end
  end

  def load_required_hash(final_controls)
    filtered_data = {}
    read_resource_data.each do |class_name, class_data|
      class_data['controls'].each do |control_name, control_data|
        if final_controls.include?(control_name)
          next if control_data.eql?('no_params')

          control_data_hash = {}
          control_data.each do |k, v|
            control_data_hash[k] = v
          end
          filtered_data[control_name] = control_data_hash
        end
      end
    end

    filtered_data
  end
end
