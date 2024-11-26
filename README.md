# PgBuilder

PgBuilder is a Ruby gem designed to simplify the management and deployment of PostgreSQL database objects. 
It organizes your SQL scripts into a structured directory and uses Rake tasks to manage roles, schemas, tables, 
functions, and more in your PostgreSQL projects.

## Features

- **Organized Structure**: Organize your database objects (roles, schemas, tables, functions, sequences) in a clear and manageable hierarchy.
- **Rake Integration**: Leverage Rake tasks to automate the deployment and management of SQL resources.
- **Extensible Design**: Customize and extend the structure to fit your project's needs.

## Installation

Install PgBuilder using RubyGems:

```bash
$ gem install pg_builder
```

## Usage

1. Create a file named `Rakefile` at the root of your project with the following content:
```ruby
    require 'pg_builder'
    spec = Gem::Specification.find_by_name 'pg_builder'
    load "#{spec.gem_dir}/lib/Rakefile"
```

2. Organize your code with the following tree as an example:

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

3. To build the schema, just run rake with no argument
   
4. To run tests, run cucumber with no argument

## Directory Structure

The default structure encourages modular and reusable SQL components. You can organize objects by roles, schemas, and specific types (tables, functions, etc.).

- `roles/`: Contains role definitions.
- `schemas/`: Contains schemas and their associated objects, such as tables, functions, and sequences.

## Example

Here’s an example of deploying a new schema with tables and functions:

1. Create a new schema directory under `src/schemas/`.
2. Add SQL scripts for tables and functions in the appropriate subdirectories.
3. Run the build task:
   ```bash
   $ rake
   ```

PgBuilder will process the SQL scripts in the specified order and apply them to the database.

## Contributing

We welcome contributions! If you have ideas, bug fixes, or enhancements, please fork the repository and submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE.txt](LICENSE.txt) file for details.

## Acknowledgments

Special thanks to the PostgreSQL community for their continuous support and inspiration for tools like this.

---

*Note: This tool is a community-driven project and is not officially affiliated with the PostgreSQL Global Development Group.*
