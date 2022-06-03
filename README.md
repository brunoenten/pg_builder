# PgBuilder

## Installation

Install using rubygems:

    $ gem install pg_builder

## Usage

Create a file name Rakefile at the root of your project, containing these lines
```ruby
    require 'pg_builder'
    spec = Gem::Specification.find_by_name 'pg_builder'
    load "#{spec.gem_dir}/lib/Rakefile"
```

Organize your code with the following tree as an example:

```
project_root
 └── src
      └── roles
            ├── role_a.sql
            ├── role_b.sql
            ├── ...
      └── schemas
             └── schema_a
                    └── functions
                           ├── function_a.sql
                           ├── function_b.sql
                           ├── ...
                    └── sequences
                           ├── sequence_a.sql
                           ├── sequence_b.sql
                           ├── ...
                    └── tables
                           ├── table_a.sql
                           ├── table_b.sql
                           ├── ...
                    └── trigger_functions
                           ├── trigger_a.sql
                           ├── trigger_b.sql
                           ├── ...
                    └── types
                           ├── type_a.sql
                           ├── type_b.sql
                           ├── ...
             ├── schema_a.sql
             ├── schema_b.sql
             ├── ...

```

In each file, specify dependencies, if any, by using the following format as the file's first line:
```sql
  --depends_on: ['path1', 'path2', ...]
```
where path is the filepath of the object without the sql extension, using : as a directory separator, and :: as the root folder (/src).

Example:
File src/schemas/schema_a/table_a.sql
```sql
  --depends_on: ['::schemas:schema_a:types:type_a', '::schemas:schema_a:sequences:sequence_a', 'table_b']
```

To build the schema, just run rake with no argument
To run tests, run cucumber with no argument



## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pg_builder.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
