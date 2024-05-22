require 'yaml'
require_relative '../jobs/generate_heira'

# rest of the code
# require 'pry'

class OsControlsController < ApplicationController
  def show
    @os = params[:os]
    @controls = get_controls(@os)
  end

  def generate
    @os = params[:os]
    @selected_controls = params[:controls] || []
    # @yaml_content = { @os => @selected_controls }.to_yaml

    final_controls_to_show = get_final_controls(@os, @selected_controls, params['option'])

    @yaml_content = GenerateHeiraData.new.content('cis', 'server', '2', params['option'], @selected_controls, load_required_hash(final_controls_to_show), '/Users/rahul.sinha/Downloads', '', @os)

    respond_to do |format|
      format.html { render :generate }
      format.yaml { send_data @yaml_content, filename: "#{@os}_controls.yml" }
    end
  end

  private

  def get_controls(os)
    controls = {
      'RHEL8' => pick_controls_only,
      'RHEL7' => pick_controls_only,
      'AlmaLinux8' => pick_controls_only,
      'OracleLinux8' => pick_controls_only
    }
    controls[os] || []
  end

  def pick_controls_only
    controls_hash.map { |klass, details| details[:controls].keys }.flatten.map(&:to_s)
  end

  def get_final_controls(os ,selected_controls, selected_option)
    case selected_option
    when 'all'
      selected_controls
    when 'only'
      selected_controls
    when 'ignore'
      pick_controls_only - selected_controls
    end
  end

  def load_required_hash(final_controls)
    filtered_data = {}
    controls_hash.each do |class_name, class_data|
      class_data[:controls].each do |control_name, control_data|
        if final_controls.include?(control_name.to_s)
          filtered_data[control_name] = control_data
        end
      end
    end

    filtered_data
  end

  def controls_hash
    {
      "sce_linux::utils::password_creation_requirement": {
        "type": "class",
        "controls": {
          "ensure_pam_pwhistory_module_is_enabled": {
            "pw_history_module": "pam_pwhistory.so",
            "use_authtok": true
          },
          "ensure_pam_pwhistory_includes_use_authtok": "no_params",
          "ensure_pam_unix_module_is_enabled": {
            "pw_history_module": "pam_unix.so",
            "hash_algorithm": "sha512",
            "use_authtok": true,
            "shadow": true
          },
          "ensure_pam_unix_includes_a_strong_password_hashing_algorithm": "no_params",
          "ensure_pam_unix_includes_use_authtok": "no_params",
          "ensure_pam_unix_does_not_include_remember": "no_params",
          "ensure_password_number_of_changed_characters_is_configured": {
            "difok": 2
          },
          "ensure_password_length_is_configured": {
            "minlen": 14
          },
          "ensure_password_complexity_is_configured": {
            "minclass": 4,
            "dcredit": -1,
            "ucredit": -1,
            "lcredit": -1,
            "ocredit": -1
          },
          "ensure_password_same_consecutive_characters_is_configured": {
            "maxrepeat": 3
          },
          "ensure_password_maximum_sequential_characters_is_configured": {
            "maxsequence": 3
          },
          "ensure_password_dictionary_check_is_enabled": {
            "dictcheck": "1"
          },
          "ensure_password_history_remember_is_configured": {
            "remember": 24
          },
          "ensure_password_quality_is_enforced_for_the_root_user": {
            "use_root_pwquality_conf": true
          },
          "sce_options": {
            "manage_pwquality": true,
            "manage_pam_auth": true,
            "authfail": false,
            "enforce_for_root": true
          },
          "ensure_latest_version_of_pam_is_installed": {
            "install_latest_pam": true
          }
        }
      },
      "sce_linux::utils::packages::linux::cron": {
        "type": "class",
        "controls": {
          "ensure_cron_daemon_is_enabled_and_active": {
            "manage_package": true,
            "unmask_service": true,
            "manage_service": true,
            "cron_allow_path": "/etc/cron.allow",
            "manage_cron_allow": true
          },
          "ensure_permissions_on_etccrontab_are_configured": {
            "set_crontab_perms": true
          },
          "ensure_permissions_on_etccron_hourly_are_configured": {
            "set_hourly_cron_perms": true
          },
          "ensure_permissions_on_etccron_daily_are_configured": {
            "set_daily_cron_perms": true
          },
          "ensure_permissions_on_etccron_weekly_are_configured": {
            "set_weekly_cron_perms": true
          },
          "ensure_permissions_on_etccron_monthly_are_configured": {
            "set_monthly_cron_perms": true
          },
          "ensure_permissions_on_etccron_d_are_configured": {
            "set_cron_d_perms": true
          },
          "ensure_crontab_is_restricted_to_authorized_users": {
            "manage_cron_allow": true,
            "cron_allow_path": "/etc/cron.allow",
            "cron_allowlist": [
              "root"
            ],
            "purge_cron_deny": false,
            "manage_cron_deny": true
          }
        }
      }
    }
  end


end
