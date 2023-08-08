require 'docker'
require 'rake'
require 'pg'
require 'pathname'

POSTGRES_USER = 'buildertests'
EXTENSION_SCHEMA = ENV['PG_BUILDER_EXTENSION_SCHEMA']

def execute_build(conn)
  Dir.glob('tmp/*.sql') do |sql_file|
    begin
      File.open(sql_file, 'r') { |f| conn.exec(f.read) }
    rescue PG::Error => e
      puts "Error while sourcing [#{sql_file}]"
      raise e
    end
  end
  Rake::Task.tasks.each(&:reenable)
end

# Init rake
Rake.load_rakefile('Rakefile')

begin
  existing_container = Docker::Container.get('testdb')
  existing_container.stop
  existing_container.delete
rescue Docker::Error::NotFoundError
  # nothing to do
end

File.open('./empty.nothing', 'w')

app_name = Pathname.new(Rake.original_dir).basename

docker_image = if File.exist?(File.join(Rake.original_dir, 'Dockerfile'))
  # Build a lasting image to benefit from docker cache
  tmp_image = Docker::Image.build_from_dir(Rake.original_dir)
  tmp_image.tag(repo: "pg_builder_cucumber_#{app_name}")
  Docker::Image.build_from_dir(Rake.original_dir)
else
  Docker::Image.create('fromImage' => 'postgres:15')
end

postgres_container = Docker::Container.create(
  'name' => 'testdb',
  'Image' => docker_image.id,
  'ExposedPorts' => { '5432/tcp' => {} },
  'ENV' => ['POSTGRES_HOST_AUTH_METHOD=trust', "POSTGRES_USER=#{POSTGRES_USER}"],
  'HostConfig' => {
    'Binds' => [
      File.expand_path('./empty.nothing') + ':/docker-entrypoint-initdb.d/schema.sql:ro'
    ],
    'PortBindings' => {
      '5432/tcp' => [{ 'HostPort' => '45432', 'HostIp' => '127.0.0.1' }]
    }
  }
)

postgres_container.start

tries = 0
while PG::Connection.ping(dbname: 'postgres', host: '127.0.0.1', port: '45432', user: 'buildertests') != PG::PQPING_OK
  raise 'Exceeded connection attempts to postgres' if tries > 5

  tries += 1
  sleep(1)
end

at_exit do
  postgres_container.stop
  postgres_container.delete
end
