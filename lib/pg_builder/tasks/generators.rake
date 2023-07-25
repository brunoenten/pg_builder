require 'fileutils'
require 'pathname'
require 'erb'

namespace :generate do
  task :schema, [:schema_name] do |t, args|
    schema_root = Pathname.new(File.join(APP_PATH,'src', 'schemas', args.schema_name))

    # Directory structure
    puts schema_root
    FileUtils.mkdir schema_root
    %w[ functions sequences tables trigger_functions types ].each do |subdir|
      path_to_create = File.join(schema_root, subdir)
      puts path_to_create
      FileUtils.mkdir Pathname.new(path_to_create)
    end

    # Schema creation file
    spec = Gem::Specification.find_by_name 'pg_builder'
    template = ERB.new(File.read(File.join(spec.gem_dir, 'lib', 'pg_builder', 'templates', 'schema.sql.erb')))
    path_to_create = File.join(APP_PATH,'src', 'schemas', args.schema_name + '.sql')
    File.write(path_to_create, template.result(binding))
  end
end