require 'yaml'

raw = File.read(Rails.root.join('config', 'config.yml'))
APP_CONFIG = YAML.safe_load(raw, aliases: true)[Rails.env]