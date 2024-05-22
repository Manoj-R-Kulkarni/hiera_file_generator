require 'yaml'
require 'json'
# generate final output heira file
class GenerateHeiraData
  # lint:ignore UnusedMethodArgument
  def content(ruleset, profile, level, selected_option, selected_controls = [], controls_with_params = {}, path, filename, os)
    final_filename = !filename.nil? ? "#{path}/#{filename}.yml" : "#{path}/#{os}.yml"
    if ruleset == 'cis'
      yaml_data = {
        'sce_linux::benchmark' => ruleset,
        'sce_linux::config' => {
          'profile' => profile,
          'level' => level.to_s
        }
      }
      # puts yaml_data
    elsif ruleset == 'stig'
      yaml_data = {
        'sce_linux::benchmark' => ruleset,
        'sce_linux::config' => {
          'mac' => level.to_s,
          'confidentiality' => profile,
        }
      }
      # puts yaml_data
    end

    if selected_option == 'only'
      yaml_data['sce_linux::config']['only'] = selected_controls
    elsif selected_option == 'ignore'
      yaml_data['sce_linux::config']['ignore'] = selected_controls
    end

    yaml_data['sce_linux::config']['control_configs'] = controls_with_params

    File.open(final_filename, 'w') do |f|
      f.write(yaml_data.to_yaml)
    end
  end
  # lint:end
end

# ruleset = 'cis'
# profile = 'server'
# level = '2'
# include_only = true
# include_ignore = false
# selected_controls = ['control_1', 'control_2', 'control_3']
# path = '/Users/rahul.sinha/Downloads'
# controls_with_params = {
#   'control_1' => {
#     'param1' => 'value1',
#   },
#   'control_2' => {
#     'param2' => 'value2',
#     'param3' => 'value3',
#   }
# }
# filename = 'test_heira_gen'
# os = 'RHEL8'
# GenerateHeiraData.new.content(ruleset, profile, level, include_only, include_ignore, selected_controls, controls_with_params, path, filename, os)
