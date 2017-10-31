require_relative 'platform'

module LicenseFinder
  class Configuration
    def self.with_optional_saved_config(primary_config)
      project_path = Pathname(primary_config.fetch(:project_path, Pathname.pwd)).expand_path
      config_file =  project_path.join('config', 'license_finder.yml')
      saved_config = config_file.exist? ? YAML.safe_load(config_file.read) : {}
      new(primary_config, saved_config)
    end

    def initialize(primary_config, saved_config)
      @primary_config = primary_config
      @saved_config = saved_config
    end

    def valid_project_path?
      return project_path.exist? if get(:project_path)
      true
    end

    def gradle_command
      get(:gradle_command)
    end

    def go_full_version
      get(:go_full_version)
    end

    def gradle_include_groups
      get(:gradle_include_groups)
    end

    def maven_include_groups
      get(:maven_include_groups)
    end

    def maven_options
      get(:maven_options)
    end

    def pip_requirements_path
      get(:pip_requirements_path)
    end

    def rebar_command
      get(:rebar_command)
    end

    def mix_command
      get(:mix_command) || 'mix'
    end

    def rebar_deps_dir
      path = get(:rebar_deps_dir) || 'deps'
      project_path.join(path).expand_path
    end

    def mix_deps_dir
      path = get(:mix_deps_dir) || 'deps'
      project_path.join(path).expand_path
    end

    def decisions_file_path
      path = get(:decisions_file) || 'doc/dependency_decisions.yml'
      project_path.join(path).expand_path
    end

    def project_path
      Pathname(path_prefix).expand_path
    end

    def prepare
      get(:prepare)
    end

    private

    attr_reader :saved_config

    def get(key)
      @primary_config[key.to_sym] || @saved_config[key.to_s]
    end

    def path_prefix
      get(:project_path) || ''
    end
  end
end
