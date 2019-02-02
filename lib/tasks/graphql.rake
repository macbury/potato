namespace :graphql do
  desc "Generate .graphqlschema"
  task schema_dump: :environment do
    schema_file = Rails.root.join('app', 'javascript', 'packs', 'graphql', '.graphqlschema')
    FileUtils.touch schema_file
    File.write(
      schema_file,
      GraphQL::Schema::Printer.print_schema(PotatoSchema),
    )
  end

  desc "Generate fragmentTypes.json for apollo"
  task introspection: :environment do
    schema_file = Rails.root.join('app', 'javascript', 'packs', 'graphql', 'fragmentTypes.json')
    query = %Q(
      {
        __schema {
          types {
            kind
            name
            possibleTypes {
              name
            }
          }
        }
      }
    )
    FileUtils.touch schema_file
    File.write(
      schema_file,
      PotatoSchema.execute(query).to_h.dig('data').to_json,
    )
  end
end
